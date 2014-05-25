#!/bin/bash

nc='--noconfirm'

# Remove crappy apps I never use and their dependencies
yaourt -R libreoffice hexchat thunderbird xnoise xfburn mdm mdm-themes \
	bluez gnome-bluetooth
yaourt -Qdt

# Update the system (twice for system updates)
yaourt -Syy
yaourt -Syua $nc
yaourt -Syua $nc

# Install my favorite applications
yaourt -S vim tmux zsh terminator synapse clementine transmission-gtk \
	python2-virtualenv python-virtualenv pianobar git subversion openssh mosh \
	gnome-disk-utility python-pip python2-pip ipython ipython2 vagrant slim \
	slim-themes xfce4-dockbarx-plugin ruby nvidiabl nodejs php weechat \
	numix-manjaro-themes whois

yaourt -Sa $nc google-chrome dropbox spotify ttf-ms-fonts \
	otf-powerline-symbols-git intel-xdk popcorntime-bin htop-solarized-vi \
	google-talkplugin php-composer blueman-bzr jsawk xflux

yaourt -Sa ttf-google-fonts-git gvim-python

# Setup Slim
sudo systemctl enable slim.service -f

# Link js for jsawk
sudo ln -s /usr/bin/js17 /usr/bin/js

# Setup directories
rm -rf $HOME/Manjaro
mkdir $HOME/Code

# Clone dots
cd ~
git clone https://github.com/eligundry/dots
./dots/dots.sh -i
