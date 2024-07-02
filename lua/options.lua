vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showmode = false

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.virtualedit = "block"
vim.opt.wrap = false
vim.opt.scrolloff = 7 -- Minimal number o flines to keep above and below cursor
vim.opt.undofile = true

-- insensitive case unless using \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes" -- remove to not have signcolumn
vim.opt.updatetime = 1000  -- default is 4000 (ms) -> 4 sec (time for writing to swap file)

-- Decrease mapped sequence wait time. Displays which-key popup sooner (default = 1000 ms)
vim.opt.timeoutlen = 300

-- split below and right instead of up and left
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
-- See :h 'list'
-- See :h 'listchars'
-- vim.opt.list = true -- default false
-- vim.opt.listchars = { tab = ' something
vim.opt.termguicolors = true -- 24-bit colours -- defaults to true since 0.10 version?

-- ??
-- Preview substitutions live, as you type
vim.opt.inccommand = "split"
-- cursor line is slightly highlighted
vim.opt.cursorline = true

-- neovide
vim.g.neovide_position_animation_length = 0
vim.g.neovide_touch_drag_timeout = 0
