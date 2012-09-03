" vim: fdm=marker

" neobundleによるプラグイン管理設定
" neobundle入手先：https://github.com/Shougo/neobundle.vim

" viとの互換性Off
set nocompatible
" ファイル形式の検出を無効
filetype off

if has('vim_starting')
	" neobundleを初期化してneobundle自身も管理
	set runtimepath+=~/.vim/bundle/neobundle.vim/
	call neobundle#rc()
endif

" Githubにあるプラグイン
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'motemen/git-vim'
NeoBundle 'mattn/zencoding-vim'
NeoBundle 'mikehaertl/pdv-standalone'

" vim-scriptsにあるプラグイン
NeoBundle 'winmanager'
NeoBundle 'bufexplorer.zip'
NeoBundle 'taglist.vim'

" Github以外にあるプラグイン
"NeoBundle 'git://git.wincent.com/command-t.git'

" ファイル形式の検出、プラグイン、インデントをOnに戻す
filetype plugin indent on

" winmanager.vim用設定 {{{
map <c-w><c-t> :WMToggle<cr>
map <c-w><c-e> :FirstExplorerWindow<cr>
map <c-w><c-b> :BottomExplorerWindow<cr>
let g:winManagerWidth=40
let g:winManagerWindowLayout='FileExplorer,TagList|BufExplorer'
let g:explDateFormat='%Y-%m-%d %H:%M:%S'
let g:explHideFiles='\.swp$'
" }}}

" pdv-standalone.vim用設定 {{{
let g:pdv_cfg_Package = ''
let g:pdv_cfg_Version = '$Date$'
let g:pdv_cfg_Author = 'hoge'
let g:pdv_cfg_Copyright = 'piyo'
let g:pdv_cfg_License = ''
let g:pdv_cfg_Uses = 1
inoremap <C-D> <ESC>:call PhpDocSingle()<CR>i
nnoremap <C-D> :call PhpDocSingle()<CR>
vnoremap <C-D> :call PhpDocRange()<CR>
" }}}

" zencoding.vim用設定 {{{
let g:user_zen_settings = {
\	'lang' : 'ja',
\}
" }}}

" git.vim用設定 {{{
let g:git_no_map_default = 1
"let g:git_command_edit = 'rightbelow vnew'
nnoremap <Leader>gd :GitDiff<Enter>
nnoremap <Leader>gD :GitDiff --cached<Enter>
nnoremap <Leader>gs :GitStatus<Enter>
nnoremap <Leader>gl :GitLog<Enter>
nnoremap <Leader>gL :GitLog -u \| head -10000<Enter>
nnoremap <Leader>ga :GitAdd<Enter>
nnoremap <Leader>gA :GitAdd <cfile><Enter>
nnoremap <Leader>gc :GitCommit -v<Enter>
nnoremap <Leader>gC :GitCommit -v --amend<Enter>
nnoremap <Leader>gp :GitPullRebase<Enter>
nnoremap <Leader>gP :GitPush
nnoremap <Leader>gb :GitBlame<Enter>
" }}}
