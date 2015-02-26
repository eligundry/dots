#!/bin/bash

nc='--noconfirm'

disable_mdm()
{
	# Disable MDM cause it sucks
	sudo systemctl disable lightdm.service lightdm-plymouth.service
	sudo rm -v /etc/systemd/system/display-manager.service
}

remove_default_packages()
{
	# Remove crappy apps I never use and their dependencies
	yaourt -R libreoffice-still nano hexchat thunderbird vi qpdfview catfish \
		xfce4-notes-plugin guayadeque mousepad lightdm light-locker \
		lightdm-gtk-greeter-settings lightdm-gtk3-greeter
	yaourt -Qdt
}

update_system()
{
	# Update the system twice to handle manjaro system upgrades
	sudo pacman -Syy
	sudo pacman -Syu
	sudo pacman -Syu
}

install_binary_packages()
{
	yaourt -S gvim-python3 tmux zsh terminator synapse clementine transmission-gtk \
		gnome-disk-utility pianobar git subversion openssh mosh numix-manjaro-themes \
		python-virtualenv python-pip python-pygments vagrant evince archey3 whois \
		slim virtualbox xfce4-dockbarx-plugin ruby nodejs go php weechat redshift \
		ttf-symbola multitail googlecl seahorse mercurial the_silver_searcher p7zip \
		handbrake php-composer ctags mono sqliteman qtscrobbler xclip memcached \
		python2-pygments unetbootin geoclue2 dropbox2 postgresql
}

install_aur_no_confirm()
{
	yaourt -Sa $nc google-chrome spotify ttf-ms-fonts rarcrack eclim eclipse-android \
		otf-powerline-symbols-git popcorntime-bin htop-solarized-vi unnethack slurm \
		xfce-slimlock gotags-git todotxt 2048.c skype4pidgin-svn zeal-git
}

install_aur_confirm()
{
	yaourt -Sa ttf-google-fonts-git
}

tweak_manjaro()
{
	# Update icon cache
	sudo gtk-update-icon-cache /usr/share/icons/Menda-Circle

	# Setup Slim
	sudo systemctl enable slim.service -f

	# Setup directories
	rm -rfv $HOME/Manjaro
	mkdir -v $HOME/Code $HOME/.golang

	# Clone and install dots
	cd ~
	git clone https://github.com/eligundry/dots
	cd dots
	./dots.sh -i

	# Enable geoclue for redshift
	sudo systemctl enable geoclue.service
	sudo systemctl start geoclue.service

	# Setup redshift with systemd
	rm -rfv $HOME/.config/systemd
	systemctl --user enable redshift.service
	systemctl --user start redshift.service

	# Setup Xfce as I like it
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
	xfconf-query -c xsettings -p /Gtk/FontName -s "Roboto 8"
	xfconf-query -c xsettings -p /Net/ThemeName -s "Numix-Manjaro"
}

case "$1" in
	'install')
		disable_mdm
		remove_default_packages
		update_system
		install_binary_packages
		install_aur_no_confirm
		install_aur_confirm
		tweak_manjaro
	;;
	'disable-mdm')
		disable_mdm
	;;
	'remove-default-packages')
		remove_default_packages
	;;
	'update-system')
		update_system
	;;
	'install-binary-packages')
		install_binary_packages
	;;
	'install-aur-no-confirm')
		install_aur_no_confirm
	;;
	'install-aur-confirm')
		install_aur_confirm
	;;
	'tweak-manjaro')
		tweak_manjaro
	;;
esac
