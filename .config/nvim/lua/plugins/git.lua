-- Git
return {
  'tpope/vim-fugitive', -- Better git commands
  'tpope/vim-rhubarb', -- Integrate fugitive w/ GitHub
  {
    'lewis6991/gitsigns.nvim', -- Adds git signs to the sidebar
    config = function()
      require 'gitsigns'.setup()
    end
  },
}
