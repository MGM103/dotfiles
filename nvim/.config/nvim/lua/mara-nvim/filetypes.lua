-- Defining custom behaviour for specific filetypes
vim.filetype.add({
	extension = {
		templ = "templ",
	},
})

-- Enabling Emmet shortcuts in .templ files like HTML
vim.g.user_emmet_settings = {
	templ = {
		extends = "html",
	},
}

vim.filetype.add({
	pattern = {
		[".*%.swagger%.js"] = "yaml",
	},
})

vim.filetype.add({
	extension = {
		env = "sh",
	},
	filename = {
		[".env"] = "sh",
	},
	pattern = {
		["%.env%.[%w_.-]+"] = "sh",
	},
})
