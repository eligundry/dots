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

NOW_PLAYING=$(osascript <<EOF
set spotify_state to false
set itunes_state to false

if is_app_running("Spotify") then
  tell application "Spotify" to set spotify_state to (player state as text)
end if
if is_app_running("iTunes") then
  tell application "iTunes" to set itunes_state to (player state as text)
end if
(* Whatever other music applications you use *)

if spotify_state is equal to "playing" then
  tell application "Spotify"
    set track_name to name of current track
    set artist_name to artist of current track
    return track_name & " - #[bold]" & artist_name & "#[nobold]"
  end tell
else if itunes_state is equal to "playing" then
  tell application "iTunes"
    set track_name to name of current track
    set artist_name to artist of current track
    return track_name & " - #[bold]" & artist_name & "#[nobold]"
  end tell
else
  return "Nothing playing :("
end if

on is_app_running(app_name)
  tell application "System Events" to (name of processes) contains app_name
end is_app_running
EOF
)

echo "$NOW_PLAYING"
exit

fi

echo "😴"
