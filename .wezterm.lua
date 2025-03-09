local wezterm = require("wezterm")

local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Graphics
config.front_end = "OpenGL"
config.max_fps = 144
config.prefer_egl = true

-- APPEARANCE
config.color_scheme = "Tokyo Night Moon"
config.line_height = 1.2
config.default_cursor_style = "BlinkingBlock"
config.animation_fps = 1
config.cursor_blink_rate = 500
-- config.window_decorations = "NONE | RESIZE"

-- WSL
config.default_domain = "WSL:Ubuntu"
config.wsl_domains = {
	{
		name = "WSL:Ubuntu",
		distribution = "Ubuntu",
		default_cwd = "~/projects",
	},
}

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

-- MULTIPLEXING
config.leader = { key = "q", mods = "ALT", timeout_milliseconds = 2000 }
config.keys = {
	{
		mods = "LEADER",
		key = "c",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		mods = "LEADER",
		key = "x",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		mods = "LEADER",
		key = "b",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		mods = "LEADER",
		key = "n",
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		mods = "LEADER",
		key = "|",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "-",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "h",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		mods = "LEADER",
		key = "j",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		mods = "LEADER",
		key = "k",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		mods = "LEADER",
		key = "l",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		mods = "LEADER",
		key = "LeftArrow",
		action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
	},
	{
		mods = "LEADER",
		key = "RightArrow",
		action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
	},
	{
		mods = "LEADER",
		key = "DownArrow",
		action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
	},
	{
		mods = "LEADER",
		key = "UpArrow",
		action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
	},
}

for i = 0, 9 do
	-- leader + number to activate that tab
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = wezterm.action.ActivateTab(i),
	})
end

-- MULTIPLEXING LEADER KEY
wezterm.on("update-right-status", function(window, _)
	local prefix = ""

	if window:leader_is_active() then
		prefix = " " .. "🫡" .. " " -- salulte emoji
	end

	window:set_left_status(wezterm.format({
		{ Background = { Color = "transparent" } },
		{ Text = prefix },
	}))
end)

-- TAB BAR
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = true
config.tab_and_split_indices_are_zero_based = true
config.tab_max_width = 50

-- AUTO TAB RENAMING
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local index = tab.tab_index
	local process = tab.active_pane.foreground_process_name or "terminal"
	process = process:match("[^/\\]+$")

	return string.format(" %d:%s ", index, process)
end)

return config
