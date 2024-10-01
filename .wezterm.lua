local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.font = wezterm.font("HackGen")
config.use_ime = true
config.font_size = 12.0
config.color_scheme = "OneHalfDark"
config.hide_tab_bar_if_only_one_tab = true
config.adjust_window_size_when_changing_font_size = false
config.default_prog = { 'pwsh.exe' }

return config
