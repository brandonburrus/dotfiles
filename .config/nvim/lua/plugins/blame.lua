return {
  'f-person/git-blame.nvim',
  event = "VeryLazy",
  config = function()
    require 'gitblame'.setup {
      enabled = false,
      date_format = '%Y-%m-%d',
      virtual_text = true,
      virtual_text_pos = 'eol',
      sign_priority = 6,
      update_in_insert = false,
      delay = 200,
      highlight_group = 'GitBlame',
    }
  end
}
