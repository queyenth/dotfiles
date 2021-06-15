" vim: set foldmethod=marker foldlevel=0:

let s:plugins=filereadable(expand("~/.config/nvim/autoload/plug.vim", 1))

if !s:plugins
  echo "Installing vim-plug.."
  echo ""
  silent call mkdir(expand("~/.config/nvim/autoload", 1), 'p')
  exe '!curl -fLo '.expand("~/.config/nvim/autoload/plug.vim", 1).' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
else
  call plug#begin('~/.config/nvim/bundle')

  " Edit
  " Surround vim objects with a pair of indetical chars
  Plug 'tpope/vim-surround'
  " Extend repetitions by the 'dot' key
  Plug 'tpope/vim-repeat'
  " Toggle comments (very useful plugin)
  Plug 'tpope/vim-commentary'
  " Marks admin
  Plug 'kshenoy/vim-signature'

  " Workflow
  Plug 'airblade/vim-rooter'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() }}
  Plug 'junegunn/fzf.vim'

  " Tmux
  Plug 'christoomey/vim-tmux-navigator'

  " Git
  Plug 'tpope/vim-fugitive'
  Plug 'mhinz/vim-signify'
  " Syntax checking
  Plug 'scrooloose/syntastic'

  " Appearance
  Plug 'bling/vim-airline'
  Plug 'dawikur/base16-vim-airline-themes'
  Plug 'morhetz/gruvbox'
  Plug 'queyenth/oxeded.vim'
  Plug 'chriskempson/base16-vim'

  " Langs
  " COC
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  " HTML/CSS/SCSS
  Plug 'ap/vim-css-color', { 'for': ['html', 'xhtml', 'scss', 'xml'] }
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
" Better display for messages
set cmdheight=2

set updatetime=300

set shortmess+=c

set signcolumn=yes

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
set undodir=~/.config/nvim/tmp/undo/
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

" Expand tab into spaces, and set it to 4 spaces
set expandtab smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=4

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

autocmd GUIEnter * set vb t_vb= " for your GUI
autocmd VimEnter * set vb t_vb=

autocmd CursorHold * silent call CocActionAsync('highlight')

au VimResized * exe "normal! \<c-w>="

filetype plugin indent on

" Enabling syntax highlithing
syntax enable
set background=dark
set t_Co=256

set termguicolors
let base16colorspace=256
colorscheme base16-gruvbox-light-medium
if has("gui_running")
  set guifont=Hack:h11
  set guicursor+=a:block-blinkon0
end


" Useful maping
" map <C-j> <C-W>j
" map <C-h> <C-W>h
" map <C-k> <C-W>k
" map <C-l> <C-W>l

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

" NETRW
let g:netrw_liststyle = 3

" PLUGINS SETUP
" =======================================

" Airline settings
set noshowmode
let g:airline_exclude_preview = 1
let g:airline_powerline_fonts = 1

" Commentary
nmap <Leader>c <Plug>CommentaryLine
xmap <Leader>c <Plug>Commentary

" Syntastic
nmap <silent><Leader>N :SyntasticCheck<CR>:Errors<CR>
let g:syntastic_python_pyline_exe="pylint2"
let g:syntastic_mode_map = {'mode': 'active', 'active_filetypes': [], 'passive_filetypes': ['python']}
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_style_error_symbol = '⚡'
let g:syntastic_style_warning_symbol = '⚡'

" FZF
map <C-p> :Files<CR>
map <C-space> :Buffers<CR>
let g:fzf_layout = { 'down': '~40%' }

" Signify
let g:signify_sign_change = '•'
let g:signify_sign_add = '❖'

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

inoremap <silent><expr> <c-space> coc#refresh()

inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~# '\s'
endfunction

" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <leader>rn <Plug>(coc-rename)

xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)

augroup mygroup
    autocmd!
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

xmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>a <Plug>(coc-codeaction-selected)

nmap <leader>ac <Plug>(coc-codeaction)
nmap <leader>qf <Plug>(coc-fix-current)

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction

" Language server!
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold :call CocAction('fold', <f-args>)
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

nnoremap <silent> <space>a :<C-u>CocList diagnostics<cr>
nnoremap <silent> <space>e :<C-u>CocList extensions<cr>
nnoremap <silent> <space>c :<C-u>CocList commands<cr>
nnoremap <silent> <space>o :<C-u>CocList outline<cr>
nnoremap <silent> <space>s :<C-u>CocList -I symbols<cr>
nnoremap <silent> <space>j :<C-u>CocNext<CR>
nnoremap <silent> <space>k :<C-u>CocPrev<CR>
nnoremap <silent> <space>p :<C-u>CocListResume<CR>

function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun
