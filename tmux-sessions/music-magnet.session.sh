session_root "~/Code/music-magnet-server"

if initialize_session "music-magnet"; then
	load_window "mm_vim"
	load_window "mm_console"
	select_window 1
fi

finalize_and_go_to_session
