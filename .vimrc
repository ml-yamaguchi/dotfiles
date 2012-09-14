if version >= 702
  " プラグイン管理設定を読み込む
  source ~/.vimrc.bundle
endif

set number
set incsearch
set ignorecase
set smartcase
set nohlsearch
set showmatch
set showmode
set backspace=1
set title
set ruler
" モードラインを有効にする(ファイルごとのエディタの設定を読み込む)
set modeline
" タグファイルを使う
set tags=tags
"
" タグを戻るのキーバインドを;tに変更
nnoremap ;t :pop<CR>
nnoremap ;t :pop<CR>

syntax on
filetype on
filetype indent on
filetype plugin on

" default tab setting
" <Tab>を何文字分に展開するか指定
au BufNewFile,BufRead * set tabstop=4
" vimが自動挿入するインデントの文字数
au BufNewFile,BufRead * set shiftwidth=4
" キーボードで<Tab>キーを押した時に挿入される空白の量
au BufNewFile,BufRead * set softtabstop=0

" ruby tab setting
au BufNewFile,BufRead *.rhtml set expandtab tabstop=2 shiftwidth=2 softtabstop=2
au BufNewFile,BufRead *.rb set expandtab tabstop=2 shiftwidth=2 softtabstop=2
au BufNewFile,BufRead *.yml set expandtab tabstop=2 shiftwidth=2 softtabstop=2
au BufNewFile,BufRead *.html.erb set expandtab tabstop=2 shiftwidth=2 softtabstop=2

" python tab setting
au BufNewFile,BufRead *.py set expandtab tabstop=4 shiftwidth=4 softtabstop=4

" javascript tab setting
au FileType javascript set expandtab tabstop=2 shiftwidth=2 softtabstop=2
au BufNewFile,BufRead *.js set ft=javascript fenc=utf-8
au BufNewFile,BufRead *.json set ft=javascript fenc=utf-8

" perl tab setting
au BufNewFile,BufRead *.pl set expandtab tabstop=4 shiftwidth=4 softtabstop=4
au BufNewFile,BufRead *.pm set expandtab tabstop=4 shiftwidth=4 softtabstop=4

" php tab setting
au BufNewFile,BufRead *.php set expandtab tabstop=2 shiftwidth=2 softtabstop=2 filetype=php

" php dict setting
" autocmd FileType php :set dictionary+=~/.vim/dict/php_functions.dict

" 辞書ファイルを補完に使用する
set complete+=k


" ステータスウインドウの表示
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
set wrap
set laststatus=2
set cmdheight=2

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

" 不可視文字を表示する
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
highlight NonText ctermfg=darkgray
highlight SpecialKey term=underline ctermfg=darkgray guifg=darkgray

" 行末の不要なスペース削除
function! RTrim()
let s:cursor = getpos(".")
%s/\s\+$//e
call setpos(".", s:cursor)
endfunction

autocmd BufWritePre * call RTrim()

" 最後の編集位置にカーソルを自動的に移動させる
autocmd BufReadPost * if line ("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

if version >= 702
  " プラグインの設定を読み込む
  source ~/.vimrc.plugin_setting
endif

" 挿入モード時、ステータスラインの色を変更
"
" このファイルの内容をそのまま.vimrc等に追加するか、
" pluginフォルダへこのファイルをコピーします。

" 挿入モード時の色指定
if !exists('g:hi_insert')
  let g:hi_insert = 'highlight StatusLine guifg=blue guibg=gray gui=none ctermfg=gray ctermbg=cyan cterm=none'
endif

" Linux等でESC後にすぐ反映されない場合、次行以降のコメントを解除してください
"if has('unix') && !has('gui_running')
  " ESC後にすぐ反映されない場合
"  inoremap <silent> <ESC> <ESC>
"  inoremap <silent> <C-[> <ESC>
"endif

if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:StatusLine('Enter')
    autocmd InsertLeave * call s:StatusLine('Leave')
  augroup END
endif

let s:slhlcmd = ''
function! s:StatusLine(mode)
  if a:mode == 'Enter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
    silent exec g:hi_insert
  else
    highlight clear StatusLine
    silent exec s:slhlcmd
  endif
endfunction

function! s:GetHighlight(hi)
  redir => hl
  exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction

