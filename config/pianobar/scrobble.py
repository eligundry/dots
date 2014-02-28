#!/usr/bin/env python
"""
Last.fm scrobbling for Pianobar, the command-line Pandora client. Requires Pianobar, Python, pyLast and Last.fm API credentials.

https://github.com/PromyLOPh/pianobar/
http://code.google.com/p/pylast/
http://www.last.fm/api/account

Installation:
1) Copy this script and pylast.py to the Pianobar config directory, ~/.config/pianobar/, and make sure this script is executable
2) Supply your own Last.fm credentials below
3) Update Pianobar's config file to use this script as its event_command
"""

import os
import sys
import time
import yaml

file_path = '%s/passwords.yml' % os.environ['PWD']

API_KEY = "67a8b1b089b893b4cc2307c6b981e605"
API_SECRET = "4c1834beb423127ddb76cc8ae2b89cfd"
USERNAME = "eli_pwnd"
PASSWORD = yaml.load(open(file_path, 'r'))['last_fm']
THRESHOLD = 50 # the percentage of the song that must have been played to scrobble

def main():

  event = sys.argv[1]
  lines = sys.stdin.readlines()
  fields = dict([line.strip().split("=", 1) for line in lines])

  # fields: title, artist, album, songDuration, songPlayed, rating, stationName, pRet, pRetStr, wRet, wRetStr
  artist = fields["artist"]
  album = fields["album"]
  title = fields["title"]
  song_duration = int(fields["songDuration"])
  song_played = int(fields["songPlayed"])

  import pylast
  network = pylast.LastFMNetwork(api_key = API_KEY, api_secret = API_SECRET, username = USERNAME, password_hash = pylast.md5(PASSWORD))
  # events: songstart, songfinish, ???
  if event == "songfinish" and song_duration > 0 and 100.0 * song_played / song_duration > THRESHOLD:
    song_started = int(time.time() - song_played / 1000.0)
    network.scrobble(artist = artist, title = title, timestamp = song_started)
  if event == "songstart":
    network.update_now_playing(artist = artist, album = album, title = title, duration = song_duration)

if __name__ == "__main__":
  main()
