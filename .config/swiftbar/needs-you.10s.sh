#!/bin/bash
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
#
# Menu bar item for background agent jobs: windows in the tmux session
# "agents" (see agents-window). Hidden when none are running; ⚑ N when N are
# waiting on me (flagged by ~/.claude/hooks/needs-you.sh). Click to jump in.

export PATH="$HOME/.local/bin:/opt/homebrew/bin:$PATH"
dir="${XDG_STATE_HOME:-$HOME/.local/state}/needs-you"

if [[ "$1" == focus ]]; then
    if tmux list-clients -F x 2>/dev/null | grep -q .; then
        tmux switch-client -t "=agents" \; select-window -t "$2"
        open -a Ghostty
    else
        open -na Ghostty --args -e tmux attach -t "=agents" \; select-window -t "$2"
    fi
    exit 0
fi

jobs=$(agents-window --list)

# Drop flags for jobs that no longer exist.
for f in "$dir"/*; do
    [[ -e "$f" ]] && ! awk -v j="${f##*/}" '$2 == j { f = 1 } END { exit !f }' <<<"$jobs" && rm -f "$f"
done

[[ -z "$jobs" ]] && exit 0

waiting=0
items=()
while read -r id job idle _age; do
    type=$(cut -f1 "$dir/$job" 2>/dev/null) msg=$(cut -f2- "$dir/$job" 2>/dev/null)
    case "$type" in
        "")          label="$job (working)" ;;
        idle_prompt) label="✓ $job — finished $((idle / 60))m ago" ;;
        *)           label="⚑ $job — ${msg//|//}"; waiting=$((waiting + 1)) ;;
    esac
    items+=("$label | bash='$0' param1=focus param2=$id terminal=false")
    [[ "$job" == reviewy-* ]] &&
        items+=("--Open PR | href=https://github.com/codeclimate/edp/pull/${job#reviewy-}")
    items+=("--Kill window | bash=tmux param1=kill-window param2=-t param3=$id terminal=false refresh=true")
done <<<"$jobs"

if (( waiting > 0 )); then
    echo "⚑ $waiting | sfimage=exclamationmark.bubble.fill"
else
    echo "$(wc -l <<<"$jobs" | tr -d ' ') | sfimage=text.bubble color=gray"
fi
echo "---"
printf '%s\n' "${items[@]}"
