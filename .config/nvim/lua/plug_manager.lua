-- Plugin spec manifest
local spec = {
    { 'lukelbd/vim-toggle' },
    { 'matze/vim-move' },
    { 'mhinz/vim-startify' },
    { 'qpkorr/vim-bufkill' },
    { 'tpope/vim-commentary' },
    { 'tpope/vim-surround' },
    { 'lewis6991/gitsigns.nvim' },
    { 'nvim-tree/nvim-web-devicons' },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                ensure_installed = { "vim", "vimdoc", "query", "javascript", "html" },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            -- 'kyazdani42/nvim-web-devicons'
        }
    },
    {
        'akinsho/bufferline.nvim',
        version = '*',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        }
    },
    {
        'neoclide/coc.nvim',
        branch = 'release',
        init = function()
            vim.g.coc_global_extensions = {
                "coc-docker",
                "coc-docthis",
                "coc-go",
                "coc-html",
                "coc-jest",
                "coc-json",
                "coc-pairs",
                "coc-protobuf",
                "coc-pyright",
                -- "coc-rust-analyzer",
                "coc-sh",
                "coc-spell-checker",
                "coc-sql",
                "coc-tailwindcss",
                "coc-toml",
                "coc-tsserver",
                "coc-yaml",
            }
            vim.cmd([[
                inoremap <silent><expr> <c-space> coc#refresh()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
                nmap <silent> [g <Plug>(coc-diagnostic-prev)
                nmap <silent> ]g <Plug>(coc-diagnostic-next)
                nmap <silent> gd <Plug>(coc-definition)
                nmap <silent> gy <Plug>(coc-type-definition)
                nmap <silent> gi <Plug>(coc-implementation)
                nmap <silent> gr <Plug>(coc-references)
                autocmd CursorHold * silent call CocActionAsync('highlight')
                nmap <leader>rn <Plug>(coc-rename)
                xmap <leader>a <Plug>(coc-codeaction-selected)
                nmap <leader>a <Plug>(coc-codeaction-selected)
                xmap <leader>t <Plug>(coc-codeaction)
                nmap <leader>t <Plug>(coc-codeaction)
                nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
                xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
                nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
                xmap if <Plug>(coc-funcobj-i)
                omap if <Plug>(coc-funcobj-i)
                xmap af <Plug>(coc-funcobj-a)
                omap af <Plug>(coc-funcobj-a)
                xmap ic <Plug>(coc-classobj-i)
                omap ic <Plug>(coc-classobj-i)
                xmap ac <Plug>(coc-classobj-a)
                omap ac <Plug>(coc-classobj-a)

                inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
                inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

                function! CheckBackspace() abort
                  let col = col('.') - 1
                  return !col || getline('.')[col - 1]  =~# '\s'
                endfunction

                inoremap <silent><expr> <Tab>
                      \ coc#pum#visible() ? coc#pum#next(1) :
                      \ CheckBackspace() ? "\<Tab>" :
                      \ coc#refresh()

                inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
            ]])
        end,
    },
    { 'github/copilot.vim' },
    {
      "olimorris/codecompanion.nvim",
      opts = {},
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
    },
}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = spec,
    install = { colorscheme = { "neonchalk" } },
    checker = { enabled = false },
})

require('nvim-web-devicons').setup({
  default = true,
  strict = true,
  variant = "dark",
  override_by_extension = {
    ["rs"] = {
      name = "Rust",
      icon = "",
      color = "#ce412b"
    },
  },
  override_by_filename = {
    ["Cargo.toml"] = {
      name = "CargoToml",
      icon = "",
      color = "#a43322"
    },
    ["Cargo.lock"] = {
      name = "CargoLock",
      icon = "",
      color = "#535353"
    },
    ["README.md"] = {
      name = "ReadmeMd",
      icon = "",
      color = "#888899"
    },
    ["package.json"] = {
      name = "PackageJson",
      icon = "",
      color = "#339933"
    },
    ["nodemon.json"] = {
      name = "PackageJson",
      icon = "",
      color = "#339933"
    },
    ["tsconfig.json"] = {
      name = "TsconfigJson",
      icon = "",
      color = "#007ACC",
    }
  }
})

