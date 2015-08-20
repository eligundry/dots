session_root "~/Code/Croscon/gemsafe"

if initialize_session "gemsafe"; then
	load_window "vim"
	load_window "gemsafe_terminal"
	select_window 1
fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
