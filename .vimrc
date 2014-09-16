" No to the total compatibility with the ancient vi
set nocompatible

" Auto installing NeoBundle
let iCanHazNeoBundle=1
let neobundle_readme=expand($HOME.'/.vim/bundle/neobundle.vim/README.md')
if !filereadable(neobundle_readme)
  echo "Installing NeoBundle.."
  echo ""
  silent !mkdir -p $HOME/.vim/bundle
  silent !git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
  let iCanHazNeoBundle=0
endif

" Call NeoBundle
if has('vim_starting')
  set rtp+=$HOME/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand($HOME.'/.vim/bundle'))

" Is better if NeoBundle rules NeoBundle (lol?!)
NeoBundleFetch 'Shougo/neobundle.vim'

" So, Bundles here
NeoBundle 'Shougo/vimproc.vim', {
  \ 'build' : {
  \   'windows' : 'make -f make_mingw32.mak',
  \   'cygwin' : 'make -f make_cygwin.mak',
  \   'mac' : 'make -f make_mac.mak',
  \   'unix' : 'make -f make_unix.mak',
  \ },
\ }

" HTML/CSS
NeoBundleLazy 'othree/html5.vim', {'autoload':
      \ {'filetypes': ['html', 'xhtml', 'css']}}

NeoBundleLazy 'mattn/emmet-vim', {'autoload':
      \ {'filetypes': ['html', 'xhtml', 'css', 'xml', 'xls', 'markdown']}}

" NerdTree
NeoBundle 'scrooloose/nerdtree'

NeoBundle 'ap/vim-css-color'
NeoBundle 'terryma/vim-multiple-cursors'

" Admin Git
NeoBundle 'tpope/vim-fugitive'
" Git viewer
NeoBundleLazy 'gregsexton/gitv', {'depends':['tpope/vim-fugitive'], 'autoload':{'commands': 'Gitv'}}

" Show indent lines
NeoBundleLazy 'Yggdroot/indentLine', {'autoload': {'filetypes': ['python']}}

" Powerful and advanced Snippets tool
NeoBundle 'sirver/ultisnips'
NeoBundle 'ervandew/supertab'
NeoBundle 'garbas/vim-snipmate'
" Snippets for Ultisnips
NeoBundle 'honza/vim-snippets'

NeoBundle 'Valloric/YouCompleteMe'

" Syntax checking
NeoBundle 'scrooloose/syntastic'

" Clojure
NeoBundle 'tpope/vim-fireplace'
NeoBundle 'tpope/vim-leiningen'
NeoBundle 'guns/vim-clojure-static'
NeoBundle 'guns/vim-clojure-highlight'

" Text edition {
" Autocompletion of (, [, {, ', ", ...
NeoBundle 'Raimondi/delimitMate'
" Surround vim objects with a pair of indetical chars
NeoBundle 'tpope/vim-surround'
" Extend repetitions by the 'dot' key
NeoBundle 'tpope/vim-repeat'
" Toggle comments (very useful plugin)
NeoBundle 'tpope/vim-commentary'
" Reveals all the character info
NeoBundle 'tpope/vim-characterize'
" Marks admin
NeoBundle 'kshenoy/vim-signature'

NeoBundle 'flazz/vim-colorschemes'
" }

" A better looking status line
NeoBundle 'bling/vim-airline'

" Additional bundles
NeoBundle 'MarcWeber/vim-addon-mw-utils'
NeoBundle 'tomtom/tlib_vim'
NeoBundle 'octol/vim-cpp-enhanced-highlight'
NeoBundle 'mhinz/vim-startify'
NeoBundle 'tikhomirov/vim-glsl'

if iCanHazNeoBundle == 0
  echo "Installing Bundles, please ignore key map error message"
  echo ""
  :NeoBundleInstall
endif

call neobundle#end()

NeoBundleCheck

filetype plugin indent on

" For additional shortcuts
let mapleader = ","
let maplocalleader = ","

