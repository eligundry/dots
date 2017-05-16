################################################################################
# @name: .zshrc
# @author: Eli Gundry
################################################################################

################################################################################
# => Common Profile
################################################################################

source $HOME/.commonprofile

################################################################################
# => Oh-My-ZSH
################################################################################

ZSH=$HOME/.oh-my-zsh
ZSH_THEME="mitsuhiko"
DISABLE_AUTO_UPDATE="true"

plugins=()

if [[ `uname` == "Linux" ]]; then
	plugins+=(systemd)

	if [[ `uname -r | sed -n "/MANJARO\|ARCH/p" | wc -l` == 1 ]]; then
		plugins+=(archlinux)
	elif [[ `uname -v | sed -n "/Ubuntu\|Debian/p" | wc -l` == 1 ]]; then
		plugins+=(debian)
	fi

elif [[ `uname` == "Darwin" ]]; then
	plugins+=(brew brew-cask osx xcode)
fi

plugins+=(cp docker docker-compose git git-extras github git-prompt colorize \
	composer django emoji-clock fabric go history-substring-search pip python \
	rvm svn-fast-info symfony2 vagrant virtualenv keybase zsh_reload \
	zsh-completions)

if [[ `uname` == "Linux" ]]; then
	plugins+=(zsh-syntax-highlighting)
fi

# Add zsh completions to fpath
fpath=($HOME/.zsh/completions $fpath)

source $ZSH/oh-my-zsh.sh



################################################################################
# => Custom Files
################################################################################

for config_file ($HOME/.zsh/*.zsh); do
  source $config_file
done

################################################################################
# => ZSH Syntax Highlighting for OSX
# OS X is weird with this plugin and it won't work in the oh my zsh plugins
# array, so we source it from the brew install location.
################################################################################

if [[ `uname` == "Darwin" ]]; then
	source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
