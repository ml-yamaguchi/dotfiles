set nocompatible               " Be iMproved
 filetype off                   " Required!
 filetype plugin indent off     " Required!

if has('vim_starting')
  set runtimepath+=~/dotfiles/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
NeoBundle 'Shougo/neobundle.vim'

" Recommended to install
" After install, turn shell ~/.vim/bundle/vimproc, (n,g)make -f your_machines_makefile
NeoBundle 'Shougo/vimproc'

NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/unite.vim'

NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neocomplcache-snippets-complete'

NeoBundle 'Shougo/vimfiler'

NeoBundle 'scrooloose/nerdcommenter.git'
NeoBundle 'vim-scripts/SrcExpl'
NeoBundle 'taglist.vim'
NeoBundle 'trinity.vim'
NeoBundle 'grep.vim'

NeoBundle 'eregex.vim'

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
au FileType javascript set expandtab tabstop=4 shiftwidth=4 softtabstop=4
au BufNewFile,BufRead *.js set ft=javascript fenc=utf-8

" perl tab setting
au BufNewFile,BufRead *.pl set expandtab tabstop=4 shiftwidth=4 softtabstop=4
au BufNewFile,BufRead *.pm set expandtab tabstop=4 shiftwidth=4 softtabstop=4

" php tab setting
au BufNewFile,BufRead *.php set expandtab tabstop=2 shiftwidth=2 softtabstop=2

" php dict setting
autocmd FileType php :set dictionary+=~/.vim/dict/php_functions.dict

" 辞書ファイルを補完に使用する
set complete+=k

" phpDocumentor
inoremap ;p <ESC>:call PhpDocSingle()<CR>i
nnoremap ;p :call PhpDocSingle()<CR>
vnoremap ;p :call PhpDocRange()<CR>

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

" AutoComplPop
autocmd Filetype * let g:AutoComplPop_CompleteOption='.,w,b,u,t,i'
autocmd Filetype php let g:AutoComplPop_CompleteOption='.,w,b,u,t,i,k~/.vim/dict/php_functions.dict'



" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
	\ 'default' : '',
	\ 'vimshell' : $HOME.'/.vimshell_hist',
	\ 'php' : $HOME . '/.vim/dict/php_functions.dict',
		\ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
	let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
imap <C-k>     <Plug>(neocomplcache_snippets_expand)
smap <C-k>     <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" SuperTab like snippets behavior.
"imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()


" ポップアップメニューのカラーを設定
hi Pmenu ctermbg=0
hi PmenuSel ctermbg=4
hi PmenuSbar ctermbg=2
hi PmenuThumb ctermbg=3

" VimFiler
nnoremap <F3> :VimFiler<Cr>

" FuzzyFinder
nnoremap ;b       <Esc>:<C-u>FuzzyFinderBuffer<CR>
nnoremap ;f       <Esc>:<C-u>FuzzyFinderFile<CR>
nnoremap ;g       <Esc>:<C-u>FuzzyFinderMruFile<CR>


""" unite.vim
" 入力モードで開始する
" let g:unite_enable_start_insert=1
" バッファ一覧
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
" ファイル一覧
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" レジスタ一覧
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
nnoremap <silent> ,um :<C-u>Unite file_mru<CR>
" 常用セット
nnoremap <silent> ,uu :<C-u>Unite buffer file_mru<CR>
" 全部乗せ
nnoremap <silent> ,ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>

" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> q
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>q

"taglist
let Tlist_Ctags_Cmd = "/usr/bin/ctags"
let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window = 1

nnoremap ;tt       <Esc>:<C-u>:TrinityToggleAll<CR>

" バッファの切り替え
nnoremap <F4>       <Esc>:<C-u>bn<CR>
nnoremap <F5>       <Esc>:<C-u>bd<CR>

" NERDComments
" コメントにスペースを空ける
let NERDSpaceDelims = 1
" 未対応ファイルの警告を消す
let NERDShutUp = 1

" QuickRunPHPUnit
augroup QuickRunPHPUnit
  autocmd!
  autocmd BufWinEnter,BufNewFile *test.php set filetype=php.unit
augroup END

" 初期化
let g:quickrun_config = {}
" PHPUnit
let g:quickrun_config['php.unit'] = {'command': 'phpunit'}

let g:ref_phpmanual_path = $HOME.'/Documents/php-chunked-xhtml'

" ShowMarks
hi SignColumn ctermfg=white ctermbg=black cterm=none
hi default ShowMarksHLl ctermfg=red ctermbg=black cterm=none
hi default ShowMarksHLu ctermfg=red ctermbg=black cterm=none
hi default ShowMarksHLo ctermfg=red ctermbg=black cterm=none
hi default ShowMarksHLm ctermfg=red ctermbg=black cterm=none

let g:showmarks_include="abcdefghijkloqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

" zencoding.vim
let g:user_zen_settings = { 'indentation':'  ',
\  'php': {
\   'snippets' : {
\       'php' : "<?php | ?>",
\       'phpif' : "<?php if (|): ?>",
\       'phpendif' : "<?php endif ?>",
\       'phpforeach' : "<?php foreach (|): ?>",
\       'phpendf' : "<?php endforeach ?>",
\       'phpdump' : "<?php var_dump(|) ?>",
\       'ar' : "array(|)",
\       }
\   }
\}

"set list
"set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
highlight NonText ctermfg=darkgray
highlight SpecialKey term=underline ctermfg=darkgray guifg=darkgray

" 行末の不要なスペース削除
function! RTrim()
let s:cursor = getpos(".")
%s/\s\+$//e
call setpos(".", s:cursor)
endfunction

autocmd BufWritePre *.php,*.rb,*.js,*.bat call RTrim()

