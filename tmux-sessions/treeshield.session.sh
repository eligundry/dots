session_root "~/Code/treeshield"

if initialize_session "treeshield"; then
	load_window "vim"
	load_window "treeshield_console"
	select_window 1
fi

finalize_and_go_to_session
