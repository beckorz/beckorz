" vim: fdm=marker

" Vundleによるプラグイン管理設定
" Vundle入手先：https://github.com/gmarik/vundle.git
" vim7.0ではneobundleが動作しないのでVundleで我慢(´･ω･｀)

" viとの互換性Off
set nocompatible
" ファイル形式の検出を無効
filetype off

" Vundleを初期化してVundle自身も管理
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

" Githubにあるプラグイン
Bundle 'motemen/git-vim'
Bundle 'mattn/zencoding-vim'
Bundle 'mikehaertl/pdv-standalone'

" vim-scriptsにあるプラグイン
Bundle 'winmanager'
Bundle 'bufexplorer.zip'
Bundle 'taglist.vim'

" Guthub以外にあるプラグイン
"Bundle 'git://git.wincent.com/command-t.git'

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

" scratch.vim用設定 {{{
let g:scratchBackupFile=$HOME . "/.vimscratch"
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

