session_root "~/Code/music-magnet-server"

if initialize_session "music-magnet-server"; then

	load_window music_magnet_vim
	load_window music_magnet_console
	select_window 1

fi

finalize_and_go_to_session
