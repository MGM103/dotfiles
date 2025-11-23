return {
	"folke/trouble.nvim",
	cmd = "Trouble",
	opts = {
		auto_close = true,
		auto_preview = true,
		focus = true,
		warn_no_results = false,
		modes = {
			preview_float = {
				mode = "diagnostics",
				preview = {
					type = "float",
					relative = "editor",
					border = "rounded",
					title = "Issue",
					title_pos = "left",
					position = { 0, -2 },
					size = { width = 0.5, height = 0.6 },
					zindex = 200,
				},
			},
			symbols = {
				desc = "document symbols",
				mode = "lsp_document_symbols",
				focus = true,
				win = {
					type = "float",
					relative = "editor",
					border = "rounded",
					title = "Symbols",
					title_pos = "left",
					position = { 0, -2 },
					size = { width = 0.5, height = 0.6 },
					zindex = 200,
				},
			},
		},
	},
	keys = {
		{
			"<leader>D",
			function()
				require("trouble").toggle("preview_float")
			end,
			desc = "Diagnostics (Trouble)",
		},
		{
			"<leader>d",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "Buffer Diagnostics (Trouble)",
		},
		{
			"<leader>xs",
			function()
				require("trouble").toggle("symbols")
				vim.cmd("wincmd p")
			end,
			desc = "Trouble symbol",
		},
	},
}
