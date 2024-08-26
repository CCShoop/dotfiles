require("toggleterm").setup {
	size = 15,
	open_mapping = [[<C-\>]],
	start_in_insert = true,
	direction = "horizontal",
	shell = "bash",
    shade_terminals = true,
	float_opts = {
		border = "curved",
		width = math.ceil(vim.o.columns*0.8),
		height = math.ceil(vim.o.lines*0.9)
	},
    winbar = {
    enabled = false,
    name_formatter = function(term) --  term: Terminal
      return term.name
    end
  },
}

local Terminal = require('toggleterm.terminal').Terminal

local lazygit = Terminal:new(
    {
        cmd = "lazygit",
        direction = "float",
        hidden = true,
        count = 10
    }
)
function _lazygit_toggle()
    lazygit:toggle()
end
vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})

local build = Terminal:new(
    {
        name = "erctd build",
        cmd = "make -j10 -C /home/cshoop/erctd/build/linux-gcc-x64-debug || read -p 'Build error!'",
        dir = "/home/cshoop/erctd",
        direction = "float",
        count = 69,
        on_open = function(term)
            vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
        end
    }
)
function _build()
    build:toggle()
end
vim.api.nvim_set_keymap("n", "<leader>b", "<cmd>lua _build()<CR>", {noremap = true, silent = true})
