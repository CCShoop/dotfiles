require("neodev").setup({
    -- add any options here, or leave empty to use the default settings
  })

  -- completion
  local cmp = require('cmp')
  local cmp_select = {behavior = cmp.SelectBehavior.Select}
  cmp.setup({
    snippet = {
      expand = function(args) require('luasnip').lsp_expand(args.body) end,
    },
    sources = {
      {name = 'nvim_lsp'},
    },
    mapping = cmp.mapping.preset.insert({
     ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
     ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
     ['<C-y>'] = cmp.mapping.confirm({ select = true }),
     ['<C-Space>'] = cmp.mapping.complete(),
    }),
  })

  -- applies to every server
  vim.lsp.config('*', {
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
  })

  vim.lsp.config('pylsp', {
    settings = {
      pylsp = {
        plugins = {
          mccabe = { enabled = false }, -- function complexity warnings
        },
      },
    },
  })

  -- vim.lsp.config('clangd', {
  --     init_options = { compilationDatabasePath = "./build", },
  -- })

  -- mason-lspconfig v2 calls vim.lsp.enable() for every installed server
  require('mason').setup()
  require('mason-lspconfig').setup({
    ensure_installed = {
      'clangd',
      'cmake',
      'pylsp',
    },
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local opts = {buffer = args.buf, remap = false}
      vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
      vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
      vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
      vim.keymap.set("n", "[d", function() vim.diagnostic.jump({count = -1, float = true}) end, opts)
      vim.keymap.set("n", "]d", function() vim.diagnostic.jump({count = 1, float = true}) end, opts)
      vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
      vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
      vim.keymap.set("n", "<M-f>", function() vim.lsp.buf.references() end, opts)
      vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
      vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    end,
  })

  --require('lspconfig').sourcekit.setup()
  --vim.lsp.enable('sourcekit')


  -- require("mason").setup {
  --     log_level = vim.log.levels.DEBUG
  -- }
  --require("mason.health").check()
  --vim.env.PATH = "C:/msys64/mingw64/bin:" .. vim.env.PATH
