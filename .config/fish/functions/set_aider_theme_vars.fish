function set_aider_theme_vars --description "Set Aider environment variables based on current Ghostty theme"
  # Get the current theme name from the base16 config file
  if test -f "$HOME/.config/ghostty/base16"
    set -l theme_line (cat "$HOME/.config/ghostty/base16")
    set -l theme (string replace "theme = base16-" "" $theme_line)
    
    # Parse the theme file to get actual colors
    set -l theme_file "$HOME/.config/ghostty/themes/base16-$theme"
    
    # Check if theme file exists
    if not test -f "$theme_file"
      # Default to a dark theme if theme file not found
      set -gx AIDER_DARK_MODE "true"
      return 1
    end
    
    # Parse the theme file to extract colors
    set -l background (grep "^background = " "$theme_file" | cut -d'=' -f2 | tr -d ' ')
    set -l foreground (grep "^foreground = " "$theme_file" | cut -d'=' -f2 | tr -d ' ')
    
    # Extract palette colors
    set -l base00 (grep "^palette = 0=" "$theme_file" | cut -d'=' -f3)  # Default Background
    set -l base01 (grep "^palette = 18=" "$theme_file" | cut -d'=' -f3) # Lighter Background
    set -l base02 (grep "^palette = 19=" "$theme_file" | cut -d'=' -f3) # Selection Background
    set -l base03 (grep "^palette = 8=" "$theme_file" | cut -d'=' -f3)  # Comments
    set -l base04 (grep "^palette = 20=" "$theme_file" | cut -d'=' -f3) # Dark Foreground
    set -l base05 (grep "^palette = 7=" "$theme_file" | cut -d'=' -f3)  # Default Foreground
    set -l base06 (grep "^palette = 21=" "$theme_file" | cut -d'=' -f3) # Light Foreground
    set -l base07 (grep "^palette = 15=" "$theme_file" | cut -d'=' -f3) # Light Background
    set -l base08 (grep "^palette = 1=" "$theme_file" | cut -d'=' -f3)  # Red
    set -l base09 (grep "^palette = 16=" "$theme_file" | cut -d'=' -f3) # Orange
    set -l base0A (grep "^palette = 3=" "$theme_file" | cut -d'=' -f3)  # Yellow
    set -l base0B (grep "^palette = 2=" "$theme_file" | cut -d'=' -f3)  # Green
    set -l base0C (grep "^palette = 6=" "$theme_file" | cut -d'=' -f3)  # Cyan
    set -l base0D (grep "^palette = 4=" "$theme_file" | cut -d'=' -f3)  # Blue
    set -l base0E (grep "^palette = 5=" "$theme_file" | cut -d'=' -f3)  # Purple
    set -l base0F (grep "^palette = 17=" "$theme_file" | cut -d'=' -f3) # Brown
    
    # Set dark mode for dark themes (most base16 themes are dark)
    set -gx AIDER_DARK_MODE "true"
    
    # Set the actual color variables for Aider using the parsed colors
    set -gx AIDER_USER_INPUT_COLOR "$base0B"          # Green - Strings
    set -gx AIDER_ASSISTANT_OUTPUT_COLOR "$base0D"    # Blue - Functions
    set -gx AIDER_TOOL_OUTPUT_COLOR "$base0E"         # Purple - Keywords
    set -gx AIDER_TOOL_ERROR_COLOR "$base08"          # Red - Variables
    set -gx AIDER_TOOL_WARNING_COLOR "$base0A"        # Yellow - Classes
    set -gx AIDER_CODE_THEME "monokai"                # A dark code theme that works well with base16
    
    # Set completion menu colors
    set -gx AIDER_COMPLETION_MENU_COLOR "$base05"     # Default Foreground
    set -gx AIDER_COMPLETION_MENU_BG_COLOR "$base00"  # Default Background
    set -gx AIDER_COMPLETION_MENU_CURRENT_COLOR "$base00" # Default Background
    set -gx AIDER_COMPLETION_MENU_CURRENT_BG_COLOR "$base0D" # Blue - Functions
  end
end
