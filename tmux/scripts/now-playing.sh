#!/bin/bash

if [[ "$(playerctl status)" == "Playing" ]]; then
    echo "🎶 $(playerctl metadata title) - $(playerctl metadata artist)"
else
    echo "😴"
fi
