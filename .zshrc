################################################################################
# @name: .zshrc
# @author: Eli Gundry
################################################################################

################################################################################
# => Common Profile
################################################################################

source $HOME/.commonprofile

################################################################################
# => Fix Stupid ZSH
################################################################################

fpath=(/usr/local/share/zsh/site-functions $fpath)
fpath=($HOME/.local/bin $fpath)

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

################################################################################
# => ZPlug
################################################################################

DISABLE_AUTO_UPDATE=true

source "$HOME"/.local/share/dots/zplug/init.zsh
HISTDB_TABULATE_CMD=(sed -e $'s/\x1f/\t/g')

zplug "lib/completion", from:oh-my-zsh
zplug "lib/directories", from:oh-my-zsh
zplug "lib/history", from:oh-my-zsh
zplug "lib/termsupport", from:oh-my-zsh
zplug "lib/theme-and-appearance", from:oh-my-zsh
zplug "chriskempson/base16-shell", from:github
zplug "plugins/ag", from:oh-my-zsh, if:"command_exists 'ag'"
zplug "plugins/aws", from:oh-my-zsh, if:"command_exists 'aws'"
zplug "plugins/brew", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"
zplug "plugins/brew-cask", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"
zplug "plugins/docker", from:oh-my-zsh, if:"command_exists 'docker'"
zplug "plugins/docker-compose", from:oh-my-zsh, if:"command_exists 'docker-compose'"
zplug "plugins/dotenv", from:oh-my-zsh
zplug "plugins/fnm", from:oh-my-zsh, if:"command_exists 'fnm'"
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/gh", from:oh-my-zsh, if:"command_exists 'gh'"
zplug "plugins/httpie", from:oh-my-zsh, if:"command_exists 'http'"
zplug "plugins/macos", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"
zplug "plugins/npm", from:oh-my-zsh, if:"command_exists npm"
zplug "plugins/pass", from:oh-my-zsh, if:"command_exists 'pass'"
zplug "plugins/rbenv", from:oh-my-zsh, if:"command_exists 'rbenv'"
zplug "plugins/yarn", from:oh-my-zsh, if:"command_exists 'yarn'"
zplug "plugins/history-substring-search", from:oh-my-zsh, defer:2
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "$HOME/.zsh", use:"*.zsh", from:local, defer:2
zplug "$HOME/.local/bin", use:"base16", from:local, defer:2

# if ! zplug check --verbose; then
if ! zplug check; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load # --verbose

eval "$(starship init zsh)"

# atuin.sh
export ATUIN_NOBIND="true"
eval "$(atuin init zsh)"
bindkey '^r' atuin-search

# Serverless uses tabtab which will automatically change this file unless these
# lines are here. Fuck Amazon.
# tabtab source for serverless package
# tabtab source for sls package
# tabtab source for slss package
# [[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
