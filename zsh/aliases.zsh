alias c='clear'
alias cp='cp -v'
alias ip='curl ifconfig.me/ip'
alias mkdir='mkdir -pv'
alias mv='mv -v'
alias rm='rm -v'
alias s='sudo'
alias sctl='systemctl'
alias so='source'
alias svn_remove='find . -name .svn -print0 | xargs -0 rm -rf'
alias git_clean='find . -name "*.orig" -delete'
alias pip_upgrade_all='pip freeze --local | grep -v "^\-e" | cut -d = -f 1  | xargs -n1 pip install -U'

if command_exists nvim; then
	alias v='nvim'
else
	alias v='vim'
fi

# Debian's zsh plugin sets ag, which is silver searcher
# if [[ `uname` != "Darwin" ]]; then
# 	unalias ag
# fi

# ls shortcuts
alias la='ls -A'
alias ll='ls -lh'
alias lla='ls -lAh'
alias lr='ls -R'
alias lar='ls -Arh'
alias l.='ls -d .*'

# Directory traversal
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

# Enable gulp autocomplete
eval "$(gulp --completion=zsh)"
