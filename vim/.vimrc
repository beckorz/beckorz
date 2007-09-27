" デフォルトカラー設定
colorscheme ron

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
"set bdir=.,~/tmp,~/

" バックアップファイルの拡張子(backupext)
set bex=.backup

" ファイルブラウザにどのディレクトリを使うかを指定する(Windows版等のGUI用)(browsedir)
set bsdir=buffer

" コマンドラインに使われるスクリーン上の行数(cmdheight)
"set ch=2

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

" 行番号を表示する(number)
" set nu

" ペースト時に一時的にautoindent等を無効にするペーストモードの切替キー(pastetoggle)
set pt=<F11>

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
"set sb

" ウィンドウの縦分割で新しいウィンドウをカレントウィンドウの右に開く(splitright)
set spr

" ステータス行の表示内容を設定する(statusline)
set stl=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P

" 強調表示(色付け)のON/OFF設定(syntax)
sy on

" ファイル内の <Tab> が対応する空白の数(tabstop)
set ts=4

" ウィンドウの幅を超える行の折り返し設定
set nowrap

" 文字コードの自動認識
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
		let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
		let &fileencodings = &fileencodings .','. s:fileencodings_default
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

"---------------------------------------------------------------------------
"	OS依存での設定
"---------------------------------------------------------------------------
if has('win32')
  " Windows用
  set guifont=MS_Gothic:h10:cSHIFTJIS
  "set guifont=MS_Mincho:h12:cSHIFTJIS
  " 行間隔の設定
  set linespace=1
  " 一部のUCS文字の幅を自動計測して決める
  if has('kaoriya')
    set ambiwidth=auto
  endif
elseif has('mac')
  " Mac用
  set guifont=Osaka－等幅:h14
elseif has('xfontset')
  " UNIX用 (xfontsetを使用)
  set guifontset=a14,r14,k14
endif
