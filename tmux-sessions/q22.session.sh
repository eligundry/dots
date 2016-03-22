session_root "~/Code/Croscon/GROOWM-Q22"

if initialize_session "q22"; then
	load_window "vim"
	load_window "q22_terminal"
	select_window 1
fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
