new_window "treeshield-console"

split_h 50
run_cmd "php app/console server:run 0.0.0.0:8000"

select_pane 0