require("gitsigns").setup()

require("nvim-tree").setup({
    disable_netrw = true,
    sort = {
        sorter = 'extension'
    },
    view = {
        width = 40,
        side = "right",
        signcolumn = "yes"
    },
    filters = {
        dotfiles = true,
    },
    renderer = {
        group_empty = true,
        icons = {
            padding = "  ",
            show = {
                folder_arrow = false,
                git = false,
                bookmarks = false,
            }
        }
    }
})

require('nvim-treesitter.configs').setup({
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    }
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

vim.g.startify_change_to_dir = 1
vim.g.startify_change_to_vcs_root = 1
vim.g.startify_files_number = 10
vim.g.startify_session_autoload = 1
vim.g.startify_session_persistence = 1
vim.g.startify_session_sort = 1
vim.g.startify_custom_header = 'startify#pad(startify#fortune#boxed())'

vim.g.startify_lists = {
    { type = 'sessions',  header = { '   Projects' } },
    { type = 'files',     header = { '   Recently opened' } },
    { type = 'bookmarks', header = { '   Bookmarks' } },
    { type = 'commands',  header = { '   Commands' } },
}

vim.g.startify_skiplist = { 'COMMIT_EDITMSG' }

local bg = '#201D26'
local defaultObj = {
    fg = 'white',
    bg = bg
}
require('bufferline').setup({
    highlights = {
        fill = {
            fg = 'white',
            bg = '#1b1820'
        },
        background = {
            fg = 'white',
            bg = bg
        },
        buffer_visible = {
            fg = 'white',
            bg = bg,
            italic = false
        },
        buffer_selected = {
            fg = 'white',
            bg = bg,
            italic = false
        },
        tab = defaultObj,
        numbers = defaultObj,
        numbers_selected = defaultObj,
        diagnostic = defaultObj,
        diagnostic_visible = defaultObj,
        diagnostic_selected = defaultObj,
        hint = defaultObj,
        hint_visible = defaultObj,
        hint_selected = defaultObj,
        hint_diagnostic = defaultObj,
        hint_diagnostic_visible = defaultObj,
        hint_diagnostic_selected = defaultObj,
        info = defaultObj,
        info_visible = defaultObj,
        info_selected = defaultObj,
        info_diagnostic = defaultObj,
        info_diagnostic_visible = defaultObj,
        info_diagnostic_selected = defaultObj,
        warning = defaultObj,
        warning_visible = defaultObj,
        warning_selected = defaultObj,
        warning_diagnostic = defaultObj,
        warning_diagnostic_visible = defaultObj,
        warning_diagnostic_selected = defaultObj,
        error = defaultObj,
        error_visible = defaultObj,
        error_selected = defaultObj,
        error_diagnostic = defaultObj,
        error_diagnostic_visible = defaultObj,
        error_diagnostic_selected = defaultObj,
        modified = defaultObj,
        modified_visible = defaultObj,
        modified_selected = defaultObj,
        duplicate_selected = defaultObj,
        duplicate_visible = defaultObj,
        duplicate = defaultObj,
        separator_selected = {
            fg = bg,
            bg = bg
        },
        separator_visible = {
            fg = bg,
            bg = bg
        },
        separator = {
            fg = bg,
            bg = bg
        },
        indicator_selected = {
            fg = '#02a7ff',
            bg = bg
        },
        pick_selected = {
            fg = bg,
            bg = bg,
            italic = false
        },
        pick_visible = {
            fg = bg,
            bg = bg,
            italic = false
        },
        pick = {
            fg = bg,
            bg = bg,
            italic = false
        },
        offset_separator = defaultObj
    },
    options = {
        buffer_close_icon = '',
        close_icon = '',
        diagnostics = 'coc',
        show_buffer_close_icons = false,
        show_close_icon = false,
        show_tab_indicators = false,
    }
})

require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = "anthropic",
    },
    inline = {
      adapter = "anthropic",
    },
  },
})

