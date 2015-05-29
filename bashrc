################################################################################
# @name: .bashrc
# @author: Eli Gundry
################################################################################

# Custom dir colors
eval `dircolors ~/.dir_colors/dircolors.ansi-dark`

# RVM Settings
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
export rvmsudo_secure_path=1

# Sensible bash settings
set completion-ignore-case on

# Allow tab cycling
[[ $- = *i* ]] && bind TAB:menu-complete

################################################################################
# => Default Variables
################################################################################

export HISTIGNORE="&:[bf]g:exit"
export HISTCONTROL=ignoredups
export HISTFILESIZE=10000
export HISTSIZE=10000
export INPUTRC=$HOME/.inputrc
export EDITOR=vim
export VISUAL=vim
export BROWSER=google-chrome
export PAGER=less
export MANPAGER=less

################################################################################
# => Aliases
################################################################################

alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -v'
alias s='sudo'
alias svn_remove='find . -name .svn -print0 | xargs -0 rm -rf'
alias so='source'
alias v='vim'
alias g='git'
alias breload='source ~/.bashrc'
alias tmux='tmux -2ul'

# ls shortcuts
alias la='ls -A'
alias ll='ls -l'
alias lla='ls -lA'
alias lr='ls -R'
alias lar='ls -Ar'

# Dir Traversal
alias ...='../..'
alias ....='../../..'
alias .....='../../../..'

################################################################################
# => LESS Colors for Man
# http://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/
################################################################################

export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

# The next line updates PATH for the Google Cloud SDK.
source '/home/eligundry/google-cloud-sdk/path.bash.inc'

# The next line enables bash completion for gcloud.
source '/home/eligundry/google-cloud-sdk/completion.bash.inc'
