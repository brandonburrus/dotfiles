-- AI completion
return {
  'github/copilot.vim',
  cmd = 'Copilot',
  lazy = false,
  config = function()
    vim.g.copilot_enabled = true
    vim.g.copilot_no_tab_map = true
    vim.keymap.set('i', '<M-Space>', 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false,
      silent = true,
    })
    vim.keymap.set('i', '<M-h>', '<Plug>(copilot-dismiss)')
    vim.keymap.set('i', '<M-j>', '<Plug>(copilot-next)')
    vim.keymap.set('i', '<M-k>', '<Plug>(copilot-previous)')
    vim.keymap.set('i', '<M-l>', '<Plug>(copilot-suggest)')
    vim.keymap.set('i', '<M-J>', '<Plug>(copilot-accept-line)')
  end,
}