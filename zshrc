################################################################################
# @name: .zshrc
# @author: Eli Gundry
################################################################################

################################################################################
# => Common Profile
################################################################################

source $HOME/.commonprofile

################################################################################
# => ZPlug
################################################################################

DISABLE_AUTO_UPDATE=true

export ZPLUG_HOME=$HOME/.lib/zplug
source $ZPLUG_HOME/init.zsh

zplug "lib/completion", from:oh-my-zsh
zplug "lib/directories", from:oh-my-zsh
zplug "lib/history", from:oh-my-zsh
zplug "lib/nvm", from:oh-my-zsh, if:"command_exists 'nvm'"
zplug "lib/termsupport", from:oh-my-zsh
zplug "lib/theme-and-appearance", from:oh-my-zsh
zplug "plugins/archlinux", from:oh-my-zsh, if:"command_exists 'pacman'"
zplug "plugins/brew", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"
zplug "plugins/brew-cask", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"
zplug "plugins/colorize", from:oh-my-zsh
zplug "plugins/composer", from:oh-my-zsh, if:"command_exists 'composer'"
zplug "plugins/docker", from:oh-my-zsh, if:"command_exists 'docker'"
zplug "plugins/docker-compose", from:oh-my-zsh, if:"command_exists 'docker-compose'"
zplug "plugins/emoji-clock", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/git-prompt", from:oh-my-zsh
zplug "plugins/npm", from:oh-my-zsh, if:"command_exists npm"
zplug "plugins/osx", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"
zplug "plugins/pip", from:oh-my-zsh, if:"command_exists 'pip'"
zplug "plugins/python", from:oh-my-zsh, if:"command_exists 'python'"
zplug "plugins/svn-fast-info", from:oh-my-zsh
zplug "plugins/vagrant", from:oh-my-zsh, if:"command_exists 'vagrant'"
zplug "plugins/virtualenv", from:oh-my-zsh
zplug "plugins/xcode", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"
zplug "plugins/zsh_reload", from:oh-my-zsh
zplug "pyinvoke/invoke", use:"completion/zsh", if:"command_exists 'python'"
zplug "zsh-users/zsh-history-substring-search", defer:2
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "~/.zsh", use:"*.zsh", from:local, defer:2
zplug "~/.zsh/themes", use:"mitsuhiko.zsh-theme", from:local, as:theme

# if ! zplug check --verbose; then
if ! zplug check; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load # --verbose
