-- https://github.com/numToStr/Comment.nvim
return {
  'numToStr/Comment.nvim',
  config = function()
    require 'Comment'.setup {
      opleader = {
        line = 'gc',
        block = 'gb',
      },
      extra = {
        above = 'gcO',
        below = 'gco',
        eol = 'gcA',
      },
      mappings = {
        basic = true,
        extra = true,
      },
    }
  end
}