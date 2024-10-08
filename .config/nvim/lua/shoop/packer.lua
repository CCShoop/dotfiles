vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
      fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
      vim.cmd [[packadd packer.nvim]]
      return true
    end
    return false
  end


  local packer_bootstrap = ensure_packer()

  return require('packer').startup(function(use)
    -- packer plugin manager
    use 'wbthomason/packer.nvim'

    -- neodev
    use { "folke/neodev.nvim", opts = {} }

    -- global search/replace
    use('nvim-lua/plenary.nvim')
    use('nvim-pack/nvim-spectre')
    -- telescope fuzzy finder
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' }
    use {
		'nvim-telescope/telescope.nvim', tag = '0.1.4',
		-- or                          , branch = '0.1.x',
		requires = { {'nvim-lua/plenary.nvim'} }
    }

    use('christoomey/vim-tmux-navigator')
    -- colorscheme
    use('folke/tokyonight.nvim')
    require('tokyonight').setup({
        transparent = true
    })

    -- session persistence
    use({
        'olimorris/persisted.nvim',
        config = function()
            require('persisted').setup({
                use_git_branch = true,
                autoload = true,
                on_autoload_no_session = function()
                    vim.notify("No session found.")
                end
            })
        end,
    })
    -- undo tree
    use('mbbill/undotree') 

    -- make terminal
    use('tpope/vim-dispatch')
    use('radenling/vim-dispatch-neovim')
    use('akinsho/toggleterm.nvim')
    -- switch between cpp/h
    use('vim-scripts/a.vim')
    -- file tree
    use('nvim-tree/nvim-tree.lua')
    use('nvim-tree/nvim-web-devicons')

    -- debugger
    use( 'puremourning/vimspector'
        --cmd = { "VimspectorInstall", "VimspectorUpdate" },
        --fn = { "vimspector#Launch()", "vimspector#ToggleBreakpoint", "vimspector#Continue" }
    )

    -- comments
    use('tomtom/tcomment_vim')
    -- don't comment when making a newline from a comment
    vim.cmd('autocmd BufEnter * set formatoptions-=cro')
    vim.cmd('autocmd BufEnter * setlocal formatoptions-=cro')

    -- autopairing
    use{
        'altermo/ultimate-autopair.nvim',
        event={'InsertEnter','CmdlineEnter'},
        branch='v0.6', --recommended as each new version will have breaking changes
        config=function ()
            require('ultimate-autopair').setup({
                fastwarp={
                    multi=true,
                    {},
                    {faster=true,map='<A-e>',cmap='<A-e>'},
                },
                {'<','>',
                    multiline=false,
                    ft={'cpp', 'hpp', 'h'}
                }
            })
        end,
    }
    -- html autopairing
    use('windwp/nvim-ts-autotag')
    -- alignment
    use{'echasnovski/mini.align', version = '*'}
    

    -- invisible code nodes
    use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
    use {
        requires = { "nvim-treesitter/nvim-treesitter" },
        "Badhi/nvim-treesitter-cpp-tools",
    }
    use('nvim-treesitter/nvim-treesitter-textobjects')
    use('nvim-treesitter/playground')
    -- language servers
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},             -- Required
            {                                      -- Optional
            'williamboman/mason.nvim',
            run = function()
                pcall(vim.cmd, 'MasonUpdate')
            end,
            },
            {'williamboman/mason-lspconfig.nvim'}, -- Optional
  
            -- Autocompletion
            {'hrsh7th/nvim-cmp'},     -- Required
            {'hrsh7th/cmp-nvim-lsp'}, -- Required
            {'L3MON4D3/LuaSnip'},     -- Required
        }
    }

    -- git
    use({
        "kdheepak/lazygit.nvim",
        -- optional for floating window border decoration
        requires = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("telescope").load_extension("lazygit")
        end,
    })

    -- git changes in buffer, inline git blame
    use('lewis6991/gitsigns.nvim')

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
      require('packer').sync()
    end
  end)
