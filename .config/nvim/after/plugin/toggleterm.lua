require("toggleterm").setup {
	size = 15,
	open_mapping = [[<C-\>]],
	start_in_insert = true,
	direction = "float",
	shell = "bash",
    shade_terminals = true,
	float_opts = {
		border = "curved",
		width = math.ceil(vim.o.columns*0.7),
		height = math.ceil(vim.o.lines*0.8)
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

local ssh = Terminal:new(
    {
        name = "ssh",
        dir = "/home/cshoop/code",
        cmd = "ssh -p 6969 cshoop@192.168.0.176",
        direction = "float",
        count = 5,
        float_opts =
        {
            border = "single",
            width = math.ceil(vim.o.columns*0.8),
            height = math.ceil(vim.o.lines*0.8)
        }
    }
)
function _ssh()
    ssh:toggle()
end
vim.api.nvim_set_keymap("n", "<leader>ssh", "<cmd>lua _ssh()<CR>", {noremap = true, silent = true})

local runnotifier = Terminal:new(
    {
        name = "run notifier",
        dir = "/home/cshoop/code/notifier",
        cmd = "python3 notifier.py || read -p 'Holding...'",
        direction = "float",
        count = 6,
        float_opts =
        {
            border = "single",
            width = math.ceil(vim.o.columns*0.6),
            height = math.ceil(vim.o.lines*0.8)
        }
    }
)
function _runnotifier()
    runnotifier:toggle()
end
vim.api.nvim_set_keymap("n", "<leader>rn", "<cmd>lua _runnotifier()<CR>", {noremap = true, silent = true})

local runscheduler = Terminal:new(
    {
        name = "run scheduler",
        dir = "/home/cshoop/code/Scheduler",
        cmd = "python3 scheduler.py || read -p 'Holding...'",
        direction = "float",
        count = 7,
        float_opts =
        {
            border = "single",
            width = math.ceil(vim.o.columns*0.6),
            height = math.ceil(vim.o.lines*0.8)
        }
    }
)
function _runscheduler()
    runscheduler:toggle()
end
vim.api.nvim_set_keymap("n", "<leader>rs", "<cmd>lua _runscheduler()<CR>", {noremap = true, silent = true})
