#!/bin/bash

# Codex CLI notification bridge
# Mirrors ~/.claude/hooks/notify.sh: sends terminal-notifier alerts that, when
# clicked, focus the tmux session/window/pane the Codex session is running in.
#
# Runs in two modes:
#   1. notify-program mode  — Codex passes one JSON argv (config.toml `notify`).
#      Chains through to the Codex Computer Use notifier first so its
#      turn-ended handling keeps working.
#   2. hook mode            — Codex pipes hook JSON on stdin (config.toml
#      [[hooks.PermissionRequest]]).

TMUX_BIN=/opt/homebrew/bin/tmux
CHAIN_NOTIFY=(
    "/Users/eligundry/.codex/computer-use/Codex Computer Use.app/Contents/SharedSupport/SkyComputerUseClient.app/Contents/MacOS/SkyComputerUseClient"
    "turn-ended"
)

# --- Read the payload --------------------------------------------------------
if [[ $# -gt 0 ]]; then
    # notify-program mode: Codex appends the JSON payload as the final argument
    payload="${!#}"
    if [[ -x "${CHAIN_NOTIFY[0]}" ]]; then
        "${CHAIN_NOTIFY[@]}" "$@" >/dev/null 2>&1 &
    fi
else
    payload=$(cat)
fi

echo "$payload" | jq -e . >/dev/null 2>&1 || exit 0

kind=$(echo "$payload" | jq -r '.hook_event_name // .type // empty')

case "$kind" in
    PermissionRequest)
        title="Codex - Permission Required"
        tool=$(echo "$payload" | jq -r '.tool_name // "a tool"')
        detail=$(echo "$payload" | jq -r '
            .tool_input as $i
            | (($i.command // $i.cmd // $i.path // $i.file_path // $i.url) // "")
            | if type == "array" then join(" ") else tostring end
        ' 2>/dev/null)
        if [[ -n "$detail" && "$detail" != "null" ]]; then
            message="${tool}: ${detail}"
        else
            message="Codex wants to run ${tool}"
        fi
        ;;
    agent-turn-complete)
        title="Codex - Awaiting Input"
        message=$(echo "$payload" | jq -r '.["last-assistant-message"] // empty')
        [[ -z "$message" ]] && message="Codex finished its turn"
        ;;
    Stop)
        # Only reachable if a Stop hook is also wired; skip the re-entrant call.
        [[ "$(echo "$payload" | jq -r '.stop_hook_active // false')" == "true" ]] && exit 0
        title="Codex - Awaiting Input"
        message=$(echo "$payload" | jq -r '.last_assistant_message // empty')
        [[ -z "$message" || "$message" == "null" ]] && message="Codex finished its turn"
        ;;
    *)
        exit 0
        ;;
esac

# Collapse whitespace and truncate — notification bodies are small
message=$(echo "$message" | tr '\n' ' ' | tr -s ' ' | cut -c1-180)

# --- Only notify for the interactive TUI ------------------------------------
# `codex exec` / `codex mcp-server` runs (e.g. the Codex subagent driven from
# Claude Code) should not pop notifications.
ancestors=()
pid=$PPID
for _ in $(seq 1 12); do
    [[ -z "$pid" || "$pid" -le 1 ]] && break
    ancestors+=("$pid")
    pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
done

for p in "${ancestors[@]}"; do
    args=$(ps -o args= -p "$p" 2>/dev/null)
    case "$args" in
        */codex\ exec*|*/codex\ mcp-server*|*/codex\ app-server*|*/codex\ exec-server*)
            exit 0
            ;;
    esac
done

# --- Locate the tmux pane ----------------------------------------------------
tmux_pane="$TMUX_PANE"

# Fall back to matching an ancestor pid against tmux's pane pids, in case the
# hook is spawned without TMUX_PANE inherited.
if [[ -z "$tmux_pane" && -n "$TMUX" ]]; then
    while read -r pane_pid pane_id; do
        for p in "${ancestors[@]}"; do
            if [[ "$p" == "$pane_pid" ]]; then
                tmux_pane="$pane_id"
                break 2
            fi
        done
    done < <("$TMUX_BIN" list-panes -a -F '#{pane_pid} #{pane_id}' 2>/dev/null)
fi

in_tmux=false
if [[ -n "$tmux_pane" ]]; then
    session_name=$("$TMUX_BIN" display-message -t "$tmux_pane" -p '#S' 2>&1)
    window_index=$("$TMUX_BIN" display-message -t "$tmux_pane" -p '#I' 2>&1)
    if [[ -n "$session_name" && -n "$window_index" && "$session_name" != *"no server"* && "$session_name" != *"error"* ]]; then
        message="${session_name}.${window_index}: ${message}"
        in_tmux=true
        # Bell the pane so tmux's status bar flags it too
        pane_tty=$("$TMUX_BIN" display-message -t "$tmux_pane" -p '#{pane_tty}' 2>/dev/null)
        if [[ -n "$pane_tty" && -w "$pane_tty" ]]; then
            printf '\a' > "$pane_tty"
        fi
    fi
fi

# --- Detect the host terminal ------------------------------------------------
if [[ -n "$__CFBundleIdentifier" ]]; then
    terminal_id="$__CFBundleIdentifier"
elif [[ "$TERMINFO" == *"Ghostty"* || -n "$GHOSTTY_RESOURCES_DIR" ]]; then
    terminal_id="com.mitchellh.ghostty"
elif [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    terminal_id="com.googlecode.iterm2"
elif [[ "$TERM_PROGRAM" == "WarpTerminal" ]]; then
    terminal_id="dev.warp.Warp-Stable"
elif [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
    terminal_id="com.apple.Terminal"
elif [[ -n "$KITTY_PID" ]]; then
    terminal_id="net.kovidgoyal.kitty"
elif [[ -n "$ALACRITTY_WINDOW_ID" ]]; then
    terminal_id="org.alacritty"
else
    terminal_id="com.apple.Terminal"
fi

# --- Notify ------------------------------------------------------------------
if [[ "$in_tmux" == "true" ]]; then
    terminal-notifier \
        -title "$title" \
        -message "$message" \
        -sound default \
        -activate "$terminal_id" \
        -execute "$TMUX_BIN switch-client -t '$session_name' && $TMUX_BIN select-window -t '$session_name:$window_index' && $TMUX_BIN select-pane -t '$tmux_pane'" \
        -ignoreDnD &
else
    terminal-notifier \
        -title "$title" \
        -message "$message" \
        -sound default \
        -activate "$terminal_id" \
        -ignoreDnD &
fi

exit 0
