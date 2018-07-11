# The apt zsh plugin sets this and it conflicts with the silver searcher
unalias ag

# Directory traversal
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

# Make rsync usable
alias copy='rsync -avzhe --progress'
