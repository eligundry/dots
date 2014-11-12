# Solarized dir colors
if [[ `uname` == 'Darwin' ]]; then
	eval `gdircolors $HOME/.dir_colors/dircolors.ansi-dark`
else
	eval `dircolors $HOME/.dir_colors/dircolors.ansi-dark`
fi

# Colors for completion
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
