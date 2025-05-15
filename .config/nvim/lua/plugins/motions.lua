-- More motions to make file navigation faster and easier
return {
  'tpope/vim-surround', -- Text objects for "surrounding" like {}, [], "" etc
  'easymotion/vim-easymotion', -- global jump to anywhere
  'justinmk/vim-sneak', -- remap s to be a more powerful f/t
  'matze/vim-move', -- Move lines up and down
  'tpope/vim-repeat', -- Make more things repeatable with .
  'lukelbd/vim-toggle', -- Toggle "boolean"-like words
  'tommcdo/vim-exchange', -- Swap two selections
  {
    'RRethy/nvim-treesitter-textsubjects', -- Text objects based on treesitter parsing
    config = function()
      require('nvim-treesitter-textsubjects').configure({
        prev_selection = ',',
        keymaps = {
          ['.'] = 'textsubjects-smart',
          [';'] = 'textsubjects-container-outer',
          ['i;'] = 'textsubjects-container-inner',
        },
      })
    end
  },
  {
    'jinh0/eyeliner.nvim', -- Show quick indicators when using f/t
    config = function()
      require 'eyeliner'.setup {
        highlight_on_key = true,
        dim = false,             
        max_length = 999,
        default_keymaps = true,
      }
    end
  },
}
