local wezterm = require 'wezterm'
local config = {}

-- Functions {{{
local function require_module_by_path(module_path)
  local status, module = pcall(dofile, module_path)
  if status then
    return module
  else
    return nil
  end
end

local function expand_path(path)
  return os.getenv("HOME") .. "/" .. path
end
-- }}}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Fonts (I would love to be a person that could be into a handwriting font for
-- comments, but I'm just not that person.)
config.font_size = 13
config.cell_width = 0.85
config.font = wezterm.font_with_fallback({
  { family = "CaskaydiaCove Nerd Font Mono", weight = "DemiBold" },
  "JetBrains Mono",
  "Apple Color Emoji",
  "Noto Color Emoji",
  "Symbols Nerd Font Mono",
})


-- Transparency
config.window_background_opacity = 0.95

-- Base16 Colors
local terminal_theme = require_module_by_path(expand_path(".local/share/base16-theme.lua"))
config.color_scheme = 'Default Dark (base16)'

-- In order for this to all work with wezterm, you must also press
-- ctrl-shift-r to reload the config
if terminal_theme then
  config.color_scheme = terminal_theme.wezterm
end

-- GUI
config.hide_tab_bar_if_only_one_tab = true
config.scrollback_lines = 0
config.window_decorations = 'RESIZE'

return config
