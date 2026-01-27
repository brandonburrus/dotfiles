vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

local leader_cmd_maps = {
  ['e'] = 'NvimTreeToggle',
  ['c'] = 'CodeCompanionChat',

  -- Buffers
  ['w'] = 'BD',
  [','] = 'bp',
  ['.'] = 'bn',

  -- Misc
  ['no'] = 'nohls',
  ['l'] = 'Lazy',
  ['0'] = 'set relativenumber!',
  ['rr'] = 'source $HOME/.config/nvim/init.lua',

  -- Telescope
  ['o'] = 'Telescope smart_open',
  ['fb'] = 'Telescope buffers',
  ['fd'] = 'Telescope lsp_definitions',
  ['ff'] = 'Telescope find_files',
  ['fg'] = 'Telescope live_grep',
  ['fi'] = 'Telescope lsp_implementation',
  ['fk'] = 'Telescope keymaps',
  ['fm'] = 'Telescope marks',
  ['fr'] = 'Telescope lsp_references',
  ['fs'] = 'Telescope lsp_document_symbols',
  ['fw'] = 'Telescope lsp_workspace_symbols',

  -- Git
  ['gf'] = 'NvimTreeFindFile',
  ['gh'] = 'GBrowse',
  ['hP'] = 'Gitsigns preview_buffer',
  ['hR'] = 'Gitsigns reset_buffer',
  ['hS'] = 'Gitsigns stage_buffer',
  ['hU'] = 'Gitsigns undo_stage_buffer',
  ['ha'] = 'Gitsigns stage_hunk',
  ['hb'] = 'GitBlameToggle',
  ['hd'] = 'Gitsigns diffthis',
  ['hp'] = 'Gitsigns preview_hunk',
  ['hr'] = 'Gitsigns undo_stage_hunk',
  ['hu'] = 'Gitsigns reset_hunk',
 
  -- Undotree
  ['u'] = 'UndotreeToggle',
}

for key, mapping in pairs(leader_cmd_maps) do
  vim.keymap.set('n', '<leader>' .. key, '<cmd>' .. mapping .. '<cr>', {
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

-- Hunk jumping
vim.keymap.set('n', '[h', '<cmd>Gitsigns prev_hunk<cr>', { silent = true })
vim.keymap.set('n', ']h', '<cmd>Gitsigns next_hunk<cr>', { silent = true })

-- Sneak
vim.keymap.set('n', 's', '<Plug>Sneak_s', { noremap = true, silent = true })
vim.keymap.set('n', 'S', '<Plug>Sneak_S', { noremap = true, silent = true })
vim.keymap.set('n', 'f', '<Plug>Sneak_f', { noremap = true, silent = true })
vim.keymap.set('n', 'F', '<Plug>Sneak_F', { noremap = true, silent = true })
vim.keymap.set('n', 't', '<Plug>Sneak_t', { noremap = true, silent = true })
vim.keymap.set('n', 'T', '<Plug>Sneak_T', { noremap = true, silent = true })
vim.keymap.set('n', '<leader><leader>', '<Plug>(easymotion-prefix)', { noremap = true, silent = true })

-- Bufferline
vim.keymap.set('n', '<leader>1', '<cmd>BufferLineGoToBuffer 1<cr>', { silent = true })
vim.keymap.set('n', '<leader>2', '<cmd>BufferLineGoToBuffer 2<cr>', { silent = true })
vim.keymap.set('n', '<leader>3', '<cmd>BufferLineGoToBuffer 3<cr>', { silent = true })
vim.keymap.set('n', '<leader>4', '<cmd>BufferLineGoToBuffer 4<cr>', { silent = true })
vim.keymap.set('n', '<leader>5', '<cmd>BufferLineGoToBuffer 5<cr>', { silent = true })
vim.keymap.set('n', '<leader>6', '<cmd>BufferLineGoToBuffer 6<cr>', { silent = true })
vim.keymap.set('n', '<leader>7', '<cmd>BufferLineGoToBuffer 7<cr>', { silent = true })
vim.keymap.set('n', '<leader>8', '<cmd>BufferLineGoToBuffer 8<cr>', { silent = true })
vim.keymap.set('n', '<leader>9', '<cmd>BufferLineGoToBuffer 9<cr>', { silent = true })
