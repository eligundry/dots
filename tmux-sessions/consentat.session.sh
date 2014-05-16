# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "/mnt/Windows8/Users/Eli/Documents/tattoo-xdk"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "consentat"; then
	new_window "vim"
	run_cmd "vim"

	new_window "shell"

	new_window "long-running"
	split_h
	run_cmd "python2 serve.py"
	run_cmd "intel-xdk"
fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
