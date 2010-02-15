" ファイル先頭数行以内に「encoding: xxx」のキーワードが見つかったら
" xxxの文字コードで自動再読込するスクリプト
"
" 「~/.vimrc/RereadWithEncoding.vim」で保存して.vimrcに「ru RereadWithEncoding.vim」とするか
" 直接.vimrcに書き込めば使えます。
augroup RereadWithEncoding
	au!
	au BufReadPost * call s:RereadWithEncoding()
augroup END

function! s:RereadWithEncoding()
	" 先頭からキーワード検索
	let enc = s:DetectEncoding(1, &mls)
	if enc == ''
		" 末尾からキーワード検索
		let enc = s:DetectEncoding(line('$') - &mls, line('$'))
	endif
	" 再読込
	if enc != ''
		exe 'e ++enc=' . enc
		if has('syntax')
			sy on
		endif
	endif
endfunction

function! s:DetectEncoding(first, last)
	let enc = ''
	for i in range(a:first, a:last)
		let enc = matchstr(getline(i), 'encoding:\s*\zs\S\+\ze')
		if enc != ''
			break
		endif
	endfor
	return enc
endfunction
