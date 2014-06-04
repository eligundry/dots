#!/bin/bash

nc='--noconfirm'

# Remove crappy apps I never use and their dependencies
yaourt -R libreoffice hexchat thunderbird xnoise xfburn mdm mdm-themes \
	bluez gnome-bluetooth gedit xfce4-notes-plugin catfish
yaourt -Qdt

# Update the system (twice for system updates)
yaourt -Syy
yaourt -Syua $nc
yaourt -Syua $nc

# Install my favorite applications
yaourt -S gvim-python3 tmux zsh terminator synapse clementine transmission-gtk \
	gnome-disk-utility pianobar git subversion openssh mosh numix-manjaro-themes \
	python-virtualenv python-pip ipython python-pygments vagrant slim \
    slim-themes virtualbox xfce4-dockbarx-plugin ruby nvidiabl nodejs php \
    weechat whois ttf-symbola multitail

yaourt -Sa $nc google-chrome dropbox spotify ttf-ms-fonts caffeine-bzr \
	otf-powerline-symbols-git intel-xdk popcorntime-bin htop-solarized-vi \
	google-talkplugin php-composer blueman-bzr jsawk-git xflux unnethack

yaourt -Sa ttf-google-fonts-git

# Setup Slim
sudo systemctl enable slim.service -f

# Link js for jsawk
sudo ln -s /usr/bin/js17 /usr/bin/js

# Setup directories
rm -rf $HOME/Manjaro
mkdir $HOME/Code

# Clone and install dots
cd ~
git clone https://github.com/eligundry/dots
cd dots
./dots.sh -i
