#!/bin/bash
BATT_PATH="/sys/class/power_supply/BAT0"

if [ -f "$BATT_PATH/capacity" ]; then
    CAP=$(cat "$BATT_PATH/capacity")
    STATUS=$(cat "$BATT_PATH/status")

    if [ "$STATUS" = "Charging" ]; then
        ICON="⚡"
    elif [ "$STATUS" = "Full" ]; then
        ICON="✔"
    else
        ICON="🔋"
    fi

    echo "$ICON $CAP%"
else
    echo "N/A"
fi
