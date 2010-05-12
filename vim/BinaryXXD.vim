" バイナリ編集(xxd)モード (vim -bでの起動で発動)
augroup BinaryXXD
	autocmd!
"	拡張子で自動有効にする場合はコメント解除
"	autocmd BufReadPre *.bin let &binary=1
	autocmd BufReadPost * if &binary | silent %!xxd -g 1
	autocmd BufReadPost * set ft=xxd | endif
	autocmd BufWritePre * if &binary | %!xxd -r | endif
	autocmd BufWritePost * if &binary | silent %!xxd -g 1
	autocmd BufWritePost * set nomod | endif
augroup END
