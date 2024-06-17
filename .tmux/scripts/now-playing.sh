#!/bin/bash

if command -v playerctl &> /dev/null; then
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
fi

if command -v osascript &> /dev/null; then
  output="$(osascript "$HOME/.tmux/scripts/spotify.applescript")"
  spotify_is_running="$(echo "$output" | jq 'has("error") | not')"

  if [ "$spotify_is_running" == "true" ]; then
    echo "$output" | jq -r '"💿 \(.name[0:30]) - \(.artist[0:30])"'
    exit
  fi
fi

echo "💿😴"
