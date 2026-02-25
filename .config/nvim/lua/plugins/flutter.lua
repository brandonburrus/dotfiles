return {
  'nvim-flutter/flutter-tools.nvim',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'stevearc/dressing.nvim',
    'nvim-flutter/pubspec-assist.nvim',
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
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

    require 'flutter-tools'.setup {
      widget_guides = {
        enabled = true,
      },
      closing_tags = {
        highlight = "FlutterWidgetGuides",
        prefix = "",
        priority = 10,
        enabled = true,
      },
      lsp = {
        capabilities = capabilities,
        on_attach = on_attach,
      },
    }
  end
}
