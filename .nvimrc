" vim: set foldmethod=marker foldlevel=0:
" .nvimrc of Queyenth

if has('vim_starting')
  set all&
endif

let s:is_windows = has('win32') || has('win64')
let s:plugins=filereadable(expand("~/.nvim/autoload/plug.vim", 1))

if !s:plugins
  echo "Installing vim-plug.."
  echo ""
  silent call mkdir(expand("~/.nvim/autoload", 1), 'p')
  exe '!curl -fLo '.expand("~/.nvim/autoload/plug.vim", 1).' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
else
  call plug#begin('~/.nvim/bundle')

  " Edit
  " Surround vim objects with a pair of indetical chars
  Plug 'tpope/vim-surround'
  " Extend repetitions by the 'dot' key
  Plug 'tpope/vim-repeat'
  " Toggle comments (very useful plugin)
  Plug 'tpope/vim-commentary'
  " Reveals all the character info
  Plug 'tpope/vim-characterize'
  " Wisely add end in Ruby, endfunction in Vim
  Plug 'tpope/vim-endwise'
  " Marks admin
  Plug 'kshenoy/vim-signature'
  "
  " Snippets
  Plug 'sirver/ultisnips'
  Plug 'honza/vim-snippets'
  "
  " Browsing
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  Plug 'justinmk/vim-gtfo'
  "
  " Workflow
  Plug 'wakatime/vim-wakatime'
  Plug 'terryma/vim-multiple-cursors'
  Plug 'szw/vim-ctrlspace'
  "
  " Git
  Plug 'tpope/vim-fugitive'
  " Syntax checking
  Plug 'scrooloose/syntastic'

  " Appearance
  Plug 'bling/vim-airline'
  Plug 'mhinz/vim-startify'
  Plug 'junegunn/limelight.vim'
  Plug 'junegunn/goyo.vim'
  Plug 'godlygeek/csapprox'
  Plug 'junegunn/rainbow_parentheses.vim'
  Plug 'Yggdroot/indentLine', { 'on': 'IndentLinesEnable' }
  Plug 'gerw/vim-HiLinkTrace'
  Plug 'queyenth/oxeded.vim'

  " Langs
  " HTML/CSS/SCSS
  Plug 'othree/html5.vim', { 'for': ['html', 'xhtml', 'css'] }
  Plug 'mattn/emmet-vim', { 'for': ['html', 'xhtml', 'scss', 'xml', 'xls', 'markdown'] }
  Plug 'ap/vim-css-color', { 'for': ['html', 'xhtml', 'scss', 'xml'] }
  Plug 'cakebaker/scss-syntax.vim'
  " CoffeeScript
  Plug 'kchmck/vim-coffee-script'
  " C++
  Plug 'Valloric/YouCompleteMe'
  Plug 'octol/vim-cpp-enhanced-highlight'
  " GLSL
  Plug 'tikhomirov/vim-glsl'
  " Clojure
  Plug 'tpope/vim-fireplace'
  Plug 'tpope/vim-leiningen'
  Plug 'guns/vim-clojure-static'
  Plug 'guns/vim-clojure-highlight'
  " Rust
  Plug 'wting/rust.vim'
  call plug#end()
endif

" No to the total compatibility with the ancient vim
set nocompatible
set nolist
set virtualedit=block
set nojoinspaces
set nowrap
set shortmess=aIT
set hidden

set autoindent
set smartindent

set noerrorbells
set visualbell
set t_vb=
set tm=500
set mouse=a
set mousemodel=popup

set laststatus=2
set splitright
set splitbelow
set autochdir

" No backups, 2014, you know
set nobackup
set nowb
set noswapfile

set wildmenu
set wildmode=list:longest,full
set wildignore=*.o,*~,*.pyc,*.sw?,*.luac,*.jar,*.stats

" For additional shortcuts
let mapleader = ","
let maplocalleader = ","

" Keymap settings for changing language in vim using Ctrl+^
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0

set completeopt=menuone,menu,longest,preview
set complete=""
set complete+=.
set complete+=k
set complete+=b
set complete+=t

" Show some data about selected lines,chars
set showcmd

set number
set cursorline
set scrolljump=5
set scrolloff=5

" Set utf-8 encoding
set encoding=utf-8
set termencoding=utf-8
scriptencoding utf-8

" Default filetype - unix
set ffs=unix,dos,mac
set mousehide
set ch=1

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
set undolevels=1000
set undoreload=1000

" Lazy redraw than preprocessing macros, useful for performance
set lazyredraw

" No highlight search results (looks ugly)
set nohlsearch
set incsearch
set ignorecase smartcase

" To make backspace works, like it should works
set backspace=indent,eol,start whichwrap+=<,>,[,]

" Expand tab into spaces, and set it to 2 spaces
set expandtab smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2

set sessionoptions=resize,winpos,winsize,buffers,tabpages,folds,curdir,help

set formatoptions+=cr
set guioptions=i

set magic
set showmatch
set mat=2

" To return on current line after closing vim
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif
set viminfo^=%

au VimResized * exe "normal! \<c-w>="

autocmd! BufWritePost nvimrc source %

filetype plugin indent on

" Enabling syntax highlithing
syntax enable
set background=dark
set t_Co=256

if has("gui_running")
  set guicursor+=a:block-blinkon0
end
colorscheme oxeded

set guifont=Monaco\ 8

" Useful maping
map <C-j> <C-W>j
map <C-h> <C-W>h
map <C-k> <C-W>k
map <C-l> <C-W>l

map <A-j> gT
map <A-k> gt

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

" PLUGINS SETUP
" =======================================
"
" YouCompleteMe
" let g:ycm_server_keep_logfiles = 1
" let g:ycm_server_log_level = 'debug'

" Limelight
let g:limelight_conceal_ctermfg='DarkGray'

" Airline settings
set noshowmode
let g:airline_exclude_preview = 1
let g:airline_powerline_fonts = 1
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_theme = 'oxeded'

" CtrlSpace settings
let g:ctrlspace_use_tabline = 1

" Commentary
nmap <Leader>c <Plug>CommentaryLine
xmap <Leader>c <Plug>Commentary

" delimitMate
let delimitMate_expand_space = 1
au FileType vim let b:delimitMate_quotes = "\' "

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
