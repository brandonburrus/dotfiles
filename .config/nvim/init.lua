vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.smartcase = true
vim.opt.ignorecase = true

vim.opt.number = true
vim.opt.numberwidth = 4
vim.opt.relativenumber = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.undofile = false
vim.opt.undolevels = 10000

vim.opt.guicursor = "a:blinkon0,n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
vim.opt.cursorline = false
vim.opt.laststatus = 0

vim.opt.wildmenu = true
vim.opt.completeopt = "preview,menu,popup" --noinsert?

vim.opt.autoread = true
vim.opt.backup = false
vim.opt.wrap = false
vim.opt.scrolloff = 0
vim.opt.hidden = true
vim.opt.modelines = 1

vim.opt.belloff = "all"
vim.opt.errorbells = false
vim.opt.visualbell = false

vim.opt.foldlevelstart = 99
vim.opt.foldmethod = "indent"

vim.opt.cmdheight = 1
vim.opt.shell = "/bash/zsh"
vim.opt.shortmess = "a"
vim.opt.showcmd = true
vim.opt.exrc = true
vim.opt.secure = true

vim.opt.ruler = false
vim.opt.showmode = false
vim.opt.signcolumn = "yes"

vim.opt.lazyredraw = true
vim.opt.linespace = 2
vim.opt.modelines = 0

vim.opt.spell = false --TODO: Figure out spell checker
vim.opt.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,terminal"
vim.opt.updatetime = 400

vim.opt.fillchars = "eob: "
vim.opt.termguicolors = true
vim.opt.mouse = ""

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.cmd 'colorscheme neonchalk'

require 'keymaps'
require 'plug_manager'
