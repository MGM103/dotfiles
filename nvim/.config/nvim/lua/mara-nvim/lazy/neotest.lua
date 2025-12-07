return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"marilari88/neotest-vitest",
			"nvim-neotest/neotest-go",
		},
		keys = {
			{ "<leader>tr", "<cmd>Neotest run<cr>", desc = "Run test" },
			{ "<leader>ts", "<cmd>Neotest summary<cr>", desc = "Run summary" },
			{ "<leader>tn", "<cmd>Neotest jump next<cr>", desc = "Next test" },
			{ "<leader>tp", "<cmd>Neotest jump prev<cr>", desc = "Prev test" },
		},
		config = function()
			local neotest = require("neotest")

			---@diagnostic disable-next-line: missing-fields
			neotest.setup({
				adapters = {
					require("neotest-vitest"),
					require("neotest-go"),
				},
			})
		end,
	},
}
