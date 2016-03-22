new_window "weber_terminal"

split_h 50
split_v 50
split_v 50

run_cmd "source .env/bin/activate && clear"
run_cmd "vagrant up && clear && vagrant ssh" 1
send_keys "vagrant ssh -c 'docker stop weber-mobilecommand-web && cd /opt/weber-mobilecommand && inv server'" 2
run_cmd "gulp" 3

select_pane 0
