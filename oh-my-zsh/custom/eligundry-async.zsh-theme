# ------------------------------------------------------------------------------
# FILE        : eligundry.zsh-theme
# DESCRIPTION : oh-my-zsh theme file
# AUTHOR      : Eli Gundry (eligundry@gmail.com)
# VERSION     : 2.0.0
# ------------------------------------------------------------------------------

# All the async stuff here was stolen from
# https://github.com/mitsuhiko/dotfiles/blob/master/zsh/custom/themes/mitsuhiko.zsh-theme
setopt prompt_subst

# The pid of the async prompt process and the communication file
_ELIGUNDRY_ASYNC_PROMPT=0
_ELIGUNDRY_ASYNC_PROMPT_FN="/tmp/.zsh_tmp_prompt_$$"
_ELIGUNDRY_ASYNC_RPROMPT_FN="/tmp/.zsh_tmp_rprompt_$$"

# Constants
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$FX[bold]%}%{$FG[002]%}[:"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=":"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="]%{$reset_color%}"

ZSH_THEME_RVM_PROMPT_PREFIX=" %{$FX[bold]%}%{$FG[001]%}["
ZSH_THEME_RVM_PROMPT_SUFFIX="]%{$reset_color%} "

ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX=" %{$FX[bold]%}%{$FG[003]%}["
ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX="]%{$reset_color%} "

ZSH_THEME_SVN_PROMPT_PREFIX=" %{$FX[bold]%}%{$FG[003]%}[svn:"
ZSH_THEME_SVN_PROMPT_SUFFIX="]%{$reset_color%} "
ZSH_THEME_SVN_PROMPT_CLEAN=''
ZSH_THEME_SVN_PROMPT_ADDITIONS="*"

# Remove the default git var update from chpwd and precmd to speed
# up the shell prompt.  We will do the precmd_update_git_vars in
# the async prompt instead
chpwd_functions=("${(@)chpwd_functions:#chpwd_update_git_vars}")
precmd_functions=("${(@)precmd_functions:#precmd_update_git_vars}")

function prompt_dir()
{
	local before_dir='╭─'
	local current_dir="%{$FX[bold]%}%{$FG[004]%}[%~]%{$reset_color%}"

	echo -n "\n${before_dir}${current_dir}"
}

function rprompt_time()
{
	local current_time=" %{$FX[bold]%}%{$FG[004]%}[%T]%{$reset_color%}"

	echo -n "$current_time"
}

function prompt_icon() {
	local before_icon="\n╰"
	local icon_symbol="⤭"

	# if [[ `uname` == "Darwin" ]]; then
	# 	icon_symbol="$"
	# fi

	local icon="%{$FX[bold]%}%{$FG[002]%}%{$icon_symbol%}%{$reset_color%}"

	if [[ $? -ne 0 ]]; then
		icon="%{$FX[bold]%}%{$FG[001]%}%{$icon_symbol%}%{$reset_color%}"
	fi

	if [[ $UID -eq 0 ]]; then
		icon="%{$FX[bold]%}%{$FG[003]%}%{$icon_symbol%}%{$reset_color%}"
	fi

	if [[ $(jobs -l | wc -l) -gt 0 ]]; then
		icon="%{$FX[bold]%}%{$FG[006]%}%{$icon_symbol%}%{$reset_color%}"
	fi

	echo -n "$before_icon$icon "
}

# The basic prompts. The fancy git stuff will be done async
PROMPT=$(prompt_dir)$(prompt_icon)
RPROMPT=$(rprompt_time)

function prompt_git() {
	# local git_info="%{$(git_prompt_info)%}%{$(git_prompt_short_sha)%}"
	local git_info="%{$(git_super_status)%}%{$(git_prompt_short_sha)%}"

	echo -n "${git_info}"
}

function prompt_svn() {
	local svn_info="%{$(svn_prompt_info)%}"

	echo -n "${svn_info}"
}

function rprompt_rvm()
{
	echo -n "$(ruby_prompt_info)"
}

function rprompt_ssh() {
	if [[ -n $SSH_CONNECTION ]]; then
		echo -n " %{$FX[bold]%}%{$FG[002]%}[ssh]%{$reset_color%}"
	fi
}

function rprompt_virtualenv()
{
	local name

	if [ -n "$VIRTUAL_ENV" ]; then
		if [ -f "$VIRTUAL_ENV/__name__" ]; then
			local name=`cat $VIRTUAL_ENV/__name__`
		elif [ `basename $VIRTUAL_ENV` = "__" ]; then
			local name=$(basename $(dirname $VIRTUAL_ENV))
		else
			local name=$(basename $VIRTUAL_ENV)
		fi

		echo -n "$ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX$name$ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX"
	fi
}

build_prompt()
{
	RETVAL=$?
	prompt_dir
	prompt_git
	prompt_svn
	prompt_icon
}

build_rprompt()
{
	rprompt_rvm
	rprompt_ssh
	rprompt_virtualenv
	rprompt_time
}

function _eligundry_precmd()
{
	function async_prompt()
	{
		precmd_update_git_vars

		echo -n build_prompt() > $_ELIGUNDRY_ASYNC_PROMPT_FN
		echo -n build_rprompt() > $_ELIGUNDRY_ASYNC_RPROMPT_FN

		# signal parent
		kill -s USR1 $$
	}


	# If we still have a prompt async process we kill it to make sure
	# we do not backlog with useless prompt things.  This also makes
	# sure that we do not have prompts interleave in the tempfile.
	if [[ "${_ELIGUNDRY_ASYNC_PROMPT}" != 0 ]]; then
		kill -s HUP $_ELIGUNDRY_ASYNC_PROMPT >/dev/null 2>&1 || :
	fi

	# Kick off background jobs
	async_prompt &!
	_ELIGUNDRY_ASYNC_PROMPT=$!
}

# This is the trap for the signal that updates our prompt and
# redraws it.  We intentionally do not delete the tempfile here
# so that we can reuse the last prompt for successive commands
function _eligundry_trapusr1() {
	PROMPT="$(cat $_ELIGUNDRY_ASYNC_PROMPT_FN)"
	RPROMPT="$(cat $_ELIGUNDRY_ASYNC_RPROMPT_FN)"
	_ELIGUNDRY_ASYNC_PROMPT=0
	zle
	zle reset-prompt
}

# Make sure we clean up our tempfile on exit
function _eligundry_zshexit()
{
	rm -f $_ELIGUNDRY_ASYNC_PROMPT_FN $_ELIGUNDRY_ASYNC_RPROMPT_FN
}

# Hook our precmd and zshexit functions and USR1 trap
precmd_functions+=(_eligundry_precmd)
zshexit_functions+=(_eligundry_zshexit)
trap '_eligundry_trapusr1' USR1
