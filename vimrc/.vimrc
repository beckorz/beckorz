source ~/.exrc
" ignore the ignorecase option if the user went to the trouble of
" entering uppercase characters.
set smartcase
" incremental search - shows what was found
set incsearch
" highlights what it found
"set hlsearch
" show status line
set laststatus=2
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
set guifontset=-*-fixed-medium-r-normal--16-*-*-*-c-*,*-r-*

" do not make backup file
set nobk
set bs=2
set autoindent
set smartindent
set shiftwidth=4
set showcmd
set tabstop=4
set nowrap
set enc=utf-8 fencs=iso-2022-jp,utf-8,euc-jp,cp932
sy on