" Keymap settings for changing language in vim using Ctrl+^
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
set completeopt=menuone,menu,longest,preview

" Always show ruler
set ruler
set showcmd

" Show lines numbers
set nu
set incsearch
set scrolljump=7
set scrolloff=7

" Disabling annoying vim beep-beep
set novisualbell
set t_vb=
set tm=500
set mouse=a
set mousemodel=popup

" Set utf-8 encoding
set encoding=utf-8
set termencoding=utf-8
scriptencoding utf-8
set ls=2
set go-=T
set go-=m
set go-=rRlLbh

" Default filetype - unix
set ffs=unix,dos,mac
set hidden
set ch=1
set mousehide
set cursorline

" Better screen redraw
set ttyfast
" Set terminal title to the current file
set title
" Update a open file edited outside of Vim
set autoread
" Toggle between modes almost instantly
set ttimeoutlen=0

set history=1000
set undofile
set undodir=~/.vim/tmp/undo/
set undoreload=1000

" Lazy redraw than preprocessing macros, useful for performance
set lazyredraw

" No highlight search results (looks ugly)
set nohlsearch

" Magic - on
set magic
set showmatch
set mat=2

" To make backspace works, like it should works
set backspace=indent,eol,start whichwrap+=<,>,[,]

" Expand tab into spaces, and set it to 2 spaces
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2

set statusline=\ %F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

" Nice indent :3
set autoindent
set smartindent

set fo+=cr
set sessionoptions=resize,winpos,winsize,buffers,tabpages,folds,curdir,help

" Useful maping
map <C-j> <C-W>j
map <C-h> <C-W>h
map <C-k> <C-W>k
map <C-l> <C-W>l

" To return on current line after closing vim
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif
set viminfo^=%

vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

map <leader>tn :tabnew<cr>
map <leader>tc :tabclose<cr>
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Split windows
nnoremap <Leader>v <C-w>v
nnoremap <Leader>h <C-w>s

" Cut/Paster to/from the clipboard
map <Leader>y "*y
map <Leader>p "*p
map <Leader>P :set invpaste<CR>

command! ToggleQuickfix call <SID>QuickfixToggle()
nnoremap <silent> <Leader>q :ToggleQuickfix<CR>

autocmd! BufWritePost vimrc source %

set complete=""
set complete+=.
set complete+=k
set complete+=b
set complete+=t

" Enabling syntax highlithing
syntax enable
set background=dark
set t_Co=256

if has("gui_running")
  set guicursor+=a:block-blinkon0
end
colorscheme molokai

au VimResized * exe "normal! \<c-w>="

" No backups, 2014, you know
set nobackup
set nowb
set noswapfile

set guifont=Meslo\ LG\ M\ for\ Powerline\ 8

set wildmenu
set wildmode=list:longest,full
set wildignore=*.o,*~,*.pyc,*.sw?,*.luac,*.jar,*.stats

" PLUGINS SETUP
" =======================================
" Airline settings
set noshowmode
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_enable_branch=1
let g:airline_enable_syntatic=1
let g:airline_detect_paste=1
let g:airline_linecolumn_prefix ='¶'
let g:airline_paste_symbol = 'ρ'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='molokai'

" Commentary
nmap <Leader>c <Plug>CommentaryLine
xmap <Leader>c <Plug>Commentary

" delimitMate
let delimitMate_expand_space = 1

