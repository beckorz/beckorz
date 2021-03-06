" Vim color file
" Maintainer:   beck <beckorz@gmail.com>
" Last Change:  2007/09/26
" URL:          http://exsample.com/

set background=light
hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="emeditor"

" コメント
hi Comment		gui=NONE		guifg=DarkGreen		guibg=NONE
" 文字列
hi Constant		gui=NONE		guifg=DeepPink 		guibg=NONE
" 
hi Identifier	gui=NONE		guifg=#990000			guibg=NONE
" 通常文字
hi Statement 	gui=NONE		guifg=Blue			guibg=NONE
" 関数 function
hi PreProc		gui=bold		guifg=Blue			guibg=NONE
" 定義
hi Type			gui=bold		guifg=Black			guibg=NONE
" 
hi Special		gui=NONE		guifg=SteelBlue		guibg=NONE

"hi Underlined	
"hi Ignore		
"hi Error		
"hi Todo		
