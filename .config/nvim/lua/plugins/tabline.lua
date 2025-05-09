-- Visually display open buffers at the top of the editor
return {
  'romgrk/barbar.nvim',
  opts = {
    animation = false,
    clickable = false,
    icons = {
      buffer_index = false,
      buffer_number = false,
      button = '',
      -- diagnostics = {
      --   [vim.diagnostic.severity.ERROR] = { enabled = true, icon = '' },
      --   [vim.diagnostic.severity.WARN] = { enabled = true, icon = '' },
      --   [vim.diagnostic.severity.INFO] = {enabled = false},
      --   [vim.diagnostic.severity.HINT] = {enabled = false},
      -- },
      gitsigns = {
        added = {enabled = true, icon = '+'},
        changed = {enabled = true, icon = '~'},
        deleted = {enabled = true, icon = '-'},
      },
      separator = {
        left = '',
        right = '',
      },
      separator_at_end = false,
    }
  }
}