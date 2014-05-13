################################################################################
# @name: .zshrc
# @author: Eli Gundry
################################################################################

################################################################################
# => RVM
################################################################################

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
export rvmsudo_secure_path=1

################################################################################
# => Oh-My-ZSH
################################################################################

ZSH=$HOME/.oh-my-zsh
ZSH_THEME="eligundry"
DISABLE_AUTO_UPDATE="true"

plugins=()

if [[ `uname` == "Linux" ]]; then
	plugins+=(archlinux command-not-found)
elif [[ `uname` == "Darwin" ]]; then
	plugins+=(brew osx xcode)
fi
plugins+=(git git-extras history-substring-search pip rvm svn virtualenv zsh_reload zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Add zsh completions to fpath
fpath=(~/.oh-my-zsh/custom/plugins/zsh-completions/src $fpath)

################################################################################
# => Tmuxifier
################################################################################

export PATH="$HOME/.bin/tmuxifier/bin:$PATH"
export TMUXIFIER_LAYOUT_PATH="$HOME/dots/tmux-sessions"
eval "$(tmuxifier init -)"

################################################################################
# => Custom Files
################################################################################

for config_file ($HOME/.zsh/*.zsh); do
  source $config_file
done
