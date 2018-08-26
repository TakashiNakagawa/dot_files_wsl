" reset augroup
augroup MyAutoCmd
    autocmd!
augroup END

filetype plugin indent on


let $CACHE = empty($XDG_CACHE_HOME) ? expand('$HOME/.cache') : $XDG_CACHE_HOME
let $CONFIG = empty($XDG_CONFIG_HOME) ? expand('$HOME/.config') : $XDG_CONFIG_HOME
let $DATA = empty($XDG_DATA_HOME) ? expand('$HOME/.local/share') : $XDG_DATA_HOME

" {{{ dein
let s:dein_dir = expand('$DATA/dein')

if &runtimepath !~# '/dein.vim'
    let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

    " Auto Download
    if !isdirectory(s:dein_repo_dir)
        call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
    endif

    execute 'set runtimepath^=' . s:dein_repo_dir
endif


" dein.vim settings

if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

    let s:toml_dir = expand('$CONFIG/dein')

    call dein#load_toml(s:toml_dir . '/plugins.toml', {'lazy': 0})
    call dein#load_toml(s:toml_dir . '/lazy.toml', {'lazy': 1})
    if has('python3')
        call dein#load_toml(s:toml_dir . '/python.toml', {'lazy': 0})
    endif

    call dein#end()
    call dein#save_state()
endif

if has('vim_starting') && dein#check_install()
    call dein#install()
endif
" }}}

"------------------------
 "検索関係
 "------------------------
 set ignorecase          " 大文字小文字を区別しない
 set smartcase
 set smartcase           " 検索文字に大文字がある場合は大文字小文字を区別
 set incsearch           " インクリメンタルサーチ
 set hlsearch             " 検索マッチテキストをハイライト

 " バックスラッシュやクエスチョンを状況に合わせ自動的にエスケープ
 cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
 cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'
 "
"------------------------
"編集関係
"------------------------
set shiftround          " '<'や'>'でインデントする際に'shiftwidth'の倍数に丸める
set infercase           " 補完時に大文字小文字を区別しない
" set virtualedit=all     " カーソルを文字が存在しない部分でも動けるようにする
set hidden              " バッファを閉じる代わりに隠す（Undo履歴を残すため）
set switchbuf=useopen   " 新しく開く代わりにすでに開いてあるバッファを開く
set showmatch           " 対応する括弧などをハイライト表示する
set matchtime=3         " 対応括弧のハイライト表示を3秒にする
set shiftwidth=2
set softtabstop=2
set expandtab
set cursorline          "カーソル行をハイライト
hi clear CursorLine
set noundofile
set display=lastline    "一行の文字数が多くてもきちんと描画する
set ambiwidth=double    " 全角記号を欠けないようにする
set encoding=utf-8
set fileencodings=utf-8,cp932
" set rop=type:directx,renmode:5,taamode:2
set clipboard+=unnamed

let mapleader = ","

" カーソル後の文字削除
inoremap <silent> <C-d> <Del>


 " 改行
 " EmacsのC-oと同じ動作
 nnoremap go :<C-u>call append('.', '')<CR>

 " ↑の逆バージョン
 nnoremap gO :normal! O<ESC>j

 "インデントを連続して変更
 vnoremap < <gv
 vnoremap > >gv

 " Swapファイル？Backupファイル？前時代的すぎ
 " なので全て無効化する
 set nowritebackup
 set nobackup
 set noswapfile
 set wildmenu  " コマンドライン補完を便利に
 "ビープ音すべてを無効にする
 set t_vb=
 set visualbell
 set novisualbell

 "-------------------------
 "表示関係
 "-------------------------
 set list                " 不可視文字の可視化
 set listchars=tab:>-
 set number              " 行番号の表示
 set wrap                " 長いテキストの折り返し
 set textwidth=0         " 自動的に改行が入るのを無効化
 " set colorcolumn=80      " その代わり80文字目にラインを入れる

  " ESCを二回押すことでハイライトを消す
  nmap <silent> <Esc><Esc> :nohlsearch<CR>

  " カーソル下の単語を * で検索
  vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR><CR>

  " 検索後にジャンプした際に検索単語を画面中央に持ってくる
  " nnoremap n nzz
  " nnoremap N Nzz
  " nnoremap * *zz
  " nnoremap # #zz
  " nnoremap g* g*zz
  " nnoremap g# g#zz

  " j, k による移動を折り返されたテキストでも自然に振る舞うように変更
  nnoremap j gj
  nnoremap k gk

  " vを二回で行末まで選択
  vnoremap v $h
 "
  " Ctrl + hjkl でウィンドウ間を移動
  nnoremap <C-h> <C-w>h
  nnoremap <C-j> <C-w>j
  nnoremap <C-k> <C-w>k
  nnoremap <C-l> <C-w>l


"WSLとwindowsとでクリップボードの共有をするために設定
"https://blog.himanoa.net/entries/20
if system('uname -a | grep Microsoft') != ""
  let g:clipboard = {
        \   'name': 'myClipboard',
        \   'copy': {
        \      '+': 'win32yank.exe -i',
        \      '*': 'win32yank.exe -i',
        \    },
        \   'paste': {
        \      '+': 'win32yank.exe -o',
        \      '*': 'win32yank.exe -o',
        \   },
        \   'cache_enabled': 1,
        \ }
endif

syntax on
" Theme
syntax enable
" set background=light
" colorscheme gruvbox
" highlight Visual cterm=bold ctermbg=Blue ctermfg=NONE
colorscheme tender

" terminalをESCでコマンドモードに移行
tnoremap <silent> <ESC> <C-\><C-n>
