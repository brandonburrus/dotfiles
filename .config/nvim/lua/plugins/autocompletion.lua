-- Auto-completion on tab press
return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    {
      "mason-org/mason-lspconfig.nvim",
      opts = {},
      dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
      },
    },
    'hrsh7th/cmp-nvim-lsp',
    {
      'windwp/nvim-autopairs',
      event = "InsertEnter",
      config = true
    },
    'onsails/lspkind.nvim',
    {
      'L3MON4D3/LuaSnip',
      lazy = false,
      dependencies = {
        --'honza/vim-snippets',
        'saadparwaiz1/cmp_luasnip',
      }
    },
  },
  config = function()
    local lsp_servers = {
      -- "ts_ls",
      -- "pyright",
      -- "rust_analyzer",
      -- "gopls",
      -- "jsonls",
      -- "vimls",
      -- "lua_ls",
      --"html",
      --"cssls",
      -- "bashls",
      -- "tailwindcss",
      -- "dockerls",
      -- "yamlls",
      --"biome",
      -- "sqls",
      -- "marksman",
      --"svelte",
      --"eslint",
    }

    require 'mason'.setup()
    require 'mason-lspconfig'.setup {
      automatic_enable = false,
      ensure_installed = lsp_servers,
    }

    local lspconfig = require 'lspconfig'
    local cmp = require 'cmp'
    local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
    local lspkind = require 'lspkind'
    local luasnip = require 'luasnip'

    cmp.setup {
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete {},
        ['<C-x>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      formatting = {
        format = lspkind.cmp_format(),
      },
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
      }, {
        { name = 'buffer' },
      }),
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
    }

    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require 'cmp_nvim_lsp'.default_capabilities(capabilities)

    local on_attach = function(_, buffer)
      local attach_opts = { silent = false, buffer = buffer }
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, attach_opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, attach_opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, attach_opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, attach_opts)
      vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, attach_opts)
      vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, attach_opts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, attach_opts)
      vim.keymap.set('n', 'so', require('telescope.builtin').lsp_references, attach_opts)
    end
    for _, lsp in pairs(lsp_servers) do
      lspconfig[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
      }
    end

    luasnip.config.setup {}
    --require("luasnip.loaders.from_snipmate").lazy_load()
    require 'luasnip.loaders.from_snipmate'.lazy_load({
      paths = { "~/.config/nvim/snippets" }
    })
  end
}
