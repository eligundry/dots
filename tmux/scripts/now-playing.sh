#!/bin/bash

if [[ "$(playerctl -p spotify status)" == "Playing" ]]; then
    echo "🎶 $(playerctl -p spotify metadata title) - $(playerctl -p spotify metadata artist)"
else
    echo "😴"
fi
