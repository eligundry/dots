session_root "~/Code/Croscon/hfa"

if initialize_session "hfa"; then
	load_window "vim"
	load_window "hfa_terminal"
	select_window 1
fi

finalize_and_go_to_session
