function base16 --description "Set base16 theme for shell and ghostty"
  # Validate argument
  if test (count $argv) -ne 1
      echo "Usage: base16 <theme-name>"
      return 1
  end

  set -l theme $argv[1]

  # Write theme to ghostty config
  mkdir -p ~/.config/ghostty
  echo "theme = base16-$theme" > ~/.config/ghostty/base16

  # Create theme file for Neovim
  set -l neovim_theme_name "base16-$theme"
  echo "return { neovim = \"$neovim_theme_name\" }" > "$HOME/.local/share/base16-theme.lua"

  # Reload Ghostty config (SIGUSR2). Cmd-Shift-, is rebound for nvim, and
  # this works from inside tmux too.
  pkill -USR2 -x ghostty 2>/dev/null

  # Update Aider environment variables to match the new theme
  set_aider_theme_vars

  # Claude Code uses "theme": "auto" in ~/.claude/settings.json, so it
  # follows the terminal background on its own.
  return 0
end

# Add completions from ghostty themes directory
complete -c base16 -f -a "(
  if test -d ~/.config/ghostty/themes
    find ~/.config/ghostty/themes -type f -name \"base16-*\" | \
    sed -e 's|.*/base16-||' | \
    sort
  end
)"
