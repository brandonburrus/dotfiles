-- Diagnostics
return {
  { 'qpkorr/vim-bufkill', },
  {
    'folke/trouble.nvim',
    cmd = "Trouble",
    event = "LspAttach",
    opts = {},
    keys = {
      { "<leader>x", "<cmd>Trouble diagnostics toggle<cr>" },
    },
  },
}
