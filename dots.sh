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
exclude=("README.markdown" "LICENSE" "oh-my-zsh" "dots.sh" "config"
		 "tmuxline.conf" "tmux-sessions" "local" "bashrc" "bash_profile",
		 "iterm2_profiles.json")

if [[ $platform == "Darwin" ]]; then
	exclude+=("gtkrc-2.0" "xinitrc")
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

	local ZPATH="$PWD/oh-my-zsh/custom"
	local OZPATH="$HOME/.oh-my-zsh/custom"
	local CF_LOC="$PWD/config"
	local CF_DEST="$HOME/.config"

	ln -vfs $ZPATH/eligundry.zsh-theme $OZPATH/eligundry.zsh-theme
	ln -vfs $ZPATH/plugins/zsh-completions $OZPATH/zsh-completions
	ln -vfs $ZPATH/plugins/zsh-history-substring-search $OZPATH/plugins/zsh-history-substring-search
	ln -vfs $ZPATH/plugins/zsh-syntax-highlighting $OZPATH/plugins/zsh-syntax-highlighting
	ln -vfs $ZPATH/plugins/keybase $OZPATH/plugins/keybase
	ln -vfsn "$CF_LOC/nvim" "$CF_DEST/nvim"

	if [[ $platform == "Linux" ]]; then
		linux_custom_links
	fi
}

linux_custom_links()
{
	seperator $B_GREEN"Linking custom Linux files…"
	ln -vfsn "$CF_LOC/terminator" "$CF_DEST/terminator"
	ln -vfsn "$CF_LOC/systemd" "$CF_DEST/systemd"
	ln -vfs "$CF_LOC/redshift.conf" "$CF_DEST/redshift.conf"
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
	echo "Completed updating repository!"

	seperator $B_GREEN"Updating Vim bundles…"
	vim -c PlugClean -c PlugInstall -c PlugeUpdate -c qall!
	echo "Completed updating Vim bundles!"

	seperator $B_GREEN"Updating NeoVim bundles…"
	nvim -c PlugClean -c PlugInstall -c PlugeUpdate -c qall!
	echo "Completed updating NeoVim bundles!"
}

clean()
{
	seperator $B_RED"Uninstalling dots…"

	local home_files=($HOME/.*)

	for f in "${home_files[@]}"
	do
		# If symbolic link, delete it
		if [[ -L "$f" ]]; then
			rm -fv "$f"
		fi
	done

	seperator $B_RED"Uninstalling Oh-My-ZSH…"
	rm -rfv "$HOME/.oh-my-zsh"

	seperator $B_RED"Removing Pianobar config…"
	rm -rfv "$HOME/.config/pianobar"
	rm -rfv "$CF_LOC/nvim" "$CF_DEST/nvim"

	if [[ $platform == 'Linux' ]]; then
		linux_custom_clean
	fi
}

linux_custom_clean()
{
	seperator $B_RED"Removing Terminator config…"
	rm -rfv "$HOME/.config/terminator"
	rm -rfv "$HOME/.config/systemd"
	rm -rfv "$HOME/.config/redshift.conf"
}

display_help()
{
	echo "dots installer"
	echo ""
	echo "Usage: ./dots.sh [command]"
	echo ""
	echo "[--]install | -i:   Gets Git modules and links dotfiles"
	echo "[--]relink  | -r:   Relink files"
	echo "[--]update  | -u:   Update repo and submodules"
	echo "[--]omz     | -o:   Install Oh-My-ZSH from GitHub"
	echo "[--]clean   | -c:   Remove all installed files"
	echo "[--]help    | -h:   Display this help message"
	exit
}

# Run the script

if [[ "$#" -eq 0 ]]; then
	display_help
fi

case "$1" in
	'install' | '-i' | '--install')
		git_modules
		install
		install_oh_my_zsh
		custom_links
	;;
	'relink' | '-r' | '--relink')
		install
		custom_links
	;;
	'help' | '-h' | '--help')
		display_help
	;;
	'update' | '-u' | '--update')
		update
	;;
	'omz' | '-o' | '--omz')
		install_oh_my_zsh
	;;
	'clean' | '-c' | '--clean')
		clean
	;;
esac
