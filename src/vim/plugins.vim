"
" Time For Plugins!
"

call plug#begin('~/.vim/plugged')

Plug 'kristijanhusak/vim-carbon-now-sh'
Plug 'godlygeek/tabular'                        " Tab /=
Plug 'kien/ctrlp.vim'
Plug 'tpope/vim-surround'
Plug 'vim-python/python-syntax'
Plug 'fatih/vim-go'
Plug 'wakatime/vim-wakatime'
Plug 'faceleg/delete-surrounding-function-call.vim'
Plug 'SirVer/ultisnips'

call plug#end()

"
" Plugin Settings
"

" CtrlP
let g:UltiSnipsNoPythonWarning = 1 " silence python version warnings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*pyc
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.git|\.hg|\.svn|build|venv)$',
  \ 'file': '\v\.(exe|so|dll|png|jpeg|jpg|gif|pdf)$',
  \ }
let g:ctrlp_max_files=4096
