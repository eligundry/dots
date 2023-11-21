# Colors for completion
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Prevent zsh-syntax-highlighting from underlining stuff
# https://github.com/zsh-users/zsh-syntax-highlighting/issues/573
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
