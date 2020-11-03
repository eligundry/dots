#!/bin/bash

if [[ "$(playerctl -p spotify status)" == "Playing" ]]; then
    playerctl -p spotify metadata --format "🎶 {{artist}} - {{title}}"
elif [[ "$(playerctl -p chrome status)" == "Playing" ]]; then
    playerctl -p chrome metadata --format "🎶 {{title}}"
else
    echo "😴"
fi
