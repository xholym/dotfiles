set nocompatible
set encoding=utf-8

syntax on
syntax enable

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

" Search
set ignorecase      " ignore case by default
set smartcase       " do not ignore case when uppercase is typed
set incsearch       " incrementaly show search results
set hlsearch        " highlight searches
set showmatch       " hightlight matching braces
" Clear search
nnoremap // :noh<CR>


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

set matchtime=0      " time in tenths of seconds to jump to previous pair when closing


" ----- Other settings -----
augroup trim_whitespace
    autocmd!
    autocmd BufWritePre * :%s/\s\+$//e
augroup end


" ----- Mappings -----
"
nnoremap <SPACE> <Nop>
let mapleader = " "

" Navigation
nnoremap <C-tab> <C-^>
" go to last tab is still g<tab>

" Splits navigation
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap + :vertical resize +5<CR>
nnoremap _ :vertical resize -5<CR>
nnoremap <c-+> :resize +5<CR>
nnoremap <c-_> :resize -5<CR>

" Tabs navigation
nnoremap <M-h> :tabp<CR>
nnoremap <M-l> :tabn<CR>

" Toggle wrapping
set nowrap		   	" don't wrap lines
let &showbreak = '> '   " show this string wrapped line
set linebreak textwidth=0 wrapmargin=0 " don't automatically insert line breaks at 80 column, does not work.
nnoremap <leader>` <cmd>set wrap!<CR>

" Rather remap Capslock to Escape
"inoremap jj <ESC>

" Don't hit Shift to start command mode.
nnoremap ; :
" And use , as ; to go to next f/t hit and : as , to go to previous.
nnoremap , ;
nnoremap <c-,> ,
" : is a free key to use wherever

" Rerun last command
nnoremap <leader>; :<up><CR>

" Keep visual selection when indenting
vnoremap > >gv
vnoremap < <gv

" Create new lines in and stay in normal mode
nnoremap zj o<Esc>k
nnoremap zk O<Esc>j
" Put space behind or after cursor
nnoremap z9 i <Esc>
nnoremap z0 a <Esc>

" Yanking
nnoremap Y y$
" Copy from clipboard
nnoremap zp "*p
nnoremap zy "*y
nnoremap zY "*y$
nnoremap zP "*P
vnoremap zy "*y
vnoremap zY "*y$
inoremap <C-v> <C-o>"*P
" Yuick paste without leaving insert mode.
inoremap <c-p> <C-o>P

" Do not move cursor while joining
"nnoremap J mzJ'z

" Moving text
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '>-2<CR>gv=gv
" Probably not needed fo normal mode
"nnoremap <leader>j :m .+1<CR>==
"nnoremap <leader>k :m .-2<CR>==

" Search and replace template
nnoremap <leader>\ :%s//gc<left><left><left>

" quickfix, location lists
nnoremap [g <cmd>cprev<cr>
nnoremap ]g <cmd>cnext<cr>
nnoremap [G <cmd>copen<cr>
nnoremap ]G <cmd>cclose<cr>
nnoremap [l <cmd>lprev<cr>
nnoremap ]l <cmd>lnext<cr>
nnoremap [L <cmd>lopen<cr>
nnoremap ]L <cmd>lclose<cr>

" Abreviations
ab nch nocheckin
