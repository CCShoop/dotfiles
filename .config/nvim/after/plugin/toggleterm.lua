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
		height = math.ceil(vim.o.columns*0.3)
	},
    winbar = {
    enabled = false,
    name_formatter = function(term) --  term: Terminal
      return term.name
    end
  },
}

local Terminal  = require('toggleterm.terminal').Terminal
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
