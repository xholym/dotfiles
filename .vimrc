set nocompatible
set encoding=utf-8

syntax on

set number		    " make current line number not relative
set relativenumber	" enable relative line numbers

set noerrorbells   	" disable ring on error

" Indentation
set autoindent      " enable indetation
set smartindent	    " try to indent for me
set tabstop=4	    " make tab 4 spaces
set softtabstop=4   " make soft tab 4 spaces
set shiftwidth=4    " also make 4 spaces
set expandtab       " convert tabs to spaces

set nowrap		   	" don't wrap lines
let &showbreak = '> '   " show this string wrapped line
set linebreak textwidth=0 wrapmargin=0 " don't automatically insert line breaks at 80 column, does not work.
set ignorecase      " ignore case by default
set smartcase       " do not ignore case when uppercase is typed
set incsearch       " incrementaly show search results
set hlsearch        " highlight searches
set showmatch       " hightlight matching braces

set noswapfile      " dont use swapfiles

set splitright      " open next split on right side

set scrolloff=2     " number of line to keep

if (has('mouse'))
    set mouse=a
endif

" Basic Theme
set background=dark
if (has('termguicolors'))
    set termguicolors
endif
set t_Co=256        " enable 256 colors
set ruler
set showcmd         " show partial commnand in the bottom

set noerrorbells


" ----- Other settings -----
augroup trim_whitespace
    autocmd!
    autocmd BufWritePre * :%s/\s\+$//e
augroup end


" ----- Mappings -----
"
nnoremap <SPACE> <Nop>
let mapleader = " "

" Splits navigation
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap + :vertical resize +5<CR>
nnoremap _ :vertical resize -5<CR>

" Tabs navigation
nnoremap <M-h> :tabp<CR>
nnoremap <M-l> :tabn<CR>

" Wrapping
nnoremap <leader>` <cmd>set wrap!<CR>

" Rather remap Capslock to Escape
"inoremap jj <ESC>

" Clear search
nnoremap // :noh<CR>

" Keep visual selection when indenting
vnoremap > >gv
vnoremap < <gv

" Create new lines in and stay in normal mode
nmap zj o<Esc>k
nmap zk O<Esc>j

" Yanking
nnoremap Y y$
" Copy from clipboard
nnoremap zp "*p
nnoremap zy "*y
nnoremap zY "*Y
nnoremap zP "*P
vnoremap zy "*y
vnoremap zY "*Y

" Do not move cursor while joining
"nnoremap J mzJ'z

" Moving text
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '>-2<CR>gv=gv
" Probably not needed fo normal mode
"nnoremap <leader>j :m .+1<CR>==
"nnoremap <leader>k :m .-2<CR>==

" Faster file saving and exiting
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" Search and replace template
nnoremap <leader>\ :%s//gc<left><left><left>
