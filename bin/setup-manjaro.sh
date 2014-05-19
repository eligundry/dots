#!/bin/bash

nc='--noconfirm'

# Remove crappy apps I never use and their dependencies
yaourt -R libreoffice hexchat thunderbird xnoise mdm mdm-themes
yaourt -Qdt $nc

# Update the system (twice for system updates)
yaourt -Syua $nc
yaourt -Syua $nc

# Install my favorite applications
yaourt -S vim tmux zsh terminator synapse clementine qbittorrent \
	python2-virtualenv python-virtualenv pianobar git subversion openssh mosh \
	gnome-disk-utility python-pip python2-pip ipython ipython2 vagrant slim \
	slim-themes

yaourt -Sa $nc xflux google-chrome dropbox spotify xfce4-dockbarx-plugin \
	ttf-ms-fonts otf-powerline-symbols-git intel-xdk popcorntime-bin

yaourt -Sa ttf-google-fonts-git gvim-python

# Setup Slim
sudo systemctl enable slim.service -f

# Setup directories
rm -rf $HOME/Manjaro
mkdir $HOME/Code
