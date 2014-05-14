#!/bin/bash

################################################################################
# @name: dots.sh
# @author: Eli Gundry
# @description: Simple bash script to install dotfiles to home directory.
################################################################################

# Get files
files=(*)

# Determine platform
platform=`uname`

# Exclude files
exclude=("README.markdown" "LICENSE" "oh-my-zsh" "dots.sh" "config" "tmuxline.conf" "tmux-sessions")

if [[ $platform == "Darwin" ]]; then
	exclude+=("gtkrc-2.0" "Xresources" "xinitrc" "Xdefaults")
fi

# Colors
B_RED='\033[1;31m'
B_GREEN='\033[1;32m'
RESET='\033[0m'

# Helper Methods

git_modules()
{
	seperator $B_GREEN"Setting up Git submodules…"
	git submodule init
	git submodule update
}

link_file()
{
	# Check if file is in the exclude array
	for e in "${exclude[@]}"
	do
		if [ "$1" = "$e" ]; then
			return
		fi
	done

	if [[ ! -d "$1" ]]; then
		ln -vfs "$PWD/$1" "$HOME/.$1"
	else
		ln -vfsn "$PWD/$1" "$HOME/.$1"
	fi
}

custom_links()
{
	seperator $B_GREEN"Linking custom Oh-My-ZSH files…"

	ZPATH="$PWD/oh-my-zsh/custom"
	OZPATH="$HOME/.oh-my-zsh/custom"
	CF_LOC="$PWD/config"
	CF_DEST="$HOME/.config"

	mkdir "$OZPATH/plugins"

	ln -vfs $ZPATH/eligundry.zsh-theme $OZPATH/eligundry.zsh-theme
	ln -vfs $ZPATH/plugins/zsh-completions $OZPATH/zsh-completions
	ln -vfs $ZPATH/plugins/zsh-history-substring-search $OZPATH/plugins/zsh-history-substring-search
	ln -vfs $ZPATH/plugins/zsh-syntax-highlighting $OZPATH/plugins/zsh-syntax-highlighting

	seperator $B_GREEN"Linking Pianobar files…"
	ln -vfsn "$CF_LOC/pianobar" "$CF_DEST/pianobar"

	if [[ $platform == "Linux" ]]; then
		linux_custom_links
	fi
}

linux_custom_links()
{
	seperator $B_GREEN"Linking Terminator files…"
	ln -vfsn "$CF_LOC/terminator" "$CF_DEST/terminator"
}

seperator()
{
	echo ""
	echo "================================================================================"
	echo -e "$1$RESET"
	echo "================================================================================"
	echo ""
}

# Sets up dot files in home directory
install()
{
	seperator $B_GREEN"Linking dotfiles…"

	for file in "${files[@]}"
	do
		link_file $file
	done
}

# Install oh-my-zsh from GitHub
install_oh_my_zsh()
{
	seperator $B_GREEN"Install Oh-My-ZSH? [yn]"
	read yn

	case $yn in
		[yY] | [yY][Ee][sS])
			seperator $B_RED"Deleting $HOME/.oh-my-zsh"
			rm -rf "$HOME/.oh-my-zsh"
			seperator $B_GREEN"Installing Oh-My-ZSH…"
			git clone "https://github.com/robbyrussell/oh-my-zsh.git" "$HOME/.oh-my-zsh"
		;;
		[nN] | [nN][oO])
			echo "Skipping Oh-My-ZSH"
	esac

	if [ "$SHELL" = "/bin/zsh" -o "$SHELL" = "/usr/bin/zsh" ]; then
		seperator $B_GREEN"Using ZSH. Good for you!"
	else
		seperator $B_RED"Switch to ZSH? [yn]"
		read switch_to_zsh

		case $switch_to_zsh in
			[yY] | [yY][Ee][sS])
				echo "Switching to ZSH…"
				chsh -s `which zsh`
			;;
			[nN] | [nN][oO])
				echo "Leaving shell as $SHELL."
		esac
	fi
}

update()
{
	seperator $B_GREEN"Updating dots repository…"
	git pull
	seperator $B_GREEN"Updating Git submodules…"
	git submodule foreach git pull origin master
	echo "Completed updating repository"
	seperator $B_GREEN"Updating Vim modules…"
	vim -c BundleInstall -c qall!
}

clean()
{
	seperator $B_RED"Uninstalling dots…"

	home_files=($HOME/.*)

	for f in "${home_files[@]}"
	do
		# If symbolic link, delete it
		if [[ -L "$f" ]]; then
			rm -fv "$f"
		fi
	done

	seperator $B_RED"Uninstalling Oh-My-ZSH…"

	rm -rf "$HOME/.oh-my-zsh"
	echo "Uninstalled Oh-My-ZSH!"

	seperator $B_RED"Removing Pianobar config…"

	rm -rf "$HOME/.config/pianobar"
	echo "Removed Pianobar config!"

	if [[ $platform == 'Linux' ]]; then
		linux_custom_clean
	fi
}

linux_custom_clean()
{
	seperator $B_RED"Removing Terminator config…"
	rm -rf "$HOME/.config/terminator"
	echo "Removed Terminator config!"
}

display_help()
{
	echo "dots installer"
	echo ""
	echo "Usage: ./dots.sh [command]"
	echo ""
	echo "install | -i:   Gets Git modules and links dotfiles"
	echo "relink  | -r:   Relink files"
	echo "update  | -u:   Update repo and submodules"
	echo "omz     | -o:   Install Oh-My-ZSH from GitHub"
	echo "clean   | -c:   Remove all installed files"
	echo "help    | -h:   Display this help message"
	exit
}

# Run the script

if [[ -z $# ]]; then
	display_help
fi

case "$1" in
	'install' | '-i')
		git_modules
		install
		install_oh_my_zsh
		update
		custom_links
	;;
	'relink' | '-r')
		install
		custom_links
	;;
	'help' | '-h')
		display_help
	;;
	'update' | '-u')
		update
	;;
	'omz' | '-o')
		install_oh_my_zsh
	;;
	'clean' | '-c')
		clean
	;;
esac
