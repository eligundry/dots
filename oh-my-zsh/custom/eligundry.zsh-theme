# ------------------------------------------------------------------------------
# FILE        : eligundry.zsh-theme
# DESCRIPTION : oh-my-zsh theme file
# AUTHOR      : Eli Gundry (eligundry@gmail.com)
# VERSION     : 1.0.0
# ------------------------------------------------------------------------------

local before_dir='╭─'
local prompt_icon="╰⤭"
local current_dir='%{$FX[bold]%}%{$FG[004]%}[%~]%{$reset_color%}'
local git_info='%{$FX[bold]%}%{$FG[002]%}%{$(git_prompt_info)%}%{$(git_prompt_short_sha)%}%{$reset_color%}'
local current_time='%{$FX[bold]%}%{$FG[004]%}[%T]%{$reset_color%}'

if which rvm-prompt &> /dev/null; then
  rvm_ruby=' %{$FX[bold]%}%{$FG[001]%}[$(rvm-prompt i v g)]%{$reset_color%}'
else
  if which rbenv &> /dev/null; then
    rvm_ruby=' %{$FX[bold]%}%{$FG[001]%}[$(rbenv version | sed -e "s/ (set.*$//")]%{$reset_color%}'
  fi
fi

function ssh_connection() {
	if [[ -n $SSH_CONNECTION ]]; then
		echo ' %{$FX[bold]%}%{$FG[002]%}[ssh]%{$reset_color%}'
		before_dir=''
		prompt_icon='>'
	fi
}

export VIRTUAL_ENV_DISABLE_PROMPT=1

ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX=' %{$FX[bold]%}%{$FG[003]%}['
ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX=']%{$reset_color%} '

function virtualenv_prompt_info() {
	if [ -n "$VIRTUAL_ENV" ]; then
		if [ -f "$VIRTUAL_ENV/__name__" ]; then
			local name=`cat $VIRTUAL_ENV/__name__`
		elif [ `basename $VIRTUAL_ENV` = "__" ]; then
			local name=$(basename $(dirname $VIRTUAL_ENV))
		else
			local name=$(basename $VIRTUAL_ENV)
		fi
		echo "$ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX$name$ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX"
	fi
}

ZSH_THEME_GIT_PROMPT_PREFIX=' [:'
ZSH_THEME_GIT_PROMPT_SUFFIX=''
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=':'
ZSH_THEME_GIT_PROMPT_SHA_AFTER='] '

PROMPT="
${before_dir}${current_dir}${git_info}
${prompt_icon} "
RPROMPT="${current_time}$(virtualenv_prompt_info)$(ssh_connection)${rvm_ruby}"
