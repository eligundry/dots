new_window "hfa_terminal"

split_h 50
split_v 50
split_v 50

run_cmd "source .env/bin/activate" 0
run_cmd "source .env/bin/activate && vagrant up && vagrant ssh" 1
run_cmd "source .env/bin/activate && fab server" 2
run_cmd "source .env/bin/activate && gulp" 3

select_pane 0
