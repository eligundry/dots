source_files () {
	tmux_home=~/.tmux
	platform=`uname`

	if [[ $platform == 'Darwin' ]]; then
		tmux source-file "$tmux_home/osx.conf"
	fi

	if [[ $plaform == 'Linux' ]]; then
		tmux source-file "$tmux_home/linux.conf"
	fi
}
