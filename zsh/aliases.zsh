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
alias v='vim'
alias git_clean='find . -name "*.orig" -delete'

# Debian's zsh plugin sets ag, which is silver searcher
unalias ag

# ls shortcuts
alias la='ls -A'
alias ll='ls -l'
alias lla='ls -lA'
alias lr='ls -R'
alias lar='ls -Ar'
alias l.='ls -d .*'

# Directory traversal
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

# Enable gulp autocomplete
eval "$(gulp --completion=zsh)"
