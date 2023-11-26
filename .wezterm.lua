local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Fonts
config.font = wezterm.font('CaskaydiaCove Nerd Font', { weight = 'DemiBold' })
config.font_size = 13

-- Transparency
config.window_background_opacity = 0.95

-- Base16 Colors
config.color_scheme = 'Default Dark (base16)'

-- GUI
config.hide_tab_bar_if_only_one_tab = true
config.scrollback_lines = 0
config.window_decorations = 'RESIZE'

return config
