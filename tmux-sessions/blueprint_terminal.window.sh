new_window "blueprint_terminal"

split_h 50
split_v 50

run_cmd "vagrant up && vagrant ssh" 1
run_cmd "gulp"

select_pane 0
