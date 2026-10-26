local M = {}

-- Neovim 0.12 only sends the diagnostics under the cursor with a code action
-- request, so fixes (e.g. spelling suggestions) needed the cursor on the word.
-- When the cursor isn't on a diagnostic, target the nearest one on the line.
function M.line()
	local mode = vim.api.nvim_get_mode().mode
	if mode ~= "n" then
		return vim.lsp.buf.code_action()
	end

	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local nearest, best
	for _, d in ipairs(vim.diagnostic.get(0, { lnum = row - 1 })) do
		local end_col = (d.end_lnum or d.lnum) == d.lnum and d.end_col or math.huge
		if col >= d.col and col < math.max(end_col, d.col + 1) then
			return vim.lsp.buf.code_action()
		end
		local dist = col < d.col and d.col - col or col - end_col
		if not best or dist < best then
			nearest, best = d, dist
		end
	end

	if not nearest then
		return vim.lsp.buf.code_action()
	end

	local end_col = math.max(nearest.end_col or nearest.col, nearest.col + 1)
	vim.lsp.buf.code_action({
		range = {
			start = { nearest.lnum + 1, nearest.col },
			["end"] = { (nearest.end_lnum or nearest.lnum) + 1, end_col - 1 },
		},
	})
end

return M
