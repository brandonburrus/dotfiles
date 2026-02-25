-- Better syntax highlighting for files
return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'folke/todo-comments.nvim',
  },
  config = function () 
    require 'nvim-treesitter.configs'.setup {
      auto_install = true,
      sync_install = false,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true
      },  
      ensure_installed = {
        'lua',
        'vim',
        'vimdoc',
        'elixir',
        'javascript',
        'typescript',
        'html',
        'css',
        'python',
        'json',
        'toml',
        'yaml',
        'csv',
        'dart',
        'dockerfile',
        'git_config',
        'go',
        'gomod',
        'gosum',
        'graphql',
        'helm',
        'java',
        'markdown',
        'scss',
        'bash',
        'gdscript',
        'godot_resource',
        'gdshader',
      },
    }
  end
}
