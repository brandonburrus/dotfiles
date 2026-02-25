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
    -- LSP servers managed by Mason
    local mason_servers = {
      "ts_ls",
      -- "pyright",
      "rust_analyzer",
      "luau_lsp",
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

    -- Additional LSP servers (not managed by Mason)
    local additional_servers = {
      "gdscript",
    }

    -- Combine all servers for setup
    local all_servers = {}
    for _, lsp in pairs(mason_servers) do
      table.insert(all_servers, lsp)
    end
    for _, lsp in pairs(additional_servers) do
      table.insert(all_servers, lsp)
    end

    require 'mason'.setup()
    require 'mason-lspconfig'.setup {
      ensure_installed = mason_servers,
    }

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

    local on_attach = function(client, buffer)
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

    -- Custom configuration for luau_lsp (Roblox)
    vim.lsp.config('luau_lsp', {
      capabilities = capabilities,
      cmd = { 'luau-lsp', 'lsp', '--definitions=~/.local/share/nvim/luau-lsp/globalTypes.d.luau', '--docs=~/.local/share/nvim/luau-lsp/api-docs.json' },
      settings = {
        ['luau-lsp'] = {
          platform = {
            type = 'roblox',
          },
          completion = {
            imports = {
              enabled = true,
            },
          },
        },
      },
    })
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == 'luau_lsp' then
          on_attach(client, args.buf)
        end
      end,
    })

    -- Setup LSP servers using the new vim.lsp.config API
    for _, lsp in pairs(all_servers) do
      if lsp ~= 'luau_lsp' then -- Skip luau_lsp, configured above
        vim.lsp.config(lsp, {
          capabilities = capabilities,
        })
        vim.api.nvim_create_autocmd('LspAttach', {
          callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and client.name == lsp then
              on_attach(client, args.buf)
            end
          end,
        })
      end
    end

    -- Enable LSP servers
    for _, lsp in pairs(all_servers) do
      vim.lsp.enable(lsp)
    end

    luasnip.config.setup {}
    --require("luasnip.loaders.from_snipmate").lazy_load()
    require 'luasnip.loaders.from_snipmate'.lazy_load({
      paths = { "~/.config/nvim/snippets" }
    })
  end
}
