" vim: fdm=marker

" 分割設定ファイルの読み込み
if filereadable(expand('~/.vim/vundle.vim'))
	source ~/.vim/vundle.vim
endif
"if filereadable(expand('~/.vim/neobundle.vim'))
"	source ~/.vim/neobundle.vim
"endif

" 新しい行を開始したときに、新しい行のインデントを現在行と同じ量にする(autoindent)
set ai

" 外部のエディタで編集中のファイルが変更されたら、自動的に読み直す(autoread)
set ar

" 挿入モード時に<BS>で改行をこえて削除可能とする(backspace)
set bs=indent,eol,start

" ファイルを上書きする前にバックアップファイルを作る(backup)
"set bk

" バックアップファイルの作成方法を決定する(backupcopy)
"set bkc=no

" バックアップファイルを作るディレクトリを設定する(backupdir)
set bdir=.,~/tmp,~/

" バックアップファイルの拡張子(backupext)
"set bex=.backup
au BufWritePre * let &bex = '.' . strftime("%Y%m%d%H%M%S")

" ファイルブラウザにどのディレクトリを使うかを指定する(Windows版等のGUI用)(browsedir)
set bsdir=buffer

" コマンドラインに使われるスクリーン上の行数(cmdheight)
"set ch=2

" Diffモード用のオプション設定(diffopt)
"set dip=filler,vertical

" Vimの通常使う文字エンコーディング(encoding)
"set enc=utf-8

" ウィンドウ分割時にサイズを初期化しない(equalalways)
set noea

" Insertモードで: <Tab> を挿入するのに、適切な数の空白を使う(expandtab)
"set et

" カレントバッファ内のファイルの文字エンコーディングを設定する(fileencoding)
"set fenc=utf-8

" Vimが表示できる文字エンコーディングのリスト(fileencodings)
"set fencs=iso-2022-jp,cp932,euc-jp,ucs-bom,utf-8

" 改行コードの指定(fileformat)
"set ff=dos

" 保存しないで他のファイルを表示することが出来るようにする(hidden)
"set hid

" 検索結果をハイライトする(hlsearch)
set hls

" 検索で、大文字小文字を区別しない(ignorecase)
set ic

" インクリメンタルサーチを行う(incsearch)
set is

" ステータスラインを表示するウィンドウを設定する(laststatus)
set ls=2

" タブ文字、行末など不可視文字を表示する
" set list

" listで表示される文字のフォーマットを指定する(listchars)
set lcs=tab:>-,eol:$,extends:>

" モードラインの有効無効(modeline)
set ml

" マウスを有効にするモードを設定する(mouse)
set mouse=a

" Ctrl+A、Ctrl+Xの加減算コマンドで認識する基数(nrformats)
set nf=alpha,hex

" 行番号を表示する(number)
" set nu

" 最も古いバージョンのバックアップだけ保管されるようにする(patchmode)
"set pm=.orig

" ペースト時に一時的にautoindent等を無効にするペーストモードの切替キー(pastetoggle)
set pt=<F11>

" オムニ補完を有効にする(omnifunc) なぜかftpluginに書かれてない？
autocmd FileType php setlocal ofu=phpcomplete#CompletePHP
"let php_sql_query=1
"let php_htmlInStrings=1
"let php_folding=1
"autocmd Syntax php set fdm=syntax

" 自動インデントの各段階に使われる空白の数(shiftwidth)
set sw=4

" コマンドをステータスラインに表示する(showcmd)
set sc

" 閉じ括弧が入力されたとき、対応する括弧を表示する(showmatch)
set sm

" 現在のモードを表示する(showmode)
set smd

" 検索で小文字なら大文字を無視、大文字なら無視しない設定(smartcase)
set scs

" 新しい行を作ったときに高度な自動インデントを行う(smartindent)
set si

" ウィンドウの横分割で新しいウィンドウをカレントウィンドウの下に開く(splitbelow)
set sb

" ウィンドウの縦分割で新しいウィンドウをカレントウィンドウの右に開く(splitright)
set spr

" ステータス行の表示内容を設定する(statusline)
set stl=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P

" ファイル内の <Tab> が対応する空白の数(tabstop)
set ts=4

