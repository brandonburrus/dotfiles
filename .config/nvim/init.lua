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

vim.opt.guicursor = 'a:blinkon0,n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20'
vim.opt.cursorline = false
vim.opt.laststatus = 0

vim.opt.wildmenu = true
vim.opt.completeopt = 'preview,menu,popup'

vim.opt.autoread = true
vim.opt.backup = false
vim.opt.wrap = false
vim.opt.scrolloff = 0
vim.opt.hidden = true
vim.opt.modelines = 1

vim.opt.belloff = 'all'
vim.opt.errorbells = false
vim.opt.visualbell = false

vim.opt.foldlevelstart = 99
vim.opt.foldmethod = 'indent'

vim.opt.cmdheight = 1
vim.opt.shell = '/bash/zsh'
vim.opt.shortmess = 'a'
vim.opt.showcmd = true
vim.opt.exrc = true
vim.opt.secure = true

vim.opt.ruler = false
vim.opt.showmode = false
vim.opt.signcolumn = 'yes'

vim.opt.lazyredraw = true
vim.opt.linespace = 2
vim.opt.modelines = 0

vim.opt.spell = false
vim.opt.sessionoptions = 'buffers,curdir,folds,help,tabpages,winsize,terminal'
vim.opt.updatetime = 200

vim.opt.fillchars = 'eob: '
vim.opt.termguicolors = true
vim.opt.mouse = ''

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local icons = require 'icons'

vim.diagnostic.config({
	virtual_text = true,
  update_in_insert = true,
	underline = true,
	signs = true,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "if_many",
		header = "",
		prefix = function(d)
			local d_icon = {
				[vim.diagnostic.severity.HINT] = icons.diagnostic.Hint,
				[vim.diagnostic.severity.INFO] = icons.diagnostic.Info,
				[vim.diagnostic.severity.WARN] = icons.diagnostic.Warn,
				[vim.diagnostic.severity.ERROR] = icons.diagnostic.Error,
			}
			local d_hl = {
				[vim.diagnostic.severity.HINT] = "DiagnosticHint",
				[vim.diagnostic.severity.INFO] = "DiagnosticInfo",
				[vim.diagnostic.severity.WARN] = "DiagnosticWarn",
				[vim.diagnostic.severity.ERROR] = "DiagnosticError",
			}
			return d_icon[d.severity] .. " ", d_hl[d.severity]
		end,
		focusable = false,
	},
})

for _, type in ipairs({ "Error", "Warn", "Hint", "Info" }) do
	vim.fn.sign_define(
		"DiagnosticSign" .. type,
		{ name = "DiagnosticSign" .. type, text = icons.diagnostic[type], texthl = "Diagnostic" .. type }
	)
end

vim.cmd.colorscheme 'neonchalk'

require 'keymaps'
require 'plugin_manager'

vim.deprecate = function() end 
