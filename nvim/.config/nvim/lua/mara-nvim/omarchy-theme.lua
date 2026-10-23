local M = {
	colorscheme = nil,
	specs = {},
}

local state_file = vim.fn.expand("~/.local/state/omarchy/current/theme/neovim.lua")

if vim.fn.filereadable(state_file) == 1 then
	local ok, spec = pcall(dofile, state_file)
	if ok and type(spec) == "table" then
		for _, entry in ipairs(spec) do
			if type(entry) == "table" and type(entry[1]) == "string" then
				if entry[1] == "LazyVim/LazyVim" then
					if type(entry.opts) == "table" then
						M.colorscheme = entry.opts.colorscheme
					end
				else
					table.insert(M.specs, entry)
				end
			end
		end
	end
end

function M.apply()
	if M.colorscheme then
		pcall(vim.cmd.colorscheme, M.colorscheme)
	end
	return M.colorscheme
end

return M
