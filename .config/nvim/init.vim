" === General Config ================================================================================= "

set encoding=utf-8                    " Use UTF-8 encoding in buffers
filetype plugin indent on

syntax on                             " Enable syntax highlighting
colorscheme neonchalk                 " Set colorscheme

set autoindent                        " Use the previous lines indentation when adding new lines
set expandtab                         " Use spaces instead of tabs
set smarttab                          " Insert the appropriate number of tabs when indenting
set tabstop=2                         " Use 2 spaces as the tab stop for buffers
set softtabstop=2                     " Count 2 spaces as a tab when editing indentation
set shiftwidth=2                      " Use 2 spaces be default for automatic indentation

set hlsearch                          " Highlight search matches
set incsearch                         " Show partial matches while entering a search
set smartcase                         " Smartly ignore case sensitivity when searching

set number                            " Enable line numbers
set numberwidth=4                     " Use 4 character columns for line numbers
set relativenumber                    " Enable relative line numbers

set splitbelow                        " Horizontal splits always open below the current buffer
set splitright                        " Vertical splits always open on the right of the current buffer

set undofile                          " Enable undo persistence via undo files
set undodir=~/.config/nvim/undodir    " Directory to use for persisting undo history
set undolevels=10000                  " Number of changes to remember that can be undone

set guicursor+=a:blinkon0             " Disable cursor blinking
set guioptions=                       " Reset to the default gui options
set nocursorline                      " Disable adding highlight group to the line the cursor is on

set completeopt+=preview              " Show extra preview info in auto-complete menu
set wildmenu                          " Enable auto-complete menu

set autoread                          " Auto-detect file changes outside of vim
set nobackup                          " Disable backup file when overwriting an existing file
set nowrap                            " Disable line wrapping
set scrolloff=0                       " How many lines can the screen scroll beyond the last line in the buffer
set hidden                            " Allow buffers with unsaved changes to exist in the background
set modelines=1                       " Enable modelines on the last line of a buffer

set belloff=all                       " Turn off the notification sound for everything
set noerrorbells                      " Disable error bell for editor errors/warnings
set novisualbell                      " Disable visual (flashing) bell for notifications

set foldignore=                       " Turn off any fold ignoring
set foldlevelstart=99                 " Start auto-folding at the given indentation level
set foldmethod=indent                 " Use indentation to auto-create folds

set cmdheight=1                       " Use a single line for Ex commands
set shell=/bin/zsh                    " Use Zsh as the preferred shell
set shortmess=a                       " Always prefer shorter error msgs
set showcmd                           " Show the result of cmds in the cmd line
set exrc                              " Enable project-specific vimrc config file
set secure                            " Disable insecure commands in project-specific vimrc files

set noruler                           " Disable showing the current line/column the cursor is at
set noshowmode                        " Disable showing current mode
set signcolumn=yes                    " Always show the sign column (on the left)

set lazyredraw                        " Disable screen redrawing while executing macros, registers or other commands.
set linespace=2                       " Num of pixels to add between every line vertically
set modelines=0                       " Disable mode lines

set nospell                           " Disable vim spellchecker (use coc-spell-checker instead)
set sessionoptions-=blank             " Do no store empty windows in saved sessions
set updatetime=400                    " How often to store file changes in swap files (recovery/auto-save)

set fillchars+=vert:\                 " Special character to use to separate vertical splits


" === Mappings ======================================================================================= "

noremap <SPACE> <nop>
let mapleader=" "

inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

map <Bslash> <Plug>(easymotion-prefix)

map S <Plug>Sneak_S
map s <Plug>Sneak_s
map F <Plug>Sneak_F
map T <Plug>Sneak_T
map f <Plug>Sneak_f
map t <Plug>Sneak_t

map <silent> w <Plug>CamelCaseMotion_w
sunmap w
map <silent> b <Plug>CamelCaseMotion_b
sunmap b
map <silent> e <Plug>CamelCaseMotion_e
sunmap e
map <silent> ge <Plug>CamelCaseMotion_ge
sunmap ge

nnoremap gd <Plug>(coc-definition)
nnoremap gi <Plug>(coc-implementation)
nnoremap gr <Plug>(joc-references)
nnoremap gy <Plug>(coc-type-definition)

nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

nnoremap <leader><ESC> :Startify<CR>

function! ToggleNERDTree()
  NERDTreeToggle
  silent NERDTreeMirror
