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

  # Update Aider environment variables to match the new theme
  set_aider_theme_vars

  # Update Claude Code theme based on background brightness
  set -l theme_file ~/.config/ghostty/themes/base16-$theme
  if test -f "$theme_file"
    # Extract background color from theme file
    set -l bg_color (grep '^background = ' "$theme_file" | sed 's/background = #//')

    if test -n "$bg_color"
      # Convert hex to RGB and calculate relative luminance
      set -l r (string sub -s 1 -l 2 $bg_color)
      set -l g (string sub -s 3 -l 2 $bg_color)
      set -l b (string sub -s 5 -l 2 $bg_color)

      # Convert hex to decimal
      set -l r_dec (printf '%d' 0x$r)
      set -l g_dec (printf '%d' 0x$g)
      set -l b_dec (printf '%d' 0x$b)

      # Calculate relative luminance (simplified: average of RGB)
      # A value < 128 (out of 255) is considered dark
      set -l luminance (math "($r_dec + $g_dec + $b_dec) / 3")

      # Determine Claude theme based on luminance
      set -l claude_theme
      if test "$luminance" -lt 128
        set claude_theme "dark"
      else
        set claude_theme "light"
      end

      # Update Claude Code config using jq (safely)
      if test -f ~/.claude.json
        # Use jq to update only the theme key, preserving everything else
        set -l tmp_file (mktemp)
        if jq --arg theme "$claude_theme" '.theme = $theme' ~/.claude.json > "$tmp_file" 2>/dev/null
          # Only replace if jq succeeded and output is valid JSON
          if jq empty "$tmp_file" 2>/dev/null
            mv "$tmp_file" ~/.claude.json
            echo "Updated Claude Code theme to: $claude_theme"
          else
            rm "$tmp_file"
            echo "Error: Failed to update Claude Code theme (invalid JSON output)" >&2
          end
        else
          rm -f "$tmp_file"
          echo "Error: Failed to update Claude Code theme (jq failed)" >&2
        end
      end
    end
  end
end

# Add completions from ghostty themes directory
complete -c base16 -f -a "(
  if test -d ~/.config/ghostty/themes
    find ~/.config/ghostty/themes -type f -name \"base16-*\" | \
    sed -e 's|.*/base16-||' | \
    sort
  end
)"
