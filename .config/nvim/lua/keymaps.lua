vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

local leader_cmd_maps = {
  ['e'] = 'NvimTreeToggle',
  ['t'] = 'Toggle',
  ['w'] = 'BufferClose',
  [','] = 'BufferPrevious',
  ['.'] = 'BufferNext',
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