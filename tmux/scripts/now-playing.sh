#!/bin/bash

allowed_players=("spotify" "rhythmbox" "clementine" "chrome")
format="🎶 {{artist}} - {{title}}"
chrome_format="🎶 {{title}}"

for player in "${allowed_players[@]}"; do
    if [[ "$(playerctl -p "$player" status)" == "Playing" ]]; then
        if [[ "$player" == "chrome" ]]; then
            format=$chrome_format
        fi

        playerctl -p "$player" metadata --format "$format"
        exit
    fi
done

echo "😴"
