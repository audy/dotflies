" override default shiftwidth
set shiftwidth=2

"
" Concealments & Custom Highlighting
"


highlight Conceal guifg=#ff0000 guibg=#00ff00

syntax match rPipe /\s%>%/ conceal cchar=.
highlight link rPipe Comment

