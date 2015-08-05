################################################################################
# @name: .zshrc
# @author: Eli Gundry
################################################################################

################################################################################
# => pathadd
################################################################################

pathadd() {
	if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
		PATH="${PATH:+"$PATH:"}$1"
	fi
}

################################################################################
# => RVM
################################################################################

if [[ -n $SSH_CONNECTION ]]; then
	pathadd "$HOME/.rvm/bin"
	[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
	export rvmsudo_secure_path=1
fi

################################################################################
# => Default Variables
################################################################################

export BROWSER=google-chrome-stable
export DOTS=$HOME/dots
export EDITOR=vim
export INPUTRC=$HOME/.inputrc
export LANG=en_US.UTF-8
export MANPAGER=less
export PAGER=less
export VISUAL=vim
export ECLIPSE_HOME=/usr/share/eclipse
export TESSDATA_PREFIX=/usr/local/tesseract

# Turn off flow control
stty -ixon

################################################################################
# => Oh-My-ZSH
################################################################################

ZSH=$HOME/.oh-my-zsh
ZSH_THEME="eligundry"
DISABLE_AUTO_UPDATE="true"

plugins=()

if [[ `uname` == "Linux" ]]; then
	plugins+=(systemd)

	if [[ `uname -r | sed -n "/MANJARO\|ARCH/p" | wc -l` == 1 ]]; then
		plugins+=(archlinux)
	elif [[ `uname -v | sed -n "/Ubuntu\|Debian/p" | wc -l` == 1 ]]; then
		plugins+=(debian)
	fi

elif [[ `uname` == "Darwin" ]]; then
	plugins+=(brew osx xcode)
fi

plugins+=(cp git git-extras github colorize composer django fabric \
	go history-substring-search pip python rvm svn-fast-info symfony2 vagrant \
	virtualenv keybase zsh_reload zsh-syntax-highlighting)

# Add zsh completions to fpath
fpath=($ZSH/custom/plugins/zsh-completions/src $fpath)

source $ZSH/oh-my-zsh.sh

################################################################################
# => Tmuxifier
################################################################################

if [[ -z $SSH_CONNECTION ]]; then
	pathadd "$HOME/.bin/tmuxifier/bin"
	unset GREP_OPTIONS
	export TMUXIFIER_LAYOUT_PATH="$DOTS/tmux-sessions"
	eval "$(tmuxifier init -)"
fi

################################################################################
# => GoPath
################################################################################

if [[ -z $SSH_CONNECTION ]]; then
	export GOPATH="$HOME/.golang"
	pathadd "$GOPATH/bin"
fi

################################################################################
# => Virtualenv
################################################################################

export VENV_PATH="$HOME/.virtualenvs"
export VIRTUAL_ENV_DISABLE_PROMPT=1

################################################################################
# => Linuxbrew
################################################################################

export PATH="$HOME/.linuxbrew/bin:$PATH"
export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"

################################################################################
# => Google Cloud SDK
################################################################################

pathadd "$HOME/.local_bin/google-cloud-sdk/bin"

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

################################################################################
# => Custom Files
################################################################################

for config_file ($HOME/.zsh/*.zsh); do
  source $config_file
done
