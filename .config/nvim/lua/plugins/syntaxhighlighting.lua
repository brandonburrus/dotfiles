return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'folke/todo-comments.nvim',
  },
  config = function()
    -- v1 setup only accepts install_dir; all other options moved to native Neovim APIs
    require('nvim-treesitter').setup()

    local parsers = {
      'lua', 'vim', 'vimdoc',
      'elixir', 'javascript', 'typescript',
      'html', 'css', 'python',
      'json', 'toml', 'yaml', 'csv',
      'dart', 'dockerfile',
      'git_config', 'go', 'gomod', 'gosum',
      'graphql', 'helm', 'java',
      'markdown', 'scss', 'bash',
      'gdscript', 'godot_resource', 'gdshader',
    }

    -- Install any parsers that are not yet present
    require('nvim-treesitter').install(parsers)

    -- Enable treesitter features per filetype via native Neovim APIs
    vim.api.nvim_create_autocmd('FileType', {
      callback = function()
        local ok = pcall(vim.treesitter.start)
        if ok then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
