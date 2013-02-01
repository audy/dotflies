"
" ~/.vimrc
"


"
" Clojure
"

let g:vimclojure#HighlightBuiltins = 1
let g:vimclojure#ParenRainbow = 1

"
" GENERAL
"

set list
set listchars=tab:▸\ ,eol:¬,trail:·

" make uses real tabs
au FileType make set no expandtab

filetype off


filetype plugin indent on
syntax on
colorscheme mustang

set mouse=vin
set autoread
set rnu
set showmatch
set ttyfast
set lazyredraw

set backspace=eol,indent,start
set smartindent
set smarttab
set nowrap
set autoindent

" default tab settings are for Ruby
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

" tab settings for Python
au FileType python set tabstop=8 shiftwidth=4 softtabstop=4

" use global clipboard


"
" MAPPINGS
"
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" sane up and down
nnoremap j gj
nnoremap k gk

"
" PATHOGEN
"

call pathogen#infect()
call pathogen#runtime_append_all_bundles()
"
" POWERLINE
"
set laststatus=2
" let g:Powerline_symbols = 'fancy'

"
" NERDTREE
"

let NERDTreeIgnore=['\.rbc$', '\.pyc$', '\~$']

" show NERDtree if no files are specified
autocmd vimenter * if !argc() | NERDTree | endif 

" close NERDtree if it's the only window open
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" so cursor doesn't start in NERDtree window
" autocmd VimEnter * wincmd p 

" close vim if NERDtree is only open window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup
