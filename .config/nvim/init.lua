require('shoop')

vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.wrap = false
vim.o.scrolloff = 10
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
    command = "if mode() != 'c' | checktime | endif",
    pattern = { "*" },
})

vim.o.background = "dark"
require("gruvbox").setup({
    undercurl = true,
    underline = true,
    bold = true,
    italic = {
        strings = false,
        comments = false,
        operators = false,
        folds = true,
    },
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = true,    -- invert background for search, diffs, statuslines and errors
    contrast = "hard", -- can be "hard", "soft" or empty string
    palette_overrides = {},
    overrides = {},
    dim_inactive = false,
    transparent_mode = true,
})
vim.cmd([[colorscheme gruvbox]])

vim.g.python3_host_prog = "/usr/bin/python3" -- fixes python for vimspector
vim.g.mapleader = ' '
vim.opt.timeoutlen = 500

vim.cmd('source ~/.config/nvim/vimrc.vim')

-- config
vim.keymap.set("n", "<leader>vim", ":e ~/.config/nvim/vimrc.vim<CR>")
vim.keymap.set("n", "<leader>pack", ":e ~/.config/nvim/lua/shoop/packer.lua<CR>")
vim.keymap.set("n", "<leader>init", ":e ~/.config/nvim/init.lua<cr>")

-- tabs
vim.keymap.set("n", "gj", ":tabm -1<cr>")
vim.keymap.set("n", "gk", ":tabm +1<cr>")
vim.keymap.set("n", "<C-t>", ":tabnew<cr>")
vim.keymap.set("n", "<C-x>", ":tabc<cr>")

-- move lines
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- search/replace
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- ctrl+s save
vim.keymap.set("n", "<C-s>", ":w<cr>")

-- skill issue mappings
vim.keymap.set("i", "<,", "<<")
vim.keymap.set("i", ":;", "::")
