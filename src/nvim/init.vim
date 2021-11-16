"
" Plugins
"

" to setup virtualenv environment:
" pipx install neovim pynvim black flake8 mypy isort
let g:python3_host_prog='/Users/austin.richardson/.pyenv/versions/neovim/bin/python'

call plug#begin('~/.config/.nvim/plugged')

Plug 'neomake/neomake'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'psf/black', { 'branch': 'stable' }
Plug 'cloudhead/neovim-fuzzy'
Plug 'haishanh/night-owl.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'pechorin/any-jump.vim'
Plug 'zah/nim.vim'
Plug 'ianks/vim-tsx'
Plug 'sbdchd/neoformat'
Plug 'snakemake/snakemake', {'rtp': 'misc/vim'}
Plug 'cespare/vim-toml'
Plug 'SirVer/ultisnips'

call plug#end()

" stop snakemake plugin from folding everything by default 😖
set foldlevelstart=99
set foldlevel=99

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
set termguicolors


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

"function MyCustomHighlights()
"  hi semshiLocal           ctermfg=209 
"  hi semshiGlobal          ctermfg=214 
"  hi semshiImported        ctermfg=209 cterm=bold
"  hi semshiParameter       ctermfg=75  
"  hi semshiParameterUnused ctermfg=117 cterm=underline
"  hi semshiFree            ctermfg=218 
"  hi semshiBuiltin         ctermfg=207 
"  hi semshiAttribute       ctermfg=49  
"  hi semshiSelf            ctermfg=249 
"  hi semshiUnresolved      ctermfg=226 cterm=underline
"  hi semshiSelected        ctermfg=231 ctermbg=161
"  
"  hi semshiErrorSign       ctermfg=231 ctermbg=160
"  hi semshiErrorChar       ctermfg=231 ctermbg=160
"  sign define semshiError text=E> texthl=semshiErrorSign
"endfunction

" Disable highlighting of builtins (list, len, etc.) by Vim's own Python
" syntax highlighter, because that's Semshi's job. If you turn it off, Vim may
" add incorrect highlights.
"let g:semshi#no_default_buildin_highlight = v:true

" Update all visible highlights for every change. (Semshi tries to detect
" small changes and update only changed highlights. This can lead to some
" missing highlights. Turn this on for more reliable highlighting, but a small
" additional overhead.)
let g:semshi#always_update_all_highlights = v:true


syntax enable
colorscheme night-owl

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
