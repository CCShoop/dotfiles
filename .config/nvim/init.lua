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

vim.g.python3_host_prog = "/usr/bin/python3" -- fixes python for vimspector
vim.g.mapleader = ' '
vim.opt.timeoutlen = 500

vim.cmd('source ~/.config/nvim/vimrc.vim')

-- config
vim.keymap.set("n", "<leader>vim", ":e ~/.config/nvim/vimrc.vim<CR>")
vim.keymap.set("n", "<leader>pack", ":e ~/.config/nvim/lua/shoop/packer.lua<CR>")
vim.keymap.set("n", "<leader>init", ":e ~/.config/nvim/init.lua<cr>")
vim.keymap.set("n", "<leader>term", ":e ~/.config/nvim/after/plugin/toggleterm.lua<CR>")

-- tabs
vim.keymap.set("n", "gj", ":tabm -1<cr>")
vim.keymap.set("n", "gk", ":tabm +1<cr>")
vim.keymap.set("n", "<C-t>", ":tabnew<cr>")
vim.keymap.set("n", "<C-x>", ":tabc<cr>")

-- move lines
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- search/replace
vim.keymap.set("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- session management
vim.keymap.set("n", "<leader>sl", ":SessionSave<cr>:SessionSelect<cr>")

-- other
vim.keymap.set("n", "<C-s>", ":w<cr>")
vim.keymap.set("n", "<leader>n", ":noh<cr>")

-- skill issue mappings
vim.keymap.set("i", "<,", "<<")
vim.keymap.set("i", ":;", "::")
