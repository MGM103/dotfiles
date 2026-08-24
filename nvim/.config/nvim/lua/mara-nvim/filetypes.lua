-- Defining custom behaviour for specific filetypes
vim.filetype.add({
	extension = {
		env = "sh",
		templ = "templ",
		svg = "xml",
	},
	filename = {
		[".env"] = "sh",
	},
	pattern = {
		["%.env%.[%w_.-]+"] = "sh",
		[".*%.swagger%.js"] = "yaml",
	},
})

-- Enabling Emmet shortcuts in .templ files like HTML
vim.g.user_emmet_settings = {
	templ = {
		extends = "html",
	},
}
