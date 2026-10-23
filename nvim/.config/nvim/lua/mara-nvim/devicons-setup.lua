local devicons = require("nvim-web-devicons")

-- U+E027 has no glyph in WezTerm; use a neutral document icon instead.
-- Cover both lookup APIs so filename, filetype, and color lookups agree.
local unsupported_icon = vim.fn.nr2char(0xe027)
for _, method in ipairs({ "get_icon", "get_icon_colors" }) do
	local get_icon = devicons[method]
	devicons[method] = function(...)
		local icon, highlight_or_color, cterm_color = get_icon(...)
		if icon then
			icon = icon:gsub(unsupported_icon, "")
		end
		return icon, highlight_or_color, cterm_color
	end
end

devicons.setup({
	override = {
		stories = {
			icon = "📖",
			color = "#E84A5F",
			cterm_color = "203",
			name = "Stories",
		},
		["stories.tsx"] = {
			icon = "📖",
			color = "#E84A5F",
			cterm_color = "203",
			name = "StoriesTsx",
		},
		["stories.ts"] = {
			icon = "📖",
			color = "#E84A5F",
			cterm_color = "203",
			name = "StoriesTs",
		},
		["stories.jsx"] = {
			icon = "📖",
			color = "#E84A5F",
			cterm_color = "203",
			name = "StoriesJsx",
		},
		["stories.js"] = {
			icon = "📖",
			color = "#E84A5F",
			cterm_color = "203",
			name = "StoriesJs",
		},
		["package.json"] = {
			icon = "",
			color = "#CB3837",
			cterm_color = "167",
			name = "PackageJson",
		},
		["package-lock.json"] = {
			icon = "",
			color = "#CB3837",
			cterm_color = "167",
			name = "PackageLockJson",
		},
		["vite.config.ts"] = {
			icon = "⚡",
			color = "#646CFF",
			cterm_color = "33",
			name = "ViteConfigTs",
		},
		["vite.config.js"] = {
			icon = "⚡",
			color = "#646CFF",
			cterm_color = "33",
			name = "ViteConfigJs",
		},
		["playwright.config.ts"] = {
			icon = "🎭",
			color = "#F5C542",
			cterm_color = "221",
			name = "PlaywrightConfigTs",
		},
		["playwright.config.js"] = {
			icon = "🎭",
			color = "#F5C542",
			cterm_color = "221",
			name = "PlaywrightConfigJs",
		},
		[".prettierrc"] = {
			icon = "✨",
			color = "#56B3B4",
			cterm_color = "37",
			name = "PrettierRc",
		},
		[".prettierrc.json"] = {
			icon = "✨",
			color = "#56B3B4",
			cterm_color = "37",
			name = "PrettierRcJson",
		},
		[".prettierrc.yaml"] = {
			icon = "✨",
			color = "#56B3B4",
			cterm_color = "37",
			name = "PrettierRcYaml",
		},
		[".prettierrc.yml"] = {
			icon = "✨",
			color = "#56B3B4",
			cterm_color = "37",
			name = "PrettierRcYml",
		},
		[".prettierrc.js"] = {
			icon = "✨",
			color = "#56B3B4",
			cterm_color = "37",
			name = "PrettierRcJs",
		},
		[".prettierrc.cjs"] = {
			icon = "✨",
			color = "#56B3B4",
			cterm_color = "37",
			name = "PrettierRcCjs",
		},
		["prettier.config.js"] = {
			icon = "✨",
			color = "#56B3B4",
			cterm_color = "37",
			name = "PrettierConfigJs",
		},
		["prettier.config.cjs"] = {
			icon = "✨",
			color = "#56B3B4",
			cterm_color = "37",
			name = "PrettierConfigCjs",
		},
		["prettier.config.ts"] = {
			icon = "✨",
			color = "#56B3B4",
			cterm_color = "37",
			name = "PrettierConfigTs",
		},
		["next.config.js"] = {
			icon = "▲",
			color = "#FFFFFF",
			cterm_color = "231",
			name = "NextConfigJs",
		},
		["next.config.mjs"] = {
			icon = "▲",
			color = "#FFFFFF",
			cterm_color = "231",
			name = "NextConfigMjs",
		},
		["next.config.ts"] = {
			icon = "▲",
			color = "#FFFFFF",
			cterm_color = "231",
			name = "NextConfigTs",
		},
		["next.config.mts"] = {
			icon = "▲",
			color = "#FFFFFF",
			cterm_color = "231",
			name = "NextConfigMts",
		},
		["vitest.config.ts"] = {
			icon = "⚡",
			color = "#8B5CF6",
			cterm_color = "141",
			name = "VitestConfigTs",
		},
		["vitest.config.js"] = {
			icon = "⚡",
			color = "#8B5CF6",
			cterm_color = "141",
			name = "VitestConfigJs",
		},
	},
	default = true,
})
