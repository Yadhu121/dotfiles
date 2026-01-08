#!/bin/bash

ICON_OFF=""
ICON_ON=""
ICON_SCAN=""
ICON_DEVICE=""
ICON_PAIRED=""

# Check Bluetooth power
power_status=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')
power_icon=$([[ "$power_status" == "yes" ]] && echo "$ICON_ON" || echo "$ICON_OFF")

# Menu header options
menu="$power_icon Toggle Bluetooth Power\n$ICON_SCAN Scan for Devices\n"

# Get paired devices
while IFS= read -r line; do
    mac=$(echo "$line" | awk '{print $2}')
    name=$(echo "$line" | cut -d ' ' -f 3-)
    connected=$(bluetoothctl info "$mac" | grep "Connected: yes")
    status="$ICON_PAIRED"
    if [[ -n "$connected" ]]; then
        status+=" (Connected)"
    fi
    menu+="$status $name\n"
done < <(bluetoothctl paired-devices)

# Show menu
chosen=$(echo -e "$menu" | wofi --show dmenu --prompt "Bluetooth" --width 400 --hide-scroll)

# Handle choice
if [[ "$chosen" == *"Toggle Bluetooth Power"* ]]; then
    if [[ "$power_status" == "yes" ]]; then
        bluetoothctl power off
    else
        bluetoothctl power on
    fi

elif [[ "$chosen" == *"Scan for Devices"* ]]; then
    # Start scan for 10 seconds
    bluetoothctl scan on &
    sleep 10
    bluetoothctl scan off

    # List newly found devices
    devices=$(bluetoothctl devices | awk '{print $2" "$3" "$4" "$5" "$6}')
    if [[ -z "$devices" ]]; then
        notify-send "Bluetooth" "No devices found"
        exit 0
    fi

    # Show devices found for pairing
    device_choice=$(echo -e "$devices" | wofi --show dmenu --prompt "Pair device" --width 400)
    if [[ -n "$device_choice" ]]; then
        mac=$(echo "$device_choice" | awk '{print $1}')
        # Pair and connect
        bluetoothctl pair "$mac"
        bluetoothctl connect "$mac"
    fi

else
    # User selected a paired device
    # Find MAC from device name
    dev_name=$(echo "$chosen" | sed -E "s/^.* (.+)$/\1/")
    mac=$(bluetoothctl paired-devices | grep "$dev_name" | awk '{print $2}')

    if [[ -n "$mac" ]]; then
        # Toggle connection
        connected=$(bluetoothctl info "$mac" | grep "Connected: yes")
        if [[ -n "$connected" ]]; then
            bluetoothctl disconnect "$mac"
        else
            bluetoothctl connect "$mac"
        fi
    fi
fi

