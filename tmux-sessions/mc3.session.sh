session_root "~/Code/Croscon/mc3lite"

if initialize_session "mc3"; then
	load_window "vim"
	load_window "mc3_terminal"
	select_window 1
fi

finalize_and_go_to_session
