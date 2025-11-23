-- Line number setup
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse in all modes (normal, edit, visual, etc)
vim.opt.mouse = "a"

-- Mode already displayed on the status bar
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
-- Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

-- wrapped text will respect indent
vim.opt.breakindent = true

vim.opt.undofile = true

-- Search (Case-insensitive searching UNLESS \C or one or more capital letters in the search term)
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"

-- Timing
vim.opt.updatetime = 250
vim.opt.timeoutlen = 500

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live
vim.opt.inccommand = "split"

-- Highlight current line
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- -- Folding i.e. collapsing parts of the code
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
