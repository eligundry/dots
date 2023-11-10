################################################################################
# @name: .bash_profile
# @author: Eli Gundry
################################################################################

if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

export PATH="$HOME/.cargo/bin:$PATH"
