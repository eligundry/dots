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

pathadd "$HOME/.rvm/bin"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
export rvmsudo_secure_path=1

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

################################################################################
# => Oh-My-ZSH
################################################################################

ZSH=$HOME/.oh-my-zsh
ZSH_THEME="eligundry"
DISABLE_AUTO_UPDATE="true"

plugins=()

if [[ `uname` == "Linux" ]]; then
	plugins+=(archlinux systemd)
elif [[ `uname` == "Darwin" ]]; then
	plugins+=(brew osx xcode)
fi

plugins+=(git git-extras colored-man colorize iwhois history-substring-search \
	pip rvm svn-fast-info vagrant virtualenv zsh_reload zsh-syntax-highlighting)

# Add zsh completions to fpath
fpath=($ZSH/custom/plugins/zsh-completions/src $fpath)

source $ZSH/oh-my-zsh.sh

################################################################################
# => Tmuxifier
################################################################################

pathadd "$HOME/.bin/tmuxifier/bin"
export TMUXIFIER_LAYOUT_PATH="$DOTS/tmux-sessions"
eval "$(tmuxifier init -)"


################################################################################
# => Virtualenv
################################################################################

export VIRTUAL_ENV_DISABLE_PROMPT=1

################################################################################
# => Custom Files
################################################################################

for config_file ($HOME/.zsh/*.zsh); do
  source $config_file
done
