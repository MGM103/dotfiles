return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		{ "MunifTanjim/nui.nvim", commit = "8d3bce9764e627b62b07424e0df77f680d47ffdb" },
		"saifulapm/neotree-file-nesting-config", -- add plugin as dependency. no need any other config or setup call
		-- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	lazy = false, -- neo-tree will lazily load itself
	---@module "neo-tree"
	---@type neotree.Config?
	opts = {
		hide_root_node = true,
		retain_hidden_root_indent = true,
		filesystem = {
			filtered_items = {
				show_hidden_count = false,
			},
		},
		default_component_configs = {
			indent = {
				with_expanders = true,
				expander_collapsed = "",
				expander_expanded = "",
			},
		},
	},
	config = function(_, opts)
		opts.nesting_rules = require("neotree-file-nesting-config").nesting_rules
		require("neo-tree").setup(opts)
	end,

	vim.keymap.set("n", "<leader>n", function()
		vim.cmd("Neotree float reveal")
	end, { desc = "[N]eotree window" }),
}
