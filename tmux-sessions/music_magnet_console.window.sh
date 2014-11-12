new_window "console"

run_cmd "source $VENV_PATH/mm-server/bin/activate"

split_h 50
run_cmd "source $VENV_PATH/mm-server/bin/activate"
run_cmd "bpython"

select_pane 0
