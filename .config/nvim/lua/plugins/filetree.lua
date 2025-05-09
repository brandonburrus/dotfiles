-- File explorer side window
return {
  'nvim-tree/nvim-tree.lua',
  config = function()
    local icons = require 'icons'
    require 'nvim-tree'.setup {
      disable_netrw = true,
      sort = {
        sorter = 'extension'
      },
      view = {
        width = 42,
        side = "right",
        signcolumn = "yes"
      },
      filters = {
        dotfiles = true,
      },
      renderer = {
        group_empty = true,
        icons = {
          padding = "  ",
          show = {
            folder_arrow = false,
            git = false,
            bookmarks = false,
          }
        }
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
        debounce_delay = 500,
        severity = {
          min = vim.diagnostic.severity.HINT,
          max = vim.diagnostic.severity.ERROR,
        },
        icons = {
          error = icons.diagnostic.Error,
          warning = icons.diagnostic.Warn,
          info = icons.diagnostic.Info,
          hint = icons.diagnostic.Hint,
        },
      },
    }
  end
}