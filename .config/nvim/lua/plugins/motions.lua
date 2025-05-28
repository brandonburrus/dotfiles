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
    'Wansmer/treesj', -- Split/join treesitter nodes
    config = function()
      require('treesj').setup({
        use_default_keymaps = false,
        max_join_length = 120, -- Maximum length of a line to join
        cursor_behavior = 'start', -- Where to place the cursor after split/join
      })
      vim.keymap.set('n', '<leader>j', '<cmd>TSJToggle<cr>', { desc = 'Split/Join' })
    end
  }
}
