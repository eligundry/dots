session_root "~/Code/landscape"

if initialize_session "landscape"; then
	load_window "landscape_vim"
	load_window "landscape_terminal"
	select_window 1
fi

finalize_and_go_to_session
