vim.g.mapleader = " "

vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>', { silent = true })
vim.keymap.set('n', '<leader>q', '<cmd>q<cr>', { silent = true })
vim.keymap.set('n', '<leader>w', '<cmd>BD<cr>', { silent = true })
vim.keymap.set('n', '<leader>,', '<cmd>bp<cr>', { silent = true })
vim.keymap.set('n', '<leader>.', '<cmd>bn<cr>', { silent = true })
vim.keymap.set('n', '<leader>no', '<cmd>nohls<cr>', { silent = true })

vim.keymap.set('n', '<leader>ct', '<cmd>:CodeCompanionChat Toggle<cr>', { silent = true })
vim.keymap.set('n', '<leader>c?', '<cmd>:CodeCompanionChat Query<cr>', { silent = true })
vim.keymap.set('n', '<leader>cc', '<cmd>:CodeCompanionChat<cr>', { silent = true })
vim.keymap.set('n', '<leader>ca', '<cmd>:CodeCompanionActions<cr>', { silent = true })

vim.keymap.set('i', '<leader>g', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})
vim.g.copilot_no_tab_map = true

