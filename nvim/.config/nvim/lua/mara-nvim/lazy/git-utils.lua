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
		"sindrets/diffview.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
			{ "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
			{ "<leader>gf", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview File History" },
		},
		config = function()
			require("diffview").setup({
				enhanced_diff_hl = true, -- Better colors
				view = {
					merge_tool = {
						layout = "diff3_mixed",
						disable_diagnostics = true,
					},
				},
				file_panel = {
					listing_style = "tree",
					win_config = {
						position = "bottom",
						height = 10,
					},
				},
			})
		end,
	},
}
