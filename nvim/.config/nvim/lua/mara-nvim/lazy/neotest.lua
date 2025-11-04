return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"marilari88/neotest-vitest",
		},
		keys = {
			{ "<leader>tr", "<cmd>Neotest run<cr>", desc = "Run test" },
			{ "<leader>ti", "<cmd>Neotest output<cr>", desc = "Run output" },
			{ "<leader>ts", "<cmd>Neotest summary<cr>", desc = "Run summary" },
		},
		config = function()
			local neotest = require("neotest")

			---@diagnostic disable-next-line: missing-fields
			neotest.setup({
				adapters = {
					require("neotest-vitest"),
				},
			})
		end,
	},
}
