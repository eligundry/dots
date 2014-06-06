#!/bin/bash

nc='--noconfirm'

# Remove crappy apps I never use and their dependencies
yaourt -R libreoffice hexchat thunderbird xnoise xfburn mdm mdm-themes \
	bluez gnome-bluetooth gedit xfce4-notes-plugin catfish
yaourt -Qdt

# Update the system (twice for system updates)
yaourt -Syy
yaourt -Syua
yaourt -Syua $nc

# Install my favorite applications
yaourt -S gvim-python3 tmux zsh terminator synapse clementine transmission-gtk \
	gnome-disk-utility pianobar git subversion openssh mosh numix-manjaro-themes \
	python-virtualenv python-pip ipython python-pygments vagrant slim \
    slim-themes virtualbox xfce4-dockbarx-plugin ruby nvidiabl nodejs php \
    weechat whois ttf-symbola multitail redshift googlecl

yaourt -Sa $nc google-chrome dropbox spotify ttf-ms-fonts caffeine-bzr \
	otf-powerline-symbols-git intel-xdk popcorntime-bin htop-solarized-vi \
	google-talkplugin php-composer blueman-bzr unnethack fontmatrix

yaourt -Sa ttf-google-fonts-git

# Setup Slim
sudo systemctl enable slim.service -f

# Setup directories
rm -rf $HOME/Manjaro
mkdir $HOME/Code

# Clone and install dots
cd ~
git clone https://github.com/eligundry/dots
cd dots
./dots.sh -i

# Install RVM with Ruby
source $HOME/.profile
cd $HOME
curl -sSL https://get.rvm.io | bash -s stable --ruby

# Setup redshift with systemd
systemctl --user enable redshift.service
systemctl --user start redshift.service

# Update icon cache
sudo gtk-update-icon-cache /usr/share/icons/Faenza-Green

# Setup xfce as I like it
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-filesystem -s "false"
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-home -s "false"
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-removable -s "false"
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-trash -s "false"
xfconf-query -c xfce4-keyboard-shortcuts -p -n "/xfwm4/custom/<Control><Shift><Alt>Left" -s "move_window_left_key"
xfconf-query -c xfce4-keyboard-shortcuts -p -n "/xfwm4/custom/<Control><Shift><Alt>Right" -s "move_window_right_key"
xfconf-query -c xfce4-notifyd -p /theme "Numix-Manjaro"
xfconf-query -c xfwm4 -p /general/cycle_draw_frame -s "false"
xfconf-query -c xfwm4 -p /general/cycle_hidden -s "true"
xfconf-query -c xfwm4 -p /general/cycle_workspaces -s "true"
xfconf-query -c xfwm4 -p /general/scroll_workspaces -s "false"
xfconf-query -c xfwm4 -p /general/show_dock_shadow -s "true"
xfconf-query -c xfwm4 -p /general/show_frame_shadow -s "true"
xfconf-query -c xfwm4 -p /general/show_popup_shadow -s "true"
xfconf-query -c xfwm4 -p /general/snap_to_border -s "true"
xfconf-query -c xfwm4 -p /general/snap_to_windows -s "true"
xfconf-query -c xfwm4 -p /general/sync_to_vblank -s "true"
xfconf-query -c xfwm4 -p /general/theme -s "Numix-Manjaro-Straight"
xfconf-query -c xfwm4 -p /general/title_font -s "Roboto 8"
xfconf-query -c xfwm4 -p /general/workspace_count -s 3
xfconf-query -c xfwm4 -p /general/workspace_names -t string -t string -t string -s "α" -s "β" -s "γ"
xfconf-query -c xfwm4 -p /general/wrap_windows -s "false"
xfconf-query -c xsettings -p /Gtk/FontName -s "Roboto Light 8"
xfconf-query -c xsettings -p /Net/ThemeName -s "Numix-Manjaro"
