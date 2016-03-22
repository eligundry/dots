session_root "~/Code/Croscon/weber"

if initialize_session "weber"; then

	load_window "vim"
	load_window "weber_terminal"
	select_window 1

fi

finalize_and_go_to_session
