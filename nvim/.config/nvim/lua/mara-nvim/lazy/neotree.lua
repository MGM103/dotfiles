return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		{ "MunifTanjim/nui.nvim", commit = "8d3bce9764e627b62b07424e0df77f680d47ffdb" },
		-- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	lazy = false, -- neo-tree will lazily load itself
	---@module "neo-tree"
	---@type neotree.Config?
	opts = {
		-- fill any relevant options here
	},

	vim.keymap.set("n", "<leader>n", function()
		vim.cmd("Neotree float")
	end, { desc = "[N]eotree window" }),
}
