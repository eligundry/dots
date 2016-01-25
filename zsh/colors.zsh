# Solarized dir colors
if [[ `uname` == 'Darwin' ]]; then
	eval `/usr/local/Cellar/coreutils/8.24/libexec/gnubin/dircolors $HOME/.dir_colors/dircolors.ansi-dark`
else
	eval `dircolors $HOME/.dir_colors/dircolors.ansi-dark`
fi

# Colors for completion
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
