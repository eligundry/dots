#!/bin/bash
# Bring the app that's currently playing media to the foreground.
# Wired up to a click on the now-playing widget in the tmux status bar.

if command -v playerctl &> /dev/null; then
  allowed_players=("spotify" "rhythmbox" "clementine" "chrome")

  for player in "${allowed_players[@]}"; do
    if [[ "$(playerctl -p "$player" status 2>/dev/null)" == "Playing" ]]; then
      if command -v wmctrl &> /dev/null; then
        wmctrl -x -a "$player"
      fi
      exit
    fi
  done
fi

command -v osascript &> /dev/null || exit

focus_chrome_tab() {
  osascript "$HOME/.tmux/scripts/chrome-focus.js" 2>/dev/null
}

# The media remote knows exactly which app owns playback
if command -v nowplaying-cli &> /dev/null; then
  bundle="$(nowplaying-cli get ClientBundleIdentifier 2>/dev/null)"
  if [ -n "$bundle" ] && [ "$bundle" != "null" ]; then
    case "$bundle" in
      com.google.Chrome*) focus_chrome_tab && exit ;;
    esac

    open -b "$bundle" && exit
  fi
fi

if [ "$(osascript -e 'application "Spotify" is running' 2>/dev/null)" == "true" ]; then
  osascript -e 'tell application "Spotify" to activate' > /dev/null 2>&1
  exit
fi

focus_chrome_tab
