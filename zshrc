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

plugins=(archlinux command-not-found compleat cp django gem git virtualenv pip rvm svn vi-mode zsh-syntax-highlighting zsh-history-substring-search)

source $ZSH/oh-my-zsh.sh

# Add zsh completions to fpath
fpath=(~/.oh-my-zsh/custom/plugins/zsh-completions/src $fpath)

################################################################################
# => Custom Files
################################################################################

for config_file ($HOME/.zsh/*.zsh); do
  source $config_file
done
