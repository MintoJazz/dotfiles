#!/bin/bash

theme="~/.config/rofi/meu-tema/applets.rasi"

# Get battery info using acpi
acpi_output=$(acpi -b)

# Extract status and percentage
status=$(echo "$acpi_output" | awk -F', ' '{print $1}' | awk '{print $3}')
percentage=$(echo "$acpi_output" | awk -F', ' '{print $2}')

# Prepare time info if discharging
if [[ "$status" == "Discharging" ]]; then
    raw_time=$(echo "$acpi_output" | awk -F', ' '{print $3}')
    # Extract hours and minutes
    hours=$(echo "$raw_time" | cut -d: -f1 | sed 's/^0*//')
    minutes=$(echo "$raw_time" | cut -d: -f2 | sed 's/^0*//')
    hours=${hours:-0}
    minutes=${minutes:-0}
    time_output=" Remaining: ${hours} hours, ${minutes} minutes"
else
    time_output=""
fi

# Build menu options
options="$(./battery.sh) $percentage ($status)"
if [[ -n "$time_output" ]]; then
    options="$options\n$time_output"
fi
options="$options\n󰒓 Open Power Manager"

# Launch rofi with custom theme
chosen=$(echo -e "$options" | rofi -dmenu -theme $theme -p "Battery"Fi)

# Handle selection
case "$chosen" in
    *"Open Power Manager"*)
        xfce4-power-manager-settings &
        ;;
esac

