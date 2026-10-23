-- Change the default Omarchy look'n'feel.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
hl.config({
	general = {
		-- No gaps between windows or borders.
		gaps_in = 4,
		gaps_out = 8,
		-- border_size = 0,

		-- Change to niri-like side-scrolling layout.
		layout = "scrolling",
	},
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
hl.config({
	decoration = {
		-- Use round window corners.
		rounding = 8,

		-- Dim unfocused windows (0.0 = no dim, 1.0 = fully dimmed).
		dim_inactive = true,
		dim_strength = 0.15,
	},
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
-- hl.config({
--   animations = {
--     -- Disable all animations.
--     enabled = false,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#layout
-- hl.config({
--   layout = {
--     -- Avoid overly wide single-window layouts on wide screens.
--     single_window_aspect_ratio = { 1, 1 },
--   },
-- })

-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
--
-- column_width is global, so instead of a fixed value we pick it dynamically: when
-- an ultrawide monitor is present the layout uses two columns (0.5); when only
-- smaller screens are connected it uses a single full-width column (1). The watcher
-- below listens for monitor plug/unplug and updates it live.
--
-- Tune via env vars in your shell profile or below: OMARCHY_ULTRAWIDE_RATIO (default
-- 2.1), OMARCHY_ULTRAWIDE_MONITORS (comma-separated output names, overrides ratio),
-- OMARCHY_COLUMN_WIDE (default 0.5), OMARCHY_COLUMN_NARROW (default 1).
hl.on("hyprland.start", function()
  hl.exec_cmd(o.launch("bash " .. os.getenv("HOME") .. "/.config/hypr/scrolling-column-width.sh"))
end)

-- A static fallback if you prefer not to run the watcher. Uncomment to force a value:
-- hl.config({
--   scrolling = {
--     -- See only one column per screen instead of two.
--     column_width = 0.97,
--   },
-- })
