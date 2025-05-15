-- File search window fuzzy finder
return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make'
    },
    {
      'danielfalk/smart-open.nvim',
      branch = "0.2.x",
      dependencies = {
        'kkharji/sqlite.lua',
      },
    },
    'nvim-telescope/telescope-dap.nvim'
  },
  config = function()
    local telescope = require 'telescope'
    telescope.setup {
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        smart_open = {
          match_algorithm = "fzf",
        },
      }
    }
    telescope.load_extension('fzf')
    telescope.load_extension('smart_open')
    telescope.load_extension('flutter')
    telescope.load_extension('dap')
  end
}
