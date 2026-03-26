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

if command -v nowplaying-cli &> /dev/null; then
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

    # nowplaying-cli can control playback but has no metadata (e.g. Chrome)
    # Fall through to check Chrome tabs for music sites
  fi
fi

if command -v osascript &> /dev/null; then
  chrome_title="$(osascript "$HOME/.tmux/scripts/chrome-now-playing.js" 2>/dev/null)"
  if [ -n "$chrome_title" ]; then
    echo "🎶 ${chrome_title:0:60}"
    exit
  fi
fi

echo "💿😴"
