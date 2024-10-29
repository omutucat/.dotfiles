local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.font = wezterm.font("HackGen35 Console NF", { bold = true, italic = false })
config.use_ime = true
config.font_size = 10.0
config.color_scheme = "arcoiris"
config.hide_tab_bar_if_only_one_tab = true
config.adjust_window_size_when_changing_font_size = false
config.default_prog = { 'nu' }
config.window_background_opacity = 0.85


return config
