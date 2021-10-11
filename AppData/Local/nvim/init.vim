set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

filetype plugin indent on

set autowrite


" ----- Plugins -----

call plug#begin('~/.vim/plugged')    " initialize plugin system

" Text edit
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'vim-scripts/argtextobj.vim'
Plug 'kana/vim-textobj-user'         " dependency of textobj-entire
Plug 'kana/vim-textobj-entire'
Plug 'Raimondi/delimitMate'          " automatically close ('`\"
Plug 'vim-scripts/ReplaceWithRegister'

Plug 'machakann/vim-highlightedyank'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Themes
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'ryanoasis/vim-devicons'        " adds icons to plugins

Plug 'mhinz/vim-startify'

" Git
Plug 'tpope/vim-fugitive'

Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Fuzzy finder
Plug 'ctrlpvim/ctrlp.vim'
" FZF does not work with win terminal
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'junegunn/fzf.vim'

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }


call plug#end()


if (has("nvim"))
   let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
if (has("termguicolors"))
   set termguicolors
 endif
" Colorschemes
colorscheme onedark
let g:airline_theme = 'onedark'

set colorcolumn=80
" ColorColumn's color should be set automatically by colorscheme
" highlight ColorColumn ctermbg=0 guibg=grey
set noshowmode                          " dont show because of airline


autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype go setlocal tabstop=4 shiftwidth=4 softtabstop=4


" ----- Plugin specific mappings -----


" --- Fuzzy search ---
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_root_markers = ['pom.xml', 'build.gradle' ]
" nnoremap <C-p> :GFiles<CR>
" nnoremap <leader>p :History<CR>
" nnoremap <leader>? :Colors<CR>  " temporary, for trying new color schemes

set signcolumn=yes " column to show diagnostics and not appear and disappear

" --- COC ---

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" " delays and poor user experience.
set updatetime=300

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition) " maybe I'll use this, if not remove
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> ga <Plug>(coc-references)
nmap <silent> gm <Plug>(coc-rename)
nnoremap <leader>f :CocFix<CR>
nnoremap <leader>l <Plug>(coc-format)
" Use <c-space> to trigger completion.
if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
  else
    inoremap <silent><expr> <c-@> coc#refresh()
endif

nmap <leader>l  <Plug>(coc-format-selected)

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Map function and class text objects
" " NOTE: Requires 'textDocument.documentSymbol' support from the language
" server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Adds commands from COC
command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold :call CocAction('fold', <f-args>)
command! -nargs=0 OptimizeImports :call CocAction('runCommand', 'editor.action.organizeImport')'

" "Uses nvim's airline status line
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Add lombok to coc.settings.json.
"{
    ""java.jdt.ls.vmargs": "-javaagent:/usr/local/share/lombok.jar"
"}
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


" ----- Airline -----
let g:airline_powerline_fonts = 1

" ----- Nerdtree -----
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeShowHidden=1 " Show hidden files


" ----- Go -----

let g:go_def_mapping_enables = 0  " use gd from COC

" Go syntax highlighting
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
" let g:go_highlight_types = 1
" let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1

 " Auto formatting and importing
"let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"

" Status line types/signatures
let g:go_auto_type_info = 1

 " Map keys for most used commands.
 " Ex: `\b` for building, `\r` for running
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)

" Autocomplete on .
" au filetype go inoremap <buffer> . .<C-x><C-o>
" au filetype go nnoremap gm :GoRename
" au filetype go nnoremap ga :GoReferrers<CR> <C-w>j
" au filetype go inoremap <C-Space> <C-x><C-o>
" au filetype go inoremap <C-@> <C-Space>

" For Omni-completion:
" Close preview window after autocomple selection is made
" au CompleteDone * pclose
