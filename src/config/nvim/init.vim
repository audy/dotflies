"
" Plugins
"

" to setup virtualenv environment:
" pipx install neovim pynvim black flake8 mypy isort
let g:python3_host_prog='/Users/audy/.pyenv/versions/neovim/bin/python'

call plug#begin('~/.config/.nvim/plugged')

" base

Plug 'neomake/neomake' " autodetects mypy, flake8, snakefmt, etc...
Plug 'cloudhead/neovim-fuzzy'
Plug 'haishanh/night-owl.vim'
Plug 'rose-pine/neovim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'SirVer/ultisnips'
Plug 'pechorin/any-jump.vim'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'

"Plug 'github/copilot.vim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

"Plug 'ianks/vim-tsx' " typescript
"Plug 'cespare/vim-toml'
Plug 'LukeGoodsell/nextflow-vim'


" python 

Plug 'sbdchd/neoformat'
Plug 'psf/black', { 'branch': 'stable' }
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'snakemake/snakemake', {'rtp': 'misc/vim'}

call plug#end()


" configure treesitter
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = {'markdown'},  -- list of language that will be disabled
  },
}
EOF

lua << EOF
-- stop snakemake plugin from folding everything by default 😖
vim.o.foldlevelstart = 99
vim.o.foldlevel = 99
EOF

" nvim-tree config
lua << EOF
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
EOF

" run snakefmt on save
let g:black_linelength=100
let g:neoformat_snakemake_snakefmt = {
        \ 'exe': 'snakefmt',
        \ 'args': ['-l '.g:black_linelength, '-'],
        \ 'stdin': 1,
        \ }

let g:neoformat_enabled_snakemake = ['snakefmt']

if exists(":Neoformat")
  command! Snakefmt :Neoformat! snakemake snakefmt
endif

" type Conf to edit config

command Conf execute "tabe ~/.config/nvim/init.vim"


"
" System
"

let mapleader = " "
let maplocalleader = ","

set ic " case-insensitive search
set mouse=vin


set clipboard+=unnamedplus

nnoremap q :q<cr> " kill window with q

" use version control for version control
set autowrite
set autoread

set autoindent

" defaults
set shiftwidth=2
set softtabstop=2
set tabstop=2

" but respect plugin's preferences
filetype plugin indent on

" override markdown
autocmd Filetype markdown setlocal ts=2 sw=2 expandtab

set nowrap
set expandtab " expand tabs to spaces
set nosmarttab " no tabs to begin with
"set nowrap " dont autowrap lines

set backup
set noswapfile

set undodir=~/.vim/tmp/undo//     " undo files
set backupdir=~/.vim/tmp/backup// " backups
set directory=~/.vim/tmp/swap//   " swap files
set undofile
set undoreload=10000

set number
set relativenumber
" don't be cases insensitive if uppercase characters are included in search query
" setting this applies to Deoplete
set smartcase 



" highlight pesky invisible chars
syntax match nonascii "[^\x00-\x7F]"
highlight nonascii guibg=Red ctermbg=2


" return to same line when you reopen vim
augroup line_return
  au!
  au BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \     execute 'normal! g`"zvzz' |
    \ endif
augroup END

"
" Appearance/Theme
"

set background=dark
" so colors work in tmux
set t_Co=256
set termguicolors

" Disable highlighting of builtins (list, len, etc.) by Vim's own Python
" syntax highlighter, because that's Semshi's job. If you turn it off, Vim may
" add incorrect highlights.
"let g:semshi#no_default_buildin_highlight = v:true

" Update all visible highlights for every change. (Semshi tries to detect
" small changes and update only changed highlights. This can lead to some
" missing highlights. Turn this on for more reliable highlighting, but a small
" additional overhead.)
"let g:semshi#always_update_all_highlights = v:true

syntax enable
colorscheme rose-pine

"nnoremap <leader>- call deoplete#toggle()

" Deoplete
let g:deoplete#enable_at_startup = 1

call deoplete#custom#option({
\	'auto_complete_delay': 200,
\	'max_list': 12
\})

"
" vim-fuzzy
"

" don't look for mercurial
" (who uses mercurial?)
let g:fuzzy_rootcmds = [
\ ["git", "rev-parse", "--show-toplevel"],
\ ]

" always use pwd as root
function! s:fuzzy_getroot()
  return "."
endfunction

"
" AnyJump
"

let g:any_jump_references_only_for_current_filetype = 1

" these are the default keybindings for reference:

" Normal mode: Jump to definition under cursore
nnoremap <leader>j :AnyJump<CR>

" Visual mode: jump to selected text in visual mode
xnoremap <leader>j :AnyJumpVisual<CR>

" Normal mode: open previous opened file (after jump)
nnoremap <leader>ab :AnyJumpBack<CR>

" Normal mode: open last closed search window again
nnoremap <leader>al :AnyJumpLastResults<CR>

"
" Neomake
"

" TODO: get this to work
"let g:python3_host_prog='/Users/austin/.pyenv/versions/neomake/bin/python'

call neomake#configure#automake('w')

let g:neomake_python_flake8_maker = { 'args': ['--ignore=E501,W503,E203',  '--format=default'] }
let g:neomake_python_enabled_makers = ['flake8', 'mypy']

let g:black_linelength = 100
autocmd BufWritePre *.py execute ':Black'

autocmd BufWritePre Snakefile execute ':Neoformat'

"
" Misc. Plugin Config
"

nnoremap <C-p> :FuzzyOpen<CR>

nnoremap <leader>ww mz:%s/\s\+$//<cr>:let @/=''<cr>`z
