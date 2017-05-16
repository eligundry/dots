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

export ZPLUG_HOME=$HOME/.bin/zplug
source $ZPLUG_HOME/init.zsh

zplug "lib/completion", from:oh-my-zsh
zplug "lib/directories", from:oh-my-zsh
zplug "lib/history", from:oh-my-zsh
zplug "lib/nvm", from:oh-my-zsh
zplug "lib/theme-and-appearance", from:oh-my-zsh
zplug "plugins/archlinux", from:oh-my-zsh, if:"[[ `lsb_release -si | sed -n '/MANJARO\|ARCH/p' | wc -l` == 1 ]]"
zplug "plugins/brew", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"
zplug "plugins/brew-cask", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"
zplug "plugins/colorize", from:oh-my-zsh
zplug "plugins/composer", from:oh-my-zsh, if:"command_exists 'composer'"
zplug "plugins/debian", from:oh-my-zsh, if:"[[ `lsb_release -si | sed -n '/Ubuntu\|Debian/p' | wc -l` == 1 ]]"
zplug "plugins/docker", from:oh-my-zsh, if:"command_exists 'docker'"
zplug "plugins/docker-compose", from:oh-my-zsh, if:"command_exists 'docker-compose'"
zplug "plugins/emoji-clock", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/git-prompt", from:oh-my-zsh
zplug "plugins/osx", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"
zplug "plugins/pip", from:oh-my-zsh
zplug "plugins/python", from:oh-my-zsh
zplug "plugins/rvm", from:oh-my-zsh, if:"command_exists 'rvm'"
zplug "plugins/svn-fast-info", from:oh-my-zsh
zplug "plugins/vagrant", from:oh-my-zsh
zplug "plugins/virtualenv", from:oh-my-zsh
zplug "plugins/xcode", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"
zplug "plugins/zsh_reload", from:oh-my-zsh
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "~/.zsh", use:"*.zsh", from:local
zplug "~/.zsh/themes", use:"mitsuhiko.zsh-theme", from:local, as:theme

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load --verbose
