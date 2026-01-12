#!/bin/bash

# Claude Code notification hook
# Sends terminal-notifier alerts for permission prompts and questions
# Prefixes with tmux session info when running in tmux

# Read JSON input from stdin
input=$(cat)

# Extract notification type and message using jq
notification_type=$(echo "$input" | jq -r '.notification_type // empty')
message=$(echo "$input" | jq -r '.message // "Claude Code needs attention"')

# Build title based on notification type
case "$notification_type" in
    permission_prompt)
        title="Claude Code - Permission Required"
        ;;
    elicitation_dialog)
        title="Claude Code - Question"
        ;;
    idle_prompt)
        title="Claude Code - Awaiting Input"
        ;;
    # Only notify for permission prompts, questions, and idle prompts
    *)
      exit 0
      ;;
esac

# Try to get tmux session info for the pane running Claude Code (not the focused one)
# Use -t $TMUX_PANE to target the specific pane
tmux_pane="$TMUX_PANE"
session_name=$(/opt/homebrew/bin/tmux display-message -t "$tmux_pane" -p '#S' 2>&1)
window_index=$(/opt/homebrew/bin/tmux display-message -t "$tmux_pane" -p '#I' 2>&1)

in_tmux=false
if [[ -n "$session_name" && -n "$window_index" && "$session_name" != *"no server"* && "$session_name" != *"error"* ]]; then
    message="${session_name}.${window_index}: ${message}"
    in_tmux=true
    # Trigger bell in the pane to show alert in tmux status bar
    # Requires 'set -g visual-bell on' in tmux.conf for silent bell
    pane_tty=$(/opt/homebrew/bin/tmux display-message -t "$tmux_pane" -p '#{pane_tty}' 2>/dev/null)
    if [[ -n "$pane_tty" && -w "$pane_tty" ]]; then
        printf '\a' > "$pane_tty"
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
if [[ "$in_tmux" == "true" ]]; then
    # Include execute command to switch to the correct tmux pane when clicked
    terminal-notifier \
        -title "$title" \
        -message "$message" \
        -sound default \
        -activate "$terminal_id" \
        -execute "/opt/homebrew/bin/tmux switch-client -t '$session_name' && /opt/homebrew/bin/tmux select-window -t '$session_name:$window_index' && /opt/homebrew/bin/tmux select-pane -t '$tmux_pane'" \
        -ignoreDnD
else
    terminal-notifier \
        -title "$title" \
        -message "$message" \
        -sound default \
        -activate "$terminal_id" \
        -ignoreDnD
fi

exit 0
