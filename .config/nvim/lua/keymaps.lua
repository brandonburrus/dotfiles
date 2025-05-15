vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

local leader_cmd_maps = {
  ['e'] = 'NvimTreeToggle',
  ['t'] = 'Toggle',
  ['w'] = 'BD',
  [','] = 'bp',
  ['.'] = 'bn',
  ['p'] = 'BufferPick',
  ['no'] = 'nohls',
  ['l'] = 'Lazy',
  ['3'] = 'set relativenumber!',
  ['co'] = 'Copilot panel',
  ['cs'] = 'Copilot status',
  ['ce'] = 'Copilot enable',
  ['cd'] = 'Copilot disable',
  ['o'] = 'Telescope smart_open',
  ['ff'] = 'Telescope find_files',
  ['fg'] = 'Telescope live_grep',
  ['fr'] = 'Telescope registers',
  ['fm'] = 'Telescope marks',
  ['fk'] = 'Telescope keymaps',
  ['fb'] = 'Telescope buffers',
  ['fr'] = 'Telescope lsp_references',
  ['fs'] = 'Telescope lsp_symbols',
  ['gh'] = 'GBrowse',
  ['gf'] = 'NvimTreeFindFile',
  ['u'] = 'UndotreeToggle',
}

for key, mapping in pairs(leader_cmd_maps) do
  vim.keymap.set('n', '<leader>'..key, '<cmd>'..mapping..'<cr>', {
    silent = true,
    noremap = true,
  })
end

vim.keymap.set('n', '<leader>rr', '<cmd>source $HOME/.config/nvim/init.lua<cr>')
vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', { silent = true })
vim.keymap.set('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<cr>', { silent = true })

-- Window resizing
vim.keymap.set('n', '<Up>', '<cmd>resize +2<cr>', { silent = true, remap = false })
vim.keymap.set('n', '<Down>', '<cmd>resize -2<cr>', { silent = true, remap = false })
vim.keymap.set('n', '<Left>', '<cmd>vertical resize +2<cr>', { silent = true, remap = false })
vim.keymap.set('n', '<Right>', '<cmd>vertical resize -2<cr>', { silent = true, remap = false })

-- Diagnostic jumping
vim.keymap.set('n', '[g', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']g', vim.diagnostic.goto_next)

-- Sneak
vim.keymap.set('n', 's', '<Plug>Sneak_s', { noremap = true, silent = true })
vim.keymap.set('n', 'S', '<Plug>Sneak_S', { noremap = true, silent = true })
vim.keymap.set('n', 'f', '<Plug>Sneak_f', { noremap = true, silent = true })
vim.keymap.set('n', 'F', '<Plug>Sneak_F', { noremap = true, silent = true })
vim.keymap.set('n', 't', '<Plug>Sneak_t', { noremap = true, silent = true })
vim.keymap.set('n', 'T', '<Plug>Sneak_T', { noremap = true, silent = true })
vim.keymap.set('n', '<leader><leader>', '<Plug>(easymotion-prefix)', { noremap = true, silent = true })

