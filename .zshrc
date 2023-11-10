################################################################################
# @name: .zshrc
# @author: Eli Gundry
################################################################################

################################################################################
# => Common Profile
################################################################################

source "$HOME/.commonprofile"

################################################################################
# => Fix Stupid ZSH
################################################################################

fpath=(/usr/local/share/zsh/site-functions $fpath)

################################################################################
# => ZPlug
################################################################################

DISABLE_AUTO_UPDATE=true

export ZPLUG_HOME=$HOME/.lib/zplug
source $ZPLUG_HOME/init.zsh
HISTDB_TABULATE_CMD=(sed -e $'s/\x1f/\t/g')

zplug "lib/completion", from:oh-my-zsh
zplug "lib/directories", from:oh-my-zsh
zplug "lib/history", from:oh-my-zsh
zplug "lib/termsupport", from:oh-my-zsh
zplug "lib/theme-and-appearance", from:oh-my-zsh
zplug "plugins/ag", from:oh-my-zsh, if:"command_exists 'ag'"
zplug "plugins/aws", from:oh-my-zsh, if:"command_exists 'aws'"
zplug "plugins/brew", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"
zplug "plugins/brew-cask", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"
zplug "plugins/docker", from:oh-my-zsh, if:"command_exists 'docker'"
zplug "plugins/docker-compose", from:oh-my-zsh, if:"command_exists 'docker-compose'"
zplug "plugins/fnm", from:oh-my-zsh, if:"command_exists 'fnm'"
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/httpie", from:oh-my-zsh, if:"command_exists 'http'"
zplug "plugins/macos", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"
zplug "plugins/npm", from:oh-my-zsh, if:"command_exists npm"
zplug "plugins/pass", from:oh-my-zsh, if:"command_exists 'pass'"
zplug "plugins/rbenv", from:oh-my-zsh, if:"command_exists 'rbenv'"
zplug "plugins/yarn", from:oh-my-zsh, if:"command_exists 'yarn'"
zplug "plugins/history-substring-search", from:oh-my-zsh, defer:2
zplug "larkery/zsh-histdb", use:"{zsh-histdb.plugin,histdb-interactive}.zsh"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "~/.zsh", use:"*.zsh", from:local, defer:2

# if ! zplug check --verbose; then
if ! zplug check; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load # --verbose

eval "$(starship init zsh)"

# Serverless uses tabtab which will automatically change this file unless these
# lines are here. Fuck Amazon.
# tabtab source for serverless package
# tabtab source for sls package
# tabtab source for slss package
