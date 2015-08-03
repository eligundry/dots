################################################################################
# @name: .bash_profile
# @author: Eli Gundry
################################################################################

if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

# Turn off flow control
stty -ixon

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
