-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>r", vim.diagnostic.open_float, { desc = "Show diagnostic e[R]ror messages" })
vim.keymap.set("n", "<leader>rf", vim.diagnostic.setloclist, { desc = "Open diagnostic e[R]rors quick[F]ix list" })

-- I like hls sue me
vim.keymap.set({"n", "v"}, "<leader>n", ":noh<CR>")

-- Explore (show project tree)
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "[E]xplore : Toggle NvimTree" })

-- Line separators
-- vim.keymap.set("n", "<leader>sep", "o------------------------------------  <C-c>hhyiw$pbhi",
--     { desc = "line [SEP]arator" })


-- Terminal
vim.keymap.set("t", "<C-e>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<leader>tj", ":split<CR>:terminal<CR><C-w>15-", { desc = "Open terminal window in lower pane" })
vim.keymap.set("n", "<leader>th", function()
    vim.cmd("vsplit")
    vim.cmd("wincmd h")
    vim.cmd("terminal")
    vim.api.nvim_win_set_width(0, 75) -- terminal window width
end, { desc = "Open terminal window in new left pane" })

-- #################################### Navigation ####################################
-- resize
-- vim.keymap.set("n", "<leader>rh", "<cmd> resize 10<CR>")

vim.keymap.set("n", "J", "myJ`y", { silent = true }) -- don't move cursor when calling J

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- zellij-style splits
vim.keymap.set({ "n", "v", "x" }, "<leader>pl", ":vsp<CR>")
vim.keymap.set({ "n", "v", "x" }, "<leader>ph", ":vsp<CR>")
vim.keymap.set({ "n", "v", "x" }, '<leader>pj', ":sp<CR>")
vim.keymap.set({ "n", "v", "x" }, '<leader>pk', ":sp<CR>")

-- <C-d> and <C-u> center the screen verically
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- search terms stay in the middle verically
-- vim.keymap.set("n", "n", "nzzzv")
-- vim.keymap.set("n", "N", "Nzzzv")

-- so that in visual block mode <C-c> = escape ffs
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- to investigate some time
-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz") -- for going through errors
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz") -- for going through errors
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz") -- jumping to locations
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz") -- jumping to locations
--
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Cursed
-- vim.keymap.set({ "n", "v" }, "h", "<nop>")
-- vim.keymap.set({ "n", "v" }, "l", "<nop>")

-- Miscellaneous
vim.keymap.set("n", "<leader>z", ":ZenMode<CR>", { desc = "Toggle [Z]enMode" });
vim.keymap.set({ "n", "v", "x" }, "<leader>ch", ":ColorizerToggle<CR>", { desc = "Toggle [C]olorizer [H]ighlight" });

-- AUTOCOMMANDS
-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("kickstart_highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Hop
-- place this in one of your configuration file(s)
-- local hop = require('hop')
-- local directions = require('hop.hint').HintDirection
-- vim.keymap.set('', 'f', function()
--     hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
-- end, { remap = true })
-- vim.keymap.set('', 'F', function()
--     hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
-- end, { remap = true })
-- vim.keymap.set('', 't', function()
--     hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
-- end, { remap = true })
-- vim.keymap.set('', 'T', function()
--     hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
-- end, { remap = true })

-- mon petit cheval de bois qui se fait la malle comme un petit salaud
