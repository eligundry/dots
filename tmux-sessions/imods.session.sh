# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/Code/imods-webapp"

if initialize_session "imods"; then
	new_window "vim"
	run_cmd "vim -p  composer.json ../imods-vagrant/Vagrantfile"

	new_window "vagrant"
	split_h
	run_cmd "cd ../imods-vagrant; vagrant up"

	select_window 1
fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
