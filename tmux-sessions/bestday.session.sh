session_root "~/Code/Croscon/bestday"

if initialize_session "bestday"; then
  load_window "vim"
  load_window "bestday_terminal"
  select_window 1
fi

finalize_and_go_to_session
