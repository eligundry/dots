# Solarized dir colors
if [[ `uname` == 'Darwin' ]]; then
	eval `gdircolors $HOME/.dir_colors/dircolors.ansi-dark`
else
	eval `dircolors $HOME/.dir_colors/dircolors.ansi-dark`
fi

# Colors for completion
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Man Colors
LESS_TERMCAP_mb=$(printf "\e[1;38;5;2m")
LESS_TERMCAP_md=$(printf "\e[1;31m")
LESS_TERMCAP_me=$(printf "\e[0m")
LESS_TERMCAP_se=$(printf "\e[0m")
LESS_TERMCAP_so=$(printf "\e[1;44;33m")
LESS_TERMCAP_ue=$(printf "\e[0m")
LESS_TERMCAP_us=$(printf "\e[1;32m")
