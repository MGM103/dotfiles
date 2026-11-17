return {
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(bufnr)
				local gs = require("gitsigns")

				local function map(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end

				map("n", "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					gs.nav_hunk("next")
				end, "Next hunk")

				map("n", "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					gs.nav_hunk("prev")
				end, "Previous hunk")

				map("n", "<leader>gB", function()
					gs.blame_line({ full = true })
				end, "Blame line")
			end,
		},
	},
	{
		"tpope/vim-fugitive",
		cmd = { "Git", "G", "Gdiffsplit", "Git blame" },
		keys = {
			{ "<leader>gs", "<cmd>Git<cr>", desc = "Git status" },
			{ "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame" },
		},
	},
	{
		"rashedInt32/lazydiff.nvim",
		cmd = {
			"Lazydiff",
			"LazydiffOff",
			"LazydiffRefresh",
			"LazydiffNext",
			"LazydiffPrev",
			"LazydiffFirst",
			"LazydiffReset",
			"LazydiffYank",
			"LazydiffFloat",
			"LazydiffFloatOff",
		},
		keys = {
			{ "<leader>gd", "<cmd>Lazydiff<cr>", desc = "Toggle inline diff" },
			{ "]h", "<cmd>LazydiffNext<cr>", desc = "Next diff hunk" },
			{ "[h", "<cmd>LazydiffPrev<cr>", desc = "Previous diff hunk" },
			{ "<leader>gr", "<cmd>LazydiffReset<cr>", desc = "Reset current diff hunk" },
			{ "<leader>gy", "<cmd>LazydiffYank<cr>", desc = "Yank deleted lines in hunk" },
		},
		opts = {
			ref = "HEAD",
			read_only = false,
			word_diff = true,
			show_hunk_header = true,
			live_refresh = true,
			auto_refresh = true,
			jump_on_enable = true,
		},
	},
}
