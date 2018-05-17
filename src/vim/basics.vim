"
" The Very Basics
"

" load language-specific files in ~/.vim/ftpplugin/$language.vim
filetype plugin on

set nocompatible
set encoding=utf-8

" leader/local leader
let mapleader = " "
let maplocalleader = ","

syntax enable
set synmaxcol=800 " avoid syntax highlighting on large lines
set t_Co=256

set noerrorbells
set novisualbell

" disable visual bell in MacVim
autocmd! GUIEnter * set vb t_vb=


set autoindent
set shiftwidth=2
set softtabstop=2
set tabstop=2

nnoremap q :q<cr> " kill window with q

set backspace=indent,eol,start " backspace over anything

set expandtab " expand tabs to spaces
set nosmarttab " no tabs to begin with
set nowrap " dont autowrap lines

set mouse=vin

set clipboard=unnamed " use system clipboard

" use version control for version control
set autowrite
set autoread

set backup
set noswapfile

set ttyfast " I think this is turbo mode?
set number

" undo
set undodir=~/.vim/tmp/undo//     " undo files
set backupdir=~/.vim/tmp/backup// " backups
set directory=~/.vim/tmp/swap//   " swap files
set undofile
set undoreload=10000

" clean trailing whitespace
nnoremap <leader>ww mz:%s/\s\+$//<cr>:let @/=''<cr>`z

" return to same line when you reopen vim
augroup line_return
  au!
  au BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \     execute 'normal! g`"zvzz' |
    \ endif
augroup END

"
" Search
"
set incsearch " use incremental searching
set ic " base case sensitive, unless not
set smartcase " be case insensitive, or don't

" colorscheme
colorscheme hybrid

" highlight pesky invisible chars
syntax match nonascii "[^\x00-\x7F]"
highlight nonascii guibg=Red ctermbg=2

" custom file extensions
au BufNewFile,BufRead *.coffee set filetype=coffeescript
au BufNewFile,BufRead *.jbuilder set filetype=ruby
au BufNewFile,BufRead *.ts set filetype=typescript
au BufNewFile,BufRead *.go set filetype=go
au BufNewFile,BufReadPost *.md set filetype=markdown

" always use system ruby
let g:ruby_path = ['/usr/local/bin/ruby', '/usr/bin/ruby']

