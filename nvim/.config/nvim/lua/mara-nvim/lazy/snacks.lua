return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		dashboard = {
			sections = {
				{ section = "header" },
				{
					icon = " ",
					title = "Keymaps",
					section = "keys",
					indent = 2,
					padding = 1,
				},
				{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
			},
			preset = {
				header = [[
                                                                     
       ████ ██████           █████      ██                     
      ███████████             █████                             
      █████████ ███████████████████ ███   ███████████   
     █████████  ███    █████████████ █████ ██████████████   
    █████████ ██████████ █████████ █████ █████ ████ █████   
  ███████████ ███    ███ █████████ █████ █████ ████ █████  
 ██████  █████████████████████ ████ █████ █████ ████ ██████ 
                                                                                 
    ]],
				keys = {
					{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
					{ icon = " ", key = "b", desc = "New File", action = ":ene | startinsert" },
					{
						icon = " ",
						key = "n",
						desc = "Toggle Neo-tree",
						action = ":Neotree float",
					},
					{
						icon = "󱡅 ",
						key = "h",
						desc = "Toggle Harpoon",
						action = function()
							local harpoon = require("harpoon")
							harpoon.ui:toggle_quick_menu(harpoon:list())
						end,
					},
					{
						icon = " ",
						key = "r",
						desc = "Recent Files",
						action = ":lua Snacks.dashboard.pick('oldfiles')",
					},
					{
						icon = " ",
						key = "c",
						desc = "Config",
						action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
					},
					{
						icon = "󰒲 ",
						key = "l",
						desc = "Lazy",
						action = ":Lazy",
						enabled = package.loaded.lazy ~= nil,
					},
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
			},
		},
		explorer = { enabled = false },
		gitbrowse = {},
		image = { enabled = true },
		indent = { enabled = false },
		input = { enabled = false },
		lazygit = {},
		picker = { enabled = true },
		notifier = { enabled = false },
		quickfile = { enabled = true },
		scope = { enabled = false },
		scroll = { enabled = false },
		statuscolumn = { enabled = false },
		words = { enabled = false },
	},
	keys = {
		{
			"<leader>gl",
			function()
				Snacks.lazygit.open()
			end,
			desc = "Lazy git",
		},
		{
			"<leader>sf",
			function()
				Snacks.picker.files()
			end,
			desc = "[S]earch [F]iles",
		},
		{
			"<leader>sk",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "[S]earch [K]eymaps",
		},
		{
			"<leader>sh",
			function()
				Snacks.picker.help()
			end,
			desc = "[S]earch [H]elp",
		},
		{
			"<leader>sb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "[S]earch [B]uffers",
		},
		{
			"<leader><leader>",
			function()
				Snacks.picker.smart()
			end,
			desc = "Smart find",
		},
		{
			"<leader>sg",
			function()
				Snacks.picker.grep()
			end,
			desc = "[S]earch [Grep]",
		},
		{
			"<leader>sw",
			function()
				Snacks.picker.grep_word()
			end,
			desc = "[S]earch [W]ord",
			mode = { "n", "x" },
		},
		{
			"<leader>sp",
			function()
				Snacks.picker.pickers()
			end,
			desc = "[S]earch [P]ickers",
		},
		{
			"<leader>sr",
			function()
				Snacks.picker.resume()
			end,
			desc = "Resume",
		},
		{
			"<leader>sn",
			function()
				Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "[S]earch [N]eoVim",
		},
		{
			"<leader>sc",
			function()
				Snacks.picker.lines()
			end,
			desc = "[S]earch [C]urrent Buffer",
		},
		{
			"<leader>gH",
			function()
				Snacks.gitbrowse.open()
			end,
			desc = "Open [G]it[H]ub",
		},
		{
			"<leader>gh",
			function()
				Snacks.picker.git_diff()
			end,
			desc = "Git Diff (Hunks)",
		},
		{
			"<leader>gp",
			function()
				Snacks.picker.gh_pr()
			end,
			desc = "GitHub Pull Requests (open)",
		},
	},
}
