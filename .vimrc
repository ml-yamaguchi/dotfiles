" 行番号を表示する
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
au BufNewFile,BufRead *.erb set expandtab tabstop=2 shiftwidth=2 softtabstop=2

" python tab setting
au BufNewFile,BufRead *.py set expandtab tabstop=4 shiftwidth=4 softtabstop=4

" javascript tab setting
au FileType javascript set ts=4 sw=4 expandtab
au BufNewFile *.js set ft=javascript fenc=utf-8

" perl tab setting
au BufNewFile,BufRead *.pl set expandtab tabstop=4 shiftwidth=4 softtabstop=4
au BufNewFile,BufRead *.pm set expandtab tabstop=4 shiftwidth=4 softtabstop=4

" php tab setting
au BufNewFile,BufRead *.php set expandtab tabstop=2 shiftwidth=2 softtabstop=2
au BufNewFile,BufRead *.twig set expandtab tabstop=2 shiftwidth=2 softtabstop=2
au BufNewFile,BufRead *.twig setfiletype html

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

" バッファの切り替え
nnoremap <F4>       <Esc>:<C-u>bn<CR>

" 行末の不要なスペース削除
function! RTrim()
let s:cursor = getpos(".")
%s/\s\+$//e
call setpos(".", s:cursor)
endfunction

autocmd BufWritePre *.php,*.rb,*.js,*.bat call RTrim()
