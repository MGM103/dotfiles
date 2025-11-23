return {
	{
		-- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	{
		"tpope/vim-fugitive",
		cmd = { "Git", "G", "Gdiffsplit", "Gblame" },
		keys = {
			{ "<leader>gs", "<cmd>Git<cr>", desc = "Git status" },
			{ "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Git diff split" },
			{ "<leader>gb", "<cmd>Gblame<cr>", desc = "Git blame" },
		},
	},
}
