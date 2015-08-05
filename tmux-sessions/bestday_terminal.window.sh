new_window "bestday_terminal"

split_h 50
split_v 50

run_cmd "source .env/bin/activate"
run_cmd "source .env/bin/activate && fab server" 1
run_cmd "source .env/bin/activate && gulp" 2


select_pane 0
