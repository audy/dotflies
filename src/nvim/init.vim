"
" Plugins
"

call plug#begin('~/.config/.nvim/plugged')

Plug 'neomake/neomake'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'psf/black', { 'branch': 'stable' }
Plug 'cloudhead/neovim-fuzzy'
Plug 'haishanh/night-owl.vim'

call plug#end()

"
" System
"

set mouse=vin

set clipboard+=unnamedplus

nnoremap q :q<cr> " kill window with q

set autoindent
set shiftwidth=2
set softtabstop=2
set tabstop=2

"
" Appearance
"

set background=dark

function MyCustomHighlights()
  hi semshiLocal           ctermfg=209 
  hi semshiGlobal          ctermfg=214 
  hi semshiImported        ctermfg=209 cterm=bold
  hi semshiParameter       ctermfg=75  
  hi semshiParameterUnused ctermfg=117 cterm=underline
  hi semshiFree            ctermfg=218 
  hi semshiBuiltin         ctermfg=207 
  hi semshiAttribute       ctermfg=49  
  hi semshiSelf            ctermfg=249 
  hi semshiUnresolved      ctermfg=226 cterm=underline
  hi semshiSelected        ctermfg=231 ctermbg=161
  
  hi semshiErrorSign       ctermfg=231 ctermbg=160
  hi semshiErrorChar       ctermfg=231 ctermbg=160
  sign define semshiError text=E> texthl=semshiErrorSign
endfunction

autocmd FileType python call MyCustomHighlights()

set number
set relativenumber

set termguicolors
syntax enable
colorscheme night-owl

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

"
" Misc. Plugin Config
"

nnoremap <C-p> :FuzzyOpen<CR>

nnoremap <leader>ww mz:%s/\s\+$//<cr>:let @/=''<cr>`z