" ターミナルでマウスを使う設定(ttymouse)
set ttym=xterm2

" viminfoファイルの設定(viminfo)
set vi='20,<50,h

" ウィンドウの幅を超える行の折り返し設定
set nowrap

" ファイルの末尾まで検索したら先頭にループする(wrapscan)
set nowrapscan

" ファイル形式別プラグインの有効化
filetype plugin on

" 強調表示(色付け)のON/OFF設定(syntax)
sy on

" 文字コードの自動認識 {{{
if &encoding !=# 'utf-8'
	set encoding=japan
	set fileencoding=japan
endif
if has('iconv')
	let s:enc_euc = 'euc-jp'
	let s:enc_jis = 'iso-2022-jp'
	" iconvがeucJP-msに対応しているかをチェック
	if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'eucjp-ms'
		let s:enc_jis = 'iso-2022-jp-3'
	" iconvがJISX0213に対応しているかをチェック
	elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'euc-jisx0213'
		let s:enc_jis = 'iso-2022-jp-3'
	endif
	" fileencodingsを構築
	if &encoding ==# 'utf-8'
		let s:fileencodings_default = &fileencodings
		let &fileencodings = s:enc_jis .','. s:enc_euc
		if s:fileencodings_default =~ 'utf-8'
			let &fileencodings = &fileencodings .','. s:fileencodings_default
			let &fileencodings = substitute(&fileencodings, "utf-8", "utf-8,cp932", "g")
		else
			let &fileencodings = &fileencodings .',cp932,'.  s:fileencodings_default
		endif
		unlet s:fileencodings_default
	else
		let &fileencodings = &fileencodings .','. s:enc_jis
		set fileencodings+=utf-8,ucs-2le,ucs-2
		if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
			set fileencodings+=cp932
			set fileencodings-=euc-jp
			set fileencodings-=euc-jisx0213
			set fileencodings-=eucjp-ms
			let &encoding = s:enc_euc
			let &fileencoding = s:enc_euc
		else
			let &fileencodings = &fileencodings .','. s:enc_euc
		endif
	endif
	" 定数を処分
	unlet s:enc_euc
	unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
	function! AU_ReCheck_FENC()
		if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
			let &fileencoding=&encoding
		endif
	endfunction
	autocmd BufReadPost * call AU_ReCheck_FENC()
endif

" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
	set ambiwidth=double
endif

" 文字化けした場合に開き直すためのキー割り当て
nnoremap <Leader>fe :e ++enc=eucjp-ms<CR>
nnoremap <Leader>fs :e ++enc=cp932<CR>
nnoremap <Leader>fu :e ++enc=utf-8<CR>
" }}}

" 括弧自動補完(好みで有効にする) {{{
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
"inoremap " ""<LEFT>
"inoremap ' ''<LEFT>
vnoremap { "zdi{<C-R>z}<ESC>
vnoremap [ "zdi[<C-R>z]<ESC>
vnoremap ( "zdi(<C-R>z)<ESC>
"vnoremap " "zdi"<C-R>z"<ESC>
"vnoremap ' "zdi'<C-R>z'<ESC>
" }}}

" 全角空白をハイライト(好みで有効にする) {{{
if &background ==# 'dark'
	hi WideSpace ctermbg=DarkCyan
else
	hi WideSpace ctermbg=Cyan
endif
match WideSpace /　/
" }}}

" vimウィンドウ内でmanページ表示 {{{
ru ftplugin/man.vim
" }}}

"---------------------------------------------------------------------------
" ronベースのオレオレ仕様 ronのファイルに以下を適用しても良し
" 通常文字
hi Normal		guifg=white	guibg=black
hi statement	guifg=white	gui=NONE
" 文字列
hi constant		guifg=magenta	gui=none
" 
hi preproc		guifg=red
" 検索文字列の背景色
hi Search		guibg=yellow
" 特殊キー
hi SpecialKey guibg=NONE guifg=Gray20
hi type			guifg=lightblue	gui=NONE

" 入力モードの自動的に日本語入力を使わない
set iminsert=0
" 検索時自動的に日本語入力を使わない
set imsearch=-1
