new_window "gemsafe_terminal"

split_h 50
split_v 50
split_v 50

run_cmd "source .env/bin/activate"
run_cmd "source .env/bin/activate && vagrant up && vagrant ssh" 1
send_keys "source .env/bin/activate && vagrant ssh -c 'cd gemsafe && fab server'; notify-send 'Flask server crashed' --icon=dialog-error" 2
run_cmd "source .env/bin/activate && gulp" 3

select_pane 0
