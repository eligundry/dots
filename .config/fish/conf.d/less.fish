################################################################################
# => LESS Colors for Man
# https://unix.stackexchange.com/a/178816
################################################################################

set -x LESS_TERMCAP_mb \e'[1;35m'
set -x LESS_TERMCAP_md \e'[1;34m'
set -x LESS_TERMCAP_me \e'[0m'
set -x LESS_TERMCAP_se \e'[0m'
set -x LESS_TERMCAP_so \e'[7;40m'
set -x LESS_TERMCAP_ue \e'[0m'
set -x LESS_TERMCAP_us \e'[1;33m'
set -x LESS_TERMCAP_mr (tput rev)
set -x LESS_TERMCAP_mh (tput dim)
set -x LESS_TERMCAP_ZN (tput ssubm)
set -x LESS_TERMCAP_ZV (tput rsubm)
set -x LESS_TERMCAP_ZO (tput ssupm)
set -x LESS_TERMCAP_ZW (tput rsupm)
set -x GROFF_NO_SGR 1
