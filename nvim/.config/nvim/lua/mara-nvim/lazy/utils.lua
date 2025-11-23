return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		-- use opts = {} for passing setup options
		-- this is equivalent to setup({}) function
	},
	{
		"andymass/vim-matchup",
		setup = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					-- Defaults
					enable_close = true, -- Auto close tags
					enable_rename = true, -- Auto rename pairs of tags
					enable_close_on_slash = false, -- Auto close on trailing </
					aliases = {
						-- Treat 'templ' files as if they were 'html'
						templ = "html",
					},
				},
			})
		end,
	},
	{
		"sQVe/sort.nvim",
		opts = {
			mappings = false,
		},
		keys = {
			{ "<leader>a", "<Esc><Cmd>Sort<CR>", mode = "v", desc = "Sort lines/items alphabetically" },
		},
		config = function()
			require("sort").setup({
				-- (Optional) configuration can go here. Defaults are usually fine.
			})
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
}
