-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- UNBINDING --
hl.unbind("ALT + L")
hl.unbind("ALT + W")
hl.unbind("ALT + SHIFT + RETURN")
hl.unbind("ALT + SHIFT + E")
hl.unbind("ALT + SHIFT + G")
hl.unbind("ALT + CTRL + L")
hl.unbind("SUPER + SHIFT + ALT + E")
hl.unbind("SUPER + SHIFT + CTRL + A")

-- NAVIGATION --
o.bind("ALT + Q", "Close window", hl.dsp.window.close())
o.bind("ALT + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("ALT + SHIFT + H", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("ALT + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))
o.bind("ALT + SHIFT + L", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))

-- LAYOUT --
o.bind("ALT + D", "Toggle dwindle workspace layout", "omarchy-hyprland-workspace-layout-toggle")

-- APPLICATIONS --
o.bind("ALT + B", "Browser", { omarchy = "browser" })
o.bind("ALT + E", "Email", { webapp = "https://gmail.com" })
o.bind("ALT + SHIFT + G", "Email", { webapp = "https://github.com" })
o.bind("ALT + A", "Agent", "omarchy-agent --pick")

-- SYSTEM --
o.bind("SUPER + L", "Lock system", "omarchy-system-lock")
