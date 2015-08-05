#!/bin/bash

APT_PATH='sudo /usr/bin/apt-get'
APT_ARGS='-y'
APT="$APT_PATH $APT_ARGS"

install_packages()
{
	$APT install zsh vim-nox vim-gtk tmux clementine redshift-gtk transmission-gtk

}

setup_ppa()
{
	$APT install software-properties-common python-software-properties
}
