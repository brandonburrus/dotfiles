return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'folke/todo-comments.nvim',
  },
  config = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = {
        'lua', 'vim', 'vimdoc',
        'elixir', 'javascript', 'typescript',
        'html', 'css', 'python',
        'json', 'toml', 'yaml', 'csv',
        'dart', 'dockerfile',
        'git_config', 'go', 'gomod', 'gosum',
        'graphql', 'helm', 'java',
        'markdown', 'scss', 'bash',
        'gdscript', 'godot_resource', 'gdshader',
      },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
