#!/bin/bash

# Claude Code notification hook
# Sends terminal-notifier alerts for permission prompts and questions
# Prefixes with tmux session info when running in tmux

# Read JSON input from stdin
input=$(cat)

# Extract notification type and message using jq
notification_type=$(echo "$input" | jq -r '.notification_type // empty')
message=$(echo "$input" | jq -r '.message // "Claude Code needs attention"')

# Only notify for permission prompts and elicitation dialogs (questions)
if [[ "$notification_type" != "permission_prompt" && "$notification_type" != "elicitation_dialog" ]]; then
    exit 0
fi

# Build title based on notification type
if [[ "$notification_type" == "permission_prompt" ]]; then
    title="Claude Code - Permission Required"
else
    title="Claude Code - Question"
fi

# Check if we're in tmux and build prefix
if [[ -n "$TMUX" ]]; then
    session_name=$(tmux display-message -p '#S' 2>/dev/null)
    window_index=$(tmux display-message -p '#I' 2>/dev/null)

    if [[ -n "$session_name" && -n "$window_index" ]]; then
        title="[${session_name}.${window_index}] ${title}"
    fi
fi

# Detect terminal bundle ID based on environment
if [[ "$TERMINFO" == *"Ghostty"* ]]; then
    terminal_id="com.mitchellh.ghostty"
elif [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    terminal_id="com.googlecode.iterm2"
elif [[ "$TERM_PROGRAM" == "WarpTerminal" ]]; then
    terminal_id="dev.warp.Warp-Stable"
elif [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
    terminal_id="com.apple.Terminal"
elif [[ "$KITTY_PID" ]]; then
    terminal_id="net.kovidgoyal.kitty"
elif [[ "$ALACRITTY_WINDOW_ID" ]]; then
    terminal_id="org.alacritty"
else
    terminal_id="com.apple.Terminal"
fi

# Send notification via terminal-notifier
terminal-notifier \
    -title "$title" \
    -message "$message" \
    -sound default \
    -activate "$terminal_id" \
    -ignoreDnD

exit 0
