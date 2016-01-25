new_window "gemsafe_terminal"

split_h 50
split_v 50
split_v 50

run_cmd "vagrant up && vagrant ssh" 1
send_keys "vagrant ssh -c 'cd gemsafe && fab server'" 2
run_cmd "gulp" 3

select_pane 0
