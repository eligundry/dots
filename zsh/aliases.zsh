alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -v'
alias s='sudo'
alias svn_remove='find . -name .svn -print0 | xargs -0 rm -rf'
alias so='source'
alias v='vim'
alias zreload='source ~/.zshrc'
alias django='python manage.py'
alias c='clear &&'
alias venv-start='source .venv/bin/activate && zreload'
alias windows='cd /mnt/Windows_8/Users/Eli/'

# ls shortcuts
alias la='ls -A'
alias ll='ls -l'
alias lla='ls -lA'
alias lr='ls -R'
alias lar='ls -Ar'

# Directory traversal
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
