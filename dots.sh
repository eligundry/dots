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
exclude=("README.markdown" "LICENSE" "dots.sh" "config" "tmuxline.conf"
         "tmux-sessions" "local" "bashrc" "bash_profile",
         "iterm2_profiles.json")

if [[ $platform == "Darwin" ]]; then
    exclude+=("gtkrc-2.0" "xinitrc")
fi

# Colors
B_RED='\033[1;31m'
B_GREEN='\033[1;32m'
RESET='\033[0m'

# Helper Methods

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
    seperator $B_GREEN"Linking custom files…"

    local CF_LOC="$PWD/config"
    local CF_DEST="$HOME/.config"

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

git_repos()
{
    seperator $B_GREEN"Cloning git repos…"
    mkdir -v $HOME/.lib
    git clone https://github.com/jimeh/tmuxifier.git $HOME/.lib/tmuxifier
    git clone https://github.com/chriskempson/base16-shell.git $HOME/.lib/base16-shell
    git clone https://github.com/pipeseroni/pipes.sh.git $HOME/.lib/pipes
    git clone https://github.com/eligundry/dotty.git $HOME/.lib/dotty
    git clone https://github.com/zplug/zplug.git $HOME/.lib/zplug
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
        custom_links
        git_repos
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
    'clean' | '-c' | '--clean')
        clean
    ;;
esac
