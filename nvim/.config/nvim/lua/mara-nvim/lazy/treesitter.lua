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
	"tsx",
	"typescript",
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

		local function start(buf, lang)
			if not pcall(vim.treesitter.start, buf, lang) then
				return
			end
			vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end

		-- The main branch has no auto_install, so install missing parsers on demand.
		local available, attempted = nil, {}
		vim.api.nvim_create_autocmd("FileType", {
			desc = "Enable treesitter highlighting and indentation",
			callback = function(args)
				local lang = vim.treesitter.language.get_lang(args.match)
				if not lang then
					return
				end
				local loaded, added = pcall(vim.treesitter.language.add, lang)
				if loaded and added then
					return start(args.buf, lang)
				end

				available = available or ts.get_available()
				if attempted[lang] or not vim.tbl_contains(available, lang) then
					return
				end
				attempted[lang] = true
				ts.install(lang):await(function(err)
					if err then
						return
					end
					vim.schedule(function()
						if vim.api.nvim_buf_is_valid(args.buf) then
							start(args.buf, lang)
						end
					end)
				end)
			end,
		})
	end,
}
