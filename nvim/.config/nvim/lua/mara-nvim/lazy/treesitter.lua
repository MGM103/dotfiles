local parsers = {
	"bash",
	"c",
	"css",
	"diff",
	"html",
	"javascript",
	"lua",
	"luadoc",
	"markdown",
	"markdown_inline",
	"query",
	"vim",
	"vimdoc",
	"xml",
}

return { -- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local ok, ts = pcall(require, "nvim-treesitter")
		if not ok or type(ts.install) ~= "function" then
			return
		end

		ts.setup({})
		ts.install(parsers)

		vim.api.nvim_create_autocmd("FileType", {
			desc = "Enable treesitter highlighting and indentation",
			callback = function(args)
				if not pcall(vim.treesitter.start, args.buf) then
					return
				end
				vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
