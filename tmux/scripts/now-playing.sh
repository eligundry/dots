#!/bin/bash

if [[ "$(playerctl -p spotify status)" == "Playing" ]]; then
    playerctl -p spotify metadata --format "🎶 {{artist}} - {{title}}"
else
    echo "😴"
fi
