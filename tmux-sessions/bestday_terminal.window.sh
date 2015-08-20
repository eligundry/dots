new_window "bestday_terminal"

split_h 50
split_v 50
split_v 50

run_cmd "source packages/bin/activate"
run_cmd "source packages/bin/activate && ssh tswizzle"
run_cmd "source packages/bin/activate && fab server" 2
run_cmd "source packages/bin/activate && gulp" 3


select_pane 0
