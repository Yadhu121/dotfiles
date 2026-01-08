#!/bin/bash

if ! bluetoothctl show | grep -q "Powered: yes"; then
  echo ""
  exit 0
fi

if bluetoothctl info | grep -q "Connected: yes"; then
  echo ""
else
  echo ""
fi

