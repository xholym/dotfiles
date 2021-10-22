" Requirements:
" - C compiler is needed for treesitter to work (otherwise the is C compiler not found error.
" - lombok in C:\tools\lombok.jar
" - install coc-java, coc-kotlin
" - copy ~/.vim/treesitter/<lang>-highlights.scm to the respective language syntax queries
"
" Notes:
" TODO: Configure java debug.
" TODO: configure queryDSL annnotation processor.
" Coc statusline with function definition does not work.
" May try to use treesitter statusline.
"
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
" FZF does not work now
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'junegunn/fzf.vim'

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

" More syntax highlighting.
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/playground'

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

" TSTypes are disabled for java by editing java/highlights.scm.
" Consider disabling TStypes this way.
"hi link TSType NONE
hi Comment ctermfg=Green guifg=Green

set noshowmode                          " dont show because of airline


autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype go setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype java setlocal tabstop=4 shiftwidth=4 softtabstop=4


set signcolumn=yes " column to show diagnostics and not appear and disappear

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" " delays and poor user experience.
set updatetime=300
"
" Give more space for displaying messages.
set cmdheight=2     " Try now and maybe remove later.

" ----- Plugin specific mappings -----


" --- Fuzzy search ---
" -- Ctrl-p --
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_root_markers = ['pom.xml', 'build.gradle' ]

" -- FZF --
"nnoremap <C-p> :GFiles<CR>
"nnoremap <leader>p :History<CR>
" temporary, for trying new color schemes
"nnoremap <leader>? :Colors<CR>

" --- COC ---

" - Sets -
" These sets are COC specific.

" TextEdit might fail if hidden is not set.
set hidden
" Don't show annoying completion messages on autocompletion.
set shortmess+=c


" - Autocompletion -
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
" Use <c-space> to trigger completion.
if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
  else
    inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" - Mappings -

" Diagnostic navigation
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> [e <Plug>(coc-diagnostic-prev-error)
nmap <silent> ]e <Plug>(coc-diagnostic-next-error)

" Code syntax tree operations
nmap <silent> gd <Plug>(coc-definition)
" Maybe I'll use this, if not remove
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> ga <Plug>(coc-references)
nmap <silent> gm <Plug>(coc-rename)

" Quick fixes - TODO: switch them if the other one is used more.
nnoremap <leader>Q :CocFix<CR>
nmap <leader>q <plug>(coc-fix-current)

nnoremap <leader>l <Plug>(coc-format)
nnoremap <leader>L  <Plug>(coc-format-selected)

nnoremap <leader>o :call CocAction('runCommand', 'editor.action.organizeImport')'<CR>
"
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" CodeActions

" Apply codeAction to the selected region.
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
" Apply codeAction to the current buffer.
nmap <leader>A  <Plug>(coc-codeaction)

" Map function and class text objects
" " NOTE: Requires 'textDocument.documentSymbol' support from the language
" server.
xnoremap if <Plug>(coc-funcobj-i)
onoremap if <Plug>(coc-funcobj-i)
xnoremap af <Plug>(coc-funcobj-a)
onoremap af <Plug>(coc-funcobj-a)
xnoremap ic <Plug>(coc-classobj-i)
onoremap ic <Plug>(coc-classobj-i)
xnoremap ac <Plug>(coc-classobj-a)
onoremap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
" TODO: Delete if I won't use it.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" - Other settings -

" Adds commands from COC
command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold :call CocAction('fold', <f-args>)
command! -nargs=0 OptimizeImports :call CocAction('runCommand', 'editor.action.organizeImport')'

augroup signiturehelp
  autocmd!
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Show current function on statusline
" This does not work. TODO: Look into it.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" ----- Airline -----
let g:airline_powerline_fonts = 1

" ----- Nerdtree -----
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeShowHidden=1                    " Show hidden files
let g:NERDTreeWinPos = "right"

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

" --- Nvim treesitter ---
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "java", "kotlin" },
  highlight = {
    enable = true,
    -- disable = { "c", "rust" },  -- Disable for these.
  },
}
EOF
