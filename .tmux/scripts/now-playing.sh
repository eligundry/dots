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

if command -v nowplaying-cli &> /dev/null && [ "$(nowplaying-cli get-raw 2>/dev/null)" != "(null)" ]; then
  np_state="$(nowplaying-cli get playbackRate 2>/dev/null)"
  if [ "$np_state" == "1" ]; then
    np_title="$(nowplaying-cli get title 2>/dev/null)"
    np_artist="$(nowplaying-cli get artist 2>/dev/null)"
    if [ -n "$np_title" ] && [ "$np_title" != "null" ]; then
      if [ -n "$np_artist" ] && [ "$np_artist" != "null" ]; then
        echo "🎶 ${np_artist:0:30} - ${np_title:0:30}"
      else
        echo "🎶 ${np_title:0:60}"
      fi
      exit
    fi
  fi
fi

if command -v osascript &> /dev/null; then
  # Check Spotify
  spotify_output="$(osascript "$HOME/.tmux/scripts/spotify.applescript" 2>/dev/null)"
  spotify_is_running="$(echo "$spotify_output" | jq 'has("error") | not')"
  if [ "$spotify_is_running" == "true" ]; then
    echo "$spotify_output" | jq -r '"💿 \(.name[0:30]) - \(.artist[0:30])"'
    exit
  fi

  # Check Chrome tabs on music sites
  chrome_title="$(osascript "$HOME/.tmux/scripts/chrome-now-playing.js" 2>/dev/null)"
  if [ -n "$chrome_title" ]; then
    echo "🎶 ${chrome_title:0:60}"
    exit
  fi
fi

echo "💿😴"
