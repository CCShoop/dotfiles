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
-- require("gruvbox").setup({
--     undercurl = true,
--     underline = true,
--     bold = true,
--     italic = {
--         strings = false,
--         comments = false,
--         operators = false,
--         folds = true,
--     },
--     strikethrough = true,
--     invert_selection = false,
--     invert_signs = false,
--     invert_tabline = false,
--     invert_intend_guides = false,
--     inverse = true,    -- invert background for search, diffs, statuslines and errors
--     contrast = "hard", -- can be "hard", "soft" or empty string
--     palette_overrides = {},
--     overrides = {},
--     dim_inactive = false,
--     transparent_mode = true,
-- })
-- vim.cmd([[colorscheme gruvbox]])
-- require("catppuccin").setup({
--     flavour = "latte", -- latte, frappe, macchiato, mocha
--     background = { -- :h background
--         light = "latte",
--         dark = "mocha",
--     },
--     transparent_background = true, -- disables setting the background color.
--     show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
--     term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
--     dim_inactive = {
--         enabled = false, -- dims the background color of inactive window
--         shade = "dark",
--         percentage = 0.15, -- percentage of the shade to apply to the inactive window
--     },
--     no_italic = false, -- Force no italic
--     no_bold = false, -- Force no bold
--     no_underline = false, -- Force no underline
--     styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
--         comments = {}, -- Change the style of comments
--         conditionals = {},
--         loops = {},
--         functions = {},
--         keywords = {},
--         strings = {},
--         variables = {},
--         numbers = {},
--         booleans = {},
--         properties = {},
--         types = {},
--         operators = {},
--         -- miscs = {}, -- Uncomment to turn off hard-coded styles
--     },
--     color_overrides = {},
--     custom_highlights = {},
--     default_integrations = true,
--     integrations = {
--         cmp = true,
--         gitsigns = true,
--         nvimtree = true,
--         treesitter = true,
--         notify = false,
--         mini = {
--             enabled = true,
--             indentscope_color = "",
--         },
--         fzf = true,
--         mason = true,
--         native_lsp = {
--             enabled = true,
--             virtual_text = {
--                 errors = { "italic" },
--                 hints = { "italic" },
--                 warnings = { "italic" },
--                 information = { "italic" },
--                 ok = { "italic" },
--             },
--             underlines = {
--                 errors = { "underline" },
--                 hints = { "underline" },
--                 warnings = { "underline" },
--                 information = { "underline" },
--                 ok = { "underline" },
--             },
--             inlay_hints = {
--                 background = true,
--             },
--         },
--         telescope = {
--             enabled = true,
--             -- style = "nvchad"
--         }
--         -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
--     },
-- })
-- vim.cmd([[colorscheme catppuccin]])
require('tokyonight').setup({
    transparent = true
})
-- vim.cmd([[colorscheme tokyonight-night]])
vim.cmd([[colorscheme tokyonight-storm]])
-- vim.cmd([[colorscheme tokyonight-day]])
-- vim.cmd([[colorscheme tokyonight-moon]])

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
