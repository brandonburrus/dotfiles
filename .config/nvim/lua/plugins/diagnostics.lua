-- Diagnostics
return {
  { 'qpkorr/vim-bufkill', },
  {
    'folke/trouble.nvim',
    cmd = "Trouble",
    keys = {
      { "<leader>x", "<cmd>Trouble diagnostics toggle<cr>" },
    },
  },
  {
    'sontungexpt/better-diagnostic-virtual-text',
    event = 'LspAttach',
    config = function()
      require 'better-diagnostic-virtual-text'.setup {
        ui = {
          wrap_line_after = false,
          left_kept_space = 3,
          right_kept_space = 3,
          arrow = "  ",
          up_arrow = "  ",
          down_arrow = "  ",
          above = false,
        },
        inline = true,
      }
    end
  },
}
