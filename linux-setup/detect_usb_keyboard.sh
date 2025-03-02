#!/bin/bash

CONFIG_FILE="$HOME/.config/i3/config"

if grep -i "keyboard" /proc/bus/input/devices | grep -i "usb"; then
    MOD_KEY="Mod1"
else
    MOD_KEY="Mod4"
fi

# Replace $mod in the i3 config
sed -i "s/^set \$mod .*/set \$mod $MOD_KEY/" "$CONFIG_FILE"

# Restart i3 to apply changes
i3-msg restart
