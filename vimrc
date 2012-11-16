"
" ~/.vimrc
"

"
" PATHOGEN
"
call pathogen#infect()

"
" Clojure
"

let g:vimclojure#HighlightBuiltins = 1
let g:vimclojure#ParenRainbow = 1

"
" GENERAL
"
set list
set listchars=tab:▸\ ,eol:¬

filetype off
call pathogen#runtime_append_all_bundles()

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

set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

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
" POWERLINE
"
set laststatus=2
" let g:Powerline_symbols = 'fancy'

"
" NERDTREE
"

" show NERDtree if no files are specified
autocmd vimenter * if !argc() | NERDTree | endif 

" close NERDtree if it's the only window open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" so cursor doesn't start in NERDtree window
" autocmd VimEnter * wincmd p 

" close vim if NERDtree is only open window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