endfunction

nnoremap <leader>W  :bd<CR>
nnoremap <leader>bf :Buffers<CR>
nnoremap <leader>cm :Commands<CR>
nnoremap <leader>co :Commits<CR>
nnoremap <leader>cp :SClose<CR>
nnoremap <leader>f  :CocAction<CR>
nnoremap <leader>fh :BCommits<CR>
nnoremap <leader>fl :Files<CR>
nnoremap <leader>g0 :diffget //3<CR>
nnoremap <leader>g1 :diffget //2<CR>
nnoremap <leader>gb :G blame<CR>
nnoremap <leader>gc :G commit<CR>
nnoremap <leader>gd :CocDisable<CR>:Gvdiffsplit!<CR>
nnoremap <leader>gf :GFiles<CR>
nnoremap <leader>gh :History<CR>
nnoremap <leader>gl :GBranches<CR>
nnoremap <leader>gp :G push<CR>
nnoremap <leader>gs :G status<CR>
nnoremap <leader>gt :GTags<CR>
nnoremap <leader>h  :call <SID>show_documentation()<CR>
nnoremap <leader>mk :Marks<CR>
nnoremap <leader>mp :Maps<CR>
nnoremap <leader>no :nohls<CR>
nnoremap <leader>nt :call ToggleNERDTree()<CR>
nnoremap <leader>pc :PlugClean<CR>
nnoremap <leader>pi :PlugInstall<CR>
nnoremap <leader>pu :PlugUpdate<CR>
nnoremap <leader>rN :set relativenumber!<CR>
nnoremap <leader>rc :CocAction refactor<CR>
nnoremap <leader>re <Plug>(coc-rename)
nnoremap <leader>rf :NERDTreeFind<CR>
nnoremap <leader>rl :so ~/.config/nvim/init.vim<CR>
nnoremap <leader>rn :set relativenumber<CR>
nnoremap <leader>s  :Ag<CR>
nnoremap <leader>us :Snippets<CR>
nnoremap <leader>ut :UndotreeToggle<CR>
nnoremap <leader>w  :BD<CR>

noremap <leader>/ :Commentary<CR>
nnoremap <leader>, :bp<CR>
nnoremap <leader>. :bn<CR>

noremap <C-b> :Toggle<CR>
noremap <C-.> :CocAction<CR>

nnoremap = +
nnoremap + =

nnoremap ' `
nnoremap ` '

nnoremap ]e :call CocAction('diagnosticNext')<CR>
nnoremap [e :call CocAction('diagnosticPrevious')<CR>
nnoremap ]h <Plug>(GitGutterNextHunk)
nnoremap [h <Plug>(GitGutterPrevHunk)

nnoremap <Down> :resize +1<CR>
nnoremap <Left> :vertical resize -1<CR>
nnoremap <Right> :vertical resize +1<CR>
nnoremap <Up> :resize -1<CR>

nmap Q <nop>

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" Bind for cycling through auto-complete menu
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" === Plugins ======================================================================================== "

if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin("~/.config/nvim/autoload")

" Motions
Plug 'bkad/camelcasemotion'                       " Word-wise motions respect camelCase
Plug 'christoomey/vim-sort-motion'                " Sort lines but as a motion
Plug 'easymotion/vim-easymotion'                  " Better search as a motion
Plug 'justinmk/vim-sneak'                         " Rebind s to two-letter jump
Plug 'tpope/vim-surround'                         " Surrounding pairwise characters as a motion

" Actions
Plug 'jiangmiao/auto-pairs'                       " Auto-close pairwise characters
Plug 'junegunn/vim-easy-align'                    " Text alignment action
Plug 'lukelbd/vim-toggle'                         " Make boolean-like words toggleable
Plug 'sgur/vim-textobj-parameter'                 " Parameters as text objs
Plug 'tommcdo/vim-exchange'                       " Swap two text chunks
Plug 'tpope/vim-commentary'                       " Better commenting
Plug 'tpope/vim-repeat'                           " Make more things dot repeatable
Plug 'junegunn/vim-slash'                         " Better search

" Text Objects
Plug 'glts/vim-textobj-comment'                   " Comments as a text obj
Plug 'kana/vim-textobj-entire'                    " Entire buffer as a text obj
Plug 'kana/vim-textobj-function'                  " Function defs as text objs
Plug 'kana/vim-textobj-line'                      " Lines as text objs
Plug 'kana/vim-textobj-user'                      " Core plugin for enabling custom text objs

" Language-specific Integrations
Plug 'fatih/vim-go'                               " Better Go development
Plug 'sheerun/vim-polyglot'                       " Language pack

" Editor Enhancements
Plug 'SirVer/ultisnips'                           " Snippet manager
Plug 'airblade/vim-gitgutter'                     " Gutter signs for git hunks
Plug 'haya14busa/incsearch.vim'                   " Better incremental search
Plug 'junegunn/fzf', {'do': { -> fzf#install() }} " FZF integration
Plug 'junegunn/fzf.vim'                           " FZF integration
Plug 'kshenoy/vim-signature'                      " Gutter signs for marks
Plug 'mbbill/undotree'                            " Visual tree for undo history
Plug 'mhinz/vim-startify'                         " Better start screen
Plug 'neoclide/coc.nvim', {'branch': 'release'}   " Intellisense
Plug 'qpkorr/vim-bufkill'                         " Better buffer closing
Plug 'ryanoasis/vim-devicons'                     " Icons
Plug 'scrooloose/nerdtree'                        " Visual file tree explorer
Plug 'stsewd/fzf-checkout.vim'                    " Git + FZF integration
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'    " Colors for Nerd Tree
Plug 'tpope/vim-fugitive'                         " Git integration
Plug 'tpope/vim-obsession'                        " Auto session management
Plug 'tpope/vim-rhubarb'                          " GitHub integration for fugitive
Plug 'vim-airline/vim-airline'                    " Better status line
Plug 'vim-airline/vim-airline-themes'             " Themes for status line

call plug#end()


" === Plugin Configs ================================================================================= "

" Startify

let g:startify_change_to_dir       = 1
let g:startify_change_to_vcs_root  = 1
let g:startify_files_number        = 10
let g:startify_session_autoload    = 1
let g:startify_session_persistence = 1
let g:startify_session_sort        = 1
let g:startify_custom_header       = 'startify#pad(startify#fortune#boxed())'

let g:startify_lists = [
      \ { 'type': 'sessions',   'header': ['   Projects'] },
      \ { 'type': 'files',      'header': ['   Recently opened'] },
      \ { 'type': 'bookmarks',  'header': ['   Bookmarks'] },
      \ { 'type': 'commands',   'header': ['   Commands'] },
      \ ]

let g:startify_skiplist = [
      \ 'COMMIT_EDITMSG',
      \ ]

" Airline

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline#extensions#coc#error_symbol   = 'E:'
let g:airline#extensions#coc#warning_symbol = 'W:'

let g:airline#extensions#csv#enabled         = 0
let g:airline#extensions#searchcount#enabled = 0
let g:airline#extensions#searchcount#enabled = 0
let g:airline#extensions#wordcount#enabled   = 0

let g:airline#extensions#tabline#enabled       = 1
let g:airline#extensions#tabline#buffers_label = ''
let g:airline#extensions#tabline#formatter     = 'unique_tail'
let g:airline#extensions#tabline#left_alt_sep  = ''
let g:airline#extensions#tabline#left_sep      = ''
let g:airline#extensions#tabline#right_alt_sep = ''
let g:airline#extensions#tabline#right_sep     = ''

let g:airline_detect_paste     = 0
let g:airline_detect_crypt     = 0
let g:airline_detect_spell     = 0
let g:airline_detect_spelllang = 0

let g:airline_theme           = 'minimalist'
let g:airline_powerline_fonts = 1

function! AirlineInit() abort
  let g:airline_section_a = airline#section#create([''])
  let g:airline_section_b = airline#section#create(['mode'])
  let g:airline_section_c = airline#section#create(['branch'])
  let g:airline_section_y = airline#section#create([])
  let g:airline_section_z = airline#section#create(['%{strftime("%I:%M %p")}'])
endfunction
autocmd User AirlineAfterInit call AirlineInit()

let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'

let g:airline_left_sep          = ''
let g:airline_left_alt_sep      = ''
let g:airline_right_sep         = ''
let g:airline_right_alt_sep     = ''
let g:airline_symbols.branch    = ''
let g:airline_symbols.dirty     = ' '
let g:airline_symbols.notexists = ''

" CoC

let g:coc_global_extensions = [
      \ "coc-calc",
      \ "coc-css",
      \ "coc-docker",
      \ "coc-docthis",
      \ "coc-emmet",
      \ "coc-git",
      \ "coc-go",
      \ "coc-html",
      \ "coc-jest",
      \ "coc-json",
      \ "coc-protobuf",
      \ "coc-pyright",
      \ "coc-sh",
      \ "coc-spell-checker",
      \ "coc-sql",
      \ "coc-swagger",
      \ "coc-tailwindcss",
      \ "coc-toml",
      \ "coc-tsserver",
      \ "coc-vimlsp",
      \ "coc-xml",
      \ "coc-yaml",
      \ "coc-yank"
      \ ]

if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
  let g:coc_global_extensions += ['coc-prettier']
endif

if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif

" FZF

let g:fzf_buffers_jump   = 1
let g:fzf_tags_command   = 'ctags -R --exclude=.git --exclude=log'
let g:fzf_layout         = { 'window': { 'width': 0.9, 'height': 0.9 } }
let g:fzf_preview_window = ['right:60%', 'ctrl-p']
let $FZF_DEFAULT_OPTS    = '--layout=reverse --border=sharp --cycle --tabstop=2'

" Git Gutter

let g:gitgutter_show_msg_on_hunk_jumping        = 1
let g:gitgutter_override_sign_column_highlight  = 0
let g:gitgutter_set_sign_backgrounds            = 0
let g:gitgutter_max_signs                       = 500
let g:gitgutter_async                           = 1

" Go

let g:go_highlight_build_constraints     = 1
let g:go_highlight_diagnostic_warnings   = 0
let g:go_highlight_extra_types           = 1
let g:go_highlight_fields                = 1
let g:go_highlight_format_strings        = 1
let g:go_highlight_function_calls        = 1
let g:go_highlight_function_parameters   = 1
let g:go_highlight_functions             = 1
let g:go_highlight_generate_tags         = 1
let g:go_highlight_methods               = 1
let g:go_highlight_operators             = 1
let g:go_highlight_string_spellcheck     = 0
let g:go_highlight_structs               = 1
let g:go_highlight_types                 = 1
let g:go_highlight_variable_declarations = 1
let g:go_auto_sameids                    = 0
let g:go_decls_mode                      = 'fzf'

" Nerd Tree

let g:NERDTreeDirArrowCollapsible = ''
let g:NERDTreeDirArrowExpandable  = ''
let g:NERDTreeIgnore              = ['node_modules']
let g:NERDTreeWinPos              = 'right'
let g:NERDTreeMinimalUI           = 1
let g:NERDTreeWinSize             = 42
let g:NERDTreeMinimalMenu         = 1
let g:NERDAutoDeleteBuffer        = 1
let g:NERDTreeMapCustomOpen       = 'o'

" UltiSnips

let g:UltiSnipsExpandTrigger       = "<C-Space>"
let g:UltiSnipsJumpBackwardTrigger = "<C-k>"
let g:UltiSnipsJumpForwardTrigger  = "<C-j>"

" Nerd Tree Colors

if !exists('g:NERDTreeExtensionHighlightColor')
  let g:NERDTreeExtensionHighlightColor = {}
endif

let g:NERDTreeExtensionHighlightColor['Dockerfile']   = '0DB7ED'
let g:NERDTreeExtensionHighlightColor['css']          = '2965F1'
let g:NERDTreeExtensionHighlightColor['go']           = '29BEB0'
let g:NERDTreeExtensionHighlightColor['gql']          = 'E10098'
let g:NERDTreeExtensionHighlightColor['graphql']      = 'E10098'
let g:NERDTreeExtensionHighlightColor['html']         = 'E44D26'
let g:NERDTreeExtensionHighlightColor['java']         = 'f89820'
let g:NERDTreeExtensionHighlightColor['jpg']          = '00A98F'
let g:NERDTreeExtensionHighlightColor['js']           = 'F7DF1E'
let g:NERDTreeExtensionHighlightColor['json']         = '5382A1'
let g:NERDTreeExtensionHighlightColor['jsx']          = '61DBFB'
let g:NERDTreeExtensionHighlightColor['kt']           = 'F6891F'
let g:NERDTreeExtensionHighlightColor['lua']          = '000080'
let g:NERDTreeExtensionHighlightColor['md']           = '037EF3'
let g:NERDTreeExtensionHighlightColor['pem']          = '5382A1'
let g:NERDTreeExtensionHighlightColor['png']          = '00A98F'
let g:NERDTreeExtensionHighlightColor['ppk']          = '5382A1'
let g:NERDTreeExtensionHighlightColor['properties']   = '5382A1'
let g:NERDTreeExtensionHighlightColor['pub']          = '5382A1'
let g:NERDTreeExtensionHighlightColor['py']           = '3EB049'
let g:NERDTreeExtensionHighlightColor['rb']           = 'CC0000'
let g:NERDTreeExtensionHighlightColor['rs']           = 'FE5000'
let g:NERDTreeExtensionHighlightColor['sass']         = 'CD6799'
let g:NERDTreeExtensionHighlightColor['scala']        = 'DE3423'
let g:NERDTreeExtensionHighlightColor['scss']         = 'CD6799'
let g:NERDTreeExtensionHighlightColor['sh']           = '9F9FA3'
let g:NERDTreeExtensionHighlightColor['sql']          = '1793D1'
let g:NERDTreeExtensionHighlightColor['swift']        = 'F05138'
let g:NERDTreeExtensionHighlightColor['tf']           = '844FBA'
let g:NERDTreeExtensionHighlightColor['ts']           = '007ACC'
let g:NERDTreeExtensionHighlightColor['tsx']          = '007ACC'
let g:NERDTreeExtensionHighlightColor['txt']          = 'FFE873'
let g:NERDTreeExtensionHighlightColor['vim']          = '019833'
let g:NERDTreeExtensionHighlightColor['vue']          = '41B883'
let g:NERDTreeExtensionHighlightColor['yaml']         = '5382A1'
let g:NERDTreeExtensionHighlightColor['go']           = '29BEB0'
let g:NERDTreeExtensionHighlightColor['mod']          = '29BEB0'
let g:NERDTreeExtensionHighlightColor['sum']          = '29BEB0'
let g:NERDTreeExtensionHighlightColor['tmpl']         = '29BEB0'
let g:NERDTreeExtensionHighlightColor['proto']        = '379C9C'

let g:WebDevIconsDefaultFileSymbolColor               = 'CCCCCC'

" Dev Icons

if !exists('g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols')
  let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {}
endif

if !exists('g:WebDevIconsUnicodeDecorateFileNodesExactSymbols')
  let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols = {}
endif

let g:webdevicons_enable                                                = 1
let g:webdevicons_enable_airline_statusline                             = 1
let g:webdevicons_enable_airline_tabline                                = 1
let g:webdevicons_enable_nerdtree                                       = 1
let g:webdevicons_enable_startify                                       = 1

let g:webdevicons_conceal_nerdtree_brackets                             = 1

let g:WebDevIconsOS                                                     = 'Darwin'
let g:WebDevIconsNerdTreeAfterGlyphPadding                              = ' '

let g:DevIconsEnableFolderExtensionPatternMatching                      = 0
let g:DevIconsEnableFolderPatternMatching                               = 1
let g:DevIconsEnableFoldersOpenClose                                    = 1
let g:WebDevIconsEnableFoldersOpenClose                                 = 1
let g:WebDevIconsUnicodeDecorateFolderNodes                             = 1
let g:WebDevIconsUnicodeDecorateFolderNodesExactMatches                 = 1

let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['java']       = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['properties'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['xml']        = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['class']      = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['tf']         = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['pub']        = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['pem']        = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['ppk']        = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['c']          = 'ﭰ'
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['cpp']        = 'ﭱ'
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['md']         = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['html']       = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['rss']        = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['rb']         = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['zip']        = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['test.js']    = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['test.ts']    = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['test.jsx']   = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['test.tsx']   = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['pdf']        = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['csv']        = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['Dockerfile'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['css']        = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['scss']       = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['sass']       = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['jsx']        = 'ﰆ'
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['tsx']        = 'ﰆ'
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['kt']         = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['rs']         = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['graphql']    = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['gql']        = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['WORKSPACE']  = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['BUILD']      = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['go']         = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['mod']        = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['sum']        = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['tmpl']       = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['proto']      = ''

let g:WebDevIconsUnicodeDecorateFileNodesDefaultSymbol                  = ''
let g:DevIconsDefaultFolderOpenSymbol                                   = ''
let g:WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol                = ''

if exists("g:loaded_webdevicons")
  call webdevicons#refresh()
endif

nohls
