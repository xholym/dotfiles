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

set nowrap		   	" dont wrap lines
set smartcase       " ignore case during search unless there is a Capital letter
set incsearch       " incrementaly show search results
set hlsearch        " highlight searches
set showmatch       " hightlight matching braces

set noswapfile      " dont use swapfiles

set splitright      " open next split on right side

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


" ----- Custom mappings -----
"
nnoremap <SPACE> <Nop>
let mapleader = " "

" -- Navigation --
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


" -- Main mappings --

inoremap jj <ESC>

" Clear search
nnoremap // :noh<CR>

" Keep visual selection when indenting
vnoremap > >gv
vnoremap < <gv

" Create new lines in and stay in normal mode
nmap zj o<Esc>k
nmap zk O<Esc>j

" -- Yanking --
nnoremap Y y$

" Copy from clipboard
"set clipboard+=unnamed  " copy to system clipboard
nnoremap zp "*p
nnoremap zy "*y
nnoremap zY "*Y
nnoremap zP "*P
vnoremap zy "*y
vnoremap zY "*Y
