-- More motions to make file navigation faster and easier
return {
  'kylechui/nvim-surround', -- Text objects for "surrounding" like {}, [], "" etc
  {
    'ggandor/leap.nvim', -- Remap s to a better movement motion
    config = function()
      require 'leap'.set_default_mappings()
    end,
  },
  'matze/vim-move', -- Move lines up and down
  'tpope/vim-repeat', -- Make more things repeatable with .
  'lukelbd/vim-toggle', -- Toggle "boolean"-like words
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