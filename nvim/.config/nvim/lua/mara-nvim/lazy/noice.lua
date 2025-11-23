return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	opts = {
		cmdline = {
			enabled = true,
			view = "cmdline_popup",
			format = {
				cmdline = {
					icon = ":",
				},
			},
		},
		-- Disable ALL Noice views except cmdline
		messages = { enabled = false },
		popupmenu = { enabled = false },
		notify = { enabled = false },
		lsp = {
			progress = { enabled = false },
			hover = { enabled = false },
			signature = { enabled = false },
			message = { enabled = false },
		},
		views = {
			cmdline_popup = {
				position = {
					row = "30%",
					col = "50%",
				},
				size = {
					width = 60,
					height = "auto",
				},
				border = {
					style = "rounded",
				},
				win_options = {
					winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
				},
			},
		},
		presets = {
			bottom_search = false,
			command_palette = false,
			long_message_to_split = false,
			inc_rename = false,
			lsp_doc_border = false,
		},
	},
}
