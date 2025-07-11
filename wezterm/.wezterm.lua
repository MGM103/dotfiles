local wezterm = require("wezterm")

local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Graphics
config.front_end = "WebGpu"
config.max_fps = 144
config.prefer_egl = true

-- APPEARANCE
config.color_scheme = "Tokyo Night Moon"
config.line_height = 1.2
config.default_cursor_style = "BlinkingBlock"
config.animation_fps = 1
config.cursor_blink_rate = 500
config.window_decorations = "NONE"

-- WSL
--config.default_domain = "WSL:Ubuntu"
--config.wsl_domains = {
--	{
--		name = "WSL:Ubuntu",
--		distribution = "Ubuntu",
--		default_cwd = "~/projects",
--	},
--}

-- KEY RE-MAPPINGS
local act = wezterm.action
config.keys = {
	{
		key = "c",
		mods = "CTRL",
		action = act({
			CopyTo = "Clipboard",
		}),
	},
	{
		key = "v",
		mods = "CTRL",
		action = act({
			PasteFrom = "Clipboard",
		}),
	},
}

-- MOUSE RE-MAPPINGS
config.mouse_bindings = {
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = act({
			PasteFrom = "Clipboard",
		}),
	},
}

-- TAB BAR
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = true
config.tab_and_split_indices_are_zero_based = true
config.tab_max_width = 50

return config