" Fugitive
nnoremap <Leader>gn :Git! init<CR>
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gw :Gwrite<CR>
nnoremap <Leader>go :Gread<CR>
nnoremap <Leader>gR :Gremove<CR>
nnoremap <Leader>gm :Gmove<CR>
nnoremap <Leader>gc :Gcommit<CR>
nnoremap <Leader>gd :Gdiff<CR>
nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>gB :Gbrowse<CR>
nnoremap <Leader>gp :Git! push<CR>
nnoremap <Leader>gP :Git! pull<CR>
nnoremap <Leader>gi :Git!<space>
nnoremap <Leader>ge :Gedit<CR>
nnoremap <Leader>gE :Gedit<space>
nnoremap <Leader>gl :exe quickfix"<CR>:redraw!<CR>
nnoremap <Leader>gL :exe quickfix"<CR>:redraw!<CR>
nnoremap <Leader>gt :!tig<CR>:redraw!<CR>
nnoremap <Leader>gS :exe "silent !shipit"<CR>:redraw!<CR>
nnoremap <Leader>gg :exe 'silent Ggrep -i '.input("Pattern: ").<Bar>Unite quickfix -no-quit<CR>
nnoremap <Leader>ggm :exe 'silent Glog --grep='.input("Pattern: ")' <Bar> Unite -no-quit quickfix'<CR>
nnoremap <Leader>ggt :exe 'solent Glog -S='.input("Pattern: ").' <Bar> Unite -no-quit quickfix'<CR>
nnoremap <Leader>ggc :silent! Ggrep -i<Space>

noremap <Leader>du :diffupdate<CR>
if !exists(":Gdiffoff")
  command Gdiffoff diffoff | q | Gedit
endif
noremap <Leader>dq :Gdiffoff<CR>

" Gitv
nnoremap <silent> <leader>gv :Gitv --all<CR>
nnoremap <silent> <leader>gV :Gitv! --all<CR>
vnoremap <silent> <leader>gV :Gitv! --all<CR>

let g:Gitv_OpenHorizontal = 'auto'
let g:Gitv_WipeAllOnClose = 1
let g:Gitv_DoNotMapCtrlKey = 1

autocmd FileType git set nofoldenable

" indentLine
map <silent> <Leader>L :IndentLinesToggle<CR>
let g:indentLine_enabled = 0
let g:indentLine_char = '|'
let g:indentLine_color_term = 239

" Syntastic
nmap <silent><Leader>N :SyntasticCheck<CR>:Errors<CR>
let g:syntastic_python_pyline_exe="pylint2"
let g:syntastic_mode_map = {'mode': 'active', 'active_filetypes': [], 'passive_filetypes': ['python']}
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_style_error_symbol = '⚡'
let g:syntastic_style_warning_symbol = '⚡'

" }} END PLUGIN SETUP
"
" {{ FILETYPES

" PYTHON
au FileType python setlocal foldlevel=1000

" ===============================================
" Helper functions
function! VisualSelection(direction) range
  let l:saved_reg = @"
  execute "normal! vgvy"
  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")
  if a:direction == 'b'
    execute "normal ?" . l:pattern . "^M"
  elseif a:direction == 'f'
    execute "normal /" . l:pattern . "^M"
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

function! MakeDirIfNoExists(path)
  if !isdirectory(expand(a:path))
    call mkdir(expand(a:path), "p")
  endif
endfunction

function! ToggleWrap()
  let s:nowrap_cc_bg = [22, "#005f00"]
  redir => s:curr_cc_hi
  silent hi ColorColumn
  redir END
  let s:curr_cc_ctermbg = matchstr(s:curr_cc_hi, 'ctermbg=\zs.\{-}\s\ze\1')
  let s:curr_cc_guibg = matchstr(s:curr_cc_hi, 'guibg=\zs.\{-}\_$\ze\1')
  if s:curr_cc_ctermbg != s:nowrap_cc_bg[0]
    let g:curr_cc_guibg = s:curr_cc_guibg
  endif
  if &textwidth == 80
    set textwidth=0
    exec 'hi ColorColumn ctermbg='.s:nowrap_cc_bg[0].' guibg='.s:nowrap_cc_bg[1]
  elseif &textwidth == 0
    set textwidth=80
    exec 'hi ColorColumn ctermbg='.g:curr_cc_ctermbg.' guibg='.g:curr_cc_guibg
  endif
endfunction
