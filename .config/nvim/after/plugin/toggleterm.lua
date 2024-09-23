require("toggleterm").setup {
	size = 15,
	open_mapping = [[<C-\>]],
	start_in_insert = true,
	direction = "horizontal",
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

local build = Terminal:new(
    {
        name = "erctd linux build",
        dir = "/home/cshoop/erctd",
        cmd = "make -j16 -C /home/cshoop/erctd/build/linux-gcc-x64-debug && read -p '\nBuild successful! Press ENTER to close.' || read -p '\nERROR: Build failed! Press ENTER to close.'",
        direction = "float",
        count = 69,
        float_opts =
        {
            border = "double",
            width = math.ceil(vim.o.columns*0.6),
            height = math.ceil(vim.o.lines*0.8)
        }
    }
)
function _build()
    build:toggle()
end
vim.api.nvim_set_keymap("n", "<leader>b", "<cmd>lua _build()<CR>", {noremap = true, silent = true})

local winbuild = Terminal:new(
    {
        name = "erctd windows build",
        dir = "/home/cshoop/tools",
        cmd = "./build_erctd_win10.sh && read -p '\nBuild successful! Press ENTER to close.' || read -p '\nERROR: Build failed! Press ENTER to close.'",
        direction = "float",
        count = 6,
        float_opts =
        {
            border = "double",
            width = math.ceil(vim.o.columns*0.6),
            height = math.ceil(vim.o.lines*0.8)
        }
    }
)
function _winbuild()
    winbuild:toggle()
end
vim.api.nvim_set_keymap("n", "<leader>wb", "<cmd>lua _winbuild()<CR>", {noremap = true, silent = true})

local runhal = Terminal:new(
    {
        name = "run hal",
        dir = "/home/cshoop/erctd/build/linux-gcc-x64-debug/hal/server",
        cmd = "./hal",
        direction = "float",
        count = 7,
        float_opts =
        {
            border = "single",
            width = math.ceil(vim.o.columns*0.5),
            height = math.ceil(vim.o.lines*0.6)
        }
    }
)
function _runhal()
    runhal:toggle()
end
vim.api.nvim_set_keymap("n", "<leader>rh", "<cmd>lua _runhal()<CR>", {noremap = true, silent = true})

local runpal = Terminal:new(
    {
        name = "run pal",
        dir = "/home/cshoop/erctd/build/linux-gcc-x64-debug/hal/pal",
        cmd = "./pal",
        direction = "float",
        count = 8,
        float_opts =
        {
            border = "single",
            width = math.ceil(vim.o.columns*0.5),
            height = math.ceil(vim.o.lines*0.6)
        }
    }
)
function _runpal()
    runpal:toggle()
end
vim.api.nvim_set_keymap("n", "<leader>rp", "<cmd>lua _runpal()<CR>", {noremap = true, silent = true})

local runimi = Terminal:new(
    {
        name = "run imi creator",
        dir = "/home/cshoop/avt_tools/imi_creator",
        cmd = "python3 imi_creator.py || read -p 'Holding...'",
        direction = "float",
        count = 9,
        float_opts =
        {
            border = "single",
            width = math.ceil(vim.o.columns*0.5),
            height = math.ceil(vim.o.lines*0.6)
        }
    }
)
function _runimi()
    runimi:toggle()
end
vim.api.nvim_set_keymap("n", "<leader>ri", "<cmd>lua _runimi()<CR>", {noremap = true, silent = true})
