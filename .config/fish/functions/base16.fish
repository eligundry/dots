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

  # If in Ghostty, tell the user what to press to refresh the config
  if test -n "$GHOSTTY_BIN_DIR"
      echo "Press <Cmd-shift-,> to refresh Ghostty config"
  end
end

# Add completions from base16-shell themes
complete -c base16 -f -a "(
  if test -d ~/.zplug/repos/chriskempson/base16-shell/scripts
    find ~/.zplug/repos/chriskempson/base16-shell/scripts -type f -name \"base16-*.sh\" | \
    sed -e 's/.*base16-//' -e 's/\.sh\$//g' | \
    sort
  end
)"
