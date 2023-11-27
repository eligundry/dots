local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Fonts
config.font_size = 12
config.font = wezterm.font('MonaspiceNe Nerd Font Mono', { weight = 'DemiBold' })
config.font_rules = {
  {
    italic = true,
    font = wezterm.font('MonaspiceRn Nerd Font Mono', {
      italic = true,
      weight = 'DemiBold',
    })
  },
  {
    italic = true,
    intensity = 'Bold',
    font = wezterm.font('MonaspiceRn Nerd Font Mono', {
      italic = true,
      weight = 'Bold',
    })
  },
}

-- Transparency
config.window_background_opacity = 0.95

-- Base16 Colors
config.color_scheme = 'Default Dark (base16)'

-- GUI
config.hide_tab_bar_if_only_one_tab = true
config.scrollback_lines = 0
config.window_decorations = 'RESIZE'

return config
