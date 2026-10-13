#!/bin/bash

# Tracks whether background Claude jobs ($AGENT_JOB, set by agents-window)
# are waiting on me. Read by claude-reviewy-queue (to close finished windows)
# and the SwiftBar item ~/.config/swiftbar/needs-you.10s.sh.
#   Notification                -> ~/.local/state/needs-you/<job> = "<type>\t<message>"
#   PreToolUse AskUserQuestion  -> same, with type "question" (Claude reports
#                                  the wait as idle_prompt, same as finished)
#   UserPromptSubmit/SessionEnd/PostToolUse -> remove it

job="$AGENT_JOB"
[[ -n "$job" ]] || exit 0

dir="${XDG_STATE_HOME:-$HOME/.local/state}/needs-you"
mkdir -p "$dir"
input=$(cat)

case "$(echo "$input" | jq -r '.hook_event_name // empty')" in
    PreToolUse)
        echo "$input" | jq -r '["question",
            (.tool_input.questions[0].question // "Question" | gsub("\\s+"; " ") | .[:120])] | @tsv' > "$dir/$job" ;;
    Notification)
        # Don't let the idle ping that follows a question mark it finished.
        [[ "$(cut -f1 "$dir/$job" 2>/dev/null)" == question ]] && exit 0
        echo "$input" | jq -r '[.notification_type // "other",
            (.message // "Waiting for you" | gsub("\\s+"; " ") | .[:120])] | @tsv' > "$dir/$job" ;;
    *)
        rm -f "$dir/$job" ;;
esac
exit 0
