"
" Requirements:
" - C compiler is needed for treesitter to work (otherwise the is C compiler not found error.
" - lombok in C:\tools\lombok.jar
" - install coc-java, coc-kotlin, coc-json
" - copy ~/.vim/treesitter/<lang>-highlights.scm to the respective language syntax queries
" - install ripgrep
"
"
" Todos:
" TODO: Do not show telescope preview for some file extensions.
" TODO: Use font ligatures.
"  - when nvim-qt will support them for windows.
"  - https://github.com/equalsraf/neovim-qt/issues/166
" TODO: Configure java debug.
" TODO: configure queryDSL annnotation processor.
" TODO: Checkout https://github.com/ivalkeen/nerdtree-execute
"   to execute file from nerdtree. Useful to open pdfs and so on.
"
" Consider using snippets. Check out honza/vim-snippets.
"
"
" Notes:
" Im writing this down, cause it help me to remember these mappings and use them.
" Useful commands to try:
" *         - to search string under cursor
" i_<C-o>    - execute command and go back to insert mode
" :s//c     - count occurrences
" @@        - execute last macro
" g<C-a>    - increment sequentially
" <C-^>     - go to last file
" Use marks with m<reg> '<reg>.
"
" Use [s, ]s to navigate spelling mistakes
" Use zg to add to global spell file
" Use zg to add to global spell file
"
" In nerdtree:
" m     - select operations: delele, move, copy, create...
" p     - go to parent
" u     - make root go up a dir
"

"
"
" Bugs:
" Go to definition does not work for java library sources.
"  - https://github.com/neoclide/coc-java/issues/82
"  - this bug comes from a escaping problem on windows,
"      'You can't really escape anything but space on windows'
"        - said guy in issue thread
"  - https://github.com/neovim/neovim/issues/3912
"  - https://github.com/neoclide/coc.nvim/issues/2748
"
" Starting neovim from gitbash breaks terminal.
" See https://github.com/neovim/neovim/issues/14605
"
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

" Commands
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'         " make surround repeatable with .
Plug 'vim-scripts/ReplaceWithRegister'

" Textobjects
Plug 'kana/vim-textobj-user'         " dependency of textobj-entire
Plug 'kana/vim-textobj-entire'
Plug 'wellle/targets.vim'       " adds more textobjects like args, separators (, . /) and so on
" Plug 'vim-scripts/argtextobj.vim'    " reconsider using intead of targets argtextobj

" Changes to behaviour
Plug 'machakann/vim-highlightedyank'
" Autopairs is causing more problems than helping.
"Plug 'jiangmiao/auto-pairs'          " automatically close ('`\"

" Themes
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'ryanoasis/vim-devicons'        " adds icons to plugins
Plug 'mhinz/vim-startify'

" Git
Plug 'tpope/vim-fugitive'

" Working directory navigation
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Fuzzy finder
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'                    " telescope requirement
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' } " better sort and search
Plug 'kyazdani42/nvim-web-devicons'  " devicons for telescope

Plug 'mbbill/undotree'

" Language support
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" More syntax highlighting.
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/playground'
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

" TSTypes are disabled for java by editing java/highlights.scm.
" Consider disabling TStypes this way.
"hi link TSType NONE
hi Comment ctermfg=Green guifg=Green
" Do not highlight indented text in markdown
hi clear markdownCodeBlock

set noshowmode                          " don't show because of airline


autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype go setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype java setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype markdown setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2


set signcolumn=yes " column to show diagnostics and not appear and disappear

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" " delays and poor user experience.
set updatetime=300
"
" Give more space for displaying messages.
set cmdheight=2     " Try now and maybe remove later.

" Spelling
" Not using global for now.
" set spell
" set spelllang=en,sk
" TODO: Maybe move mapping to ~/.vimrc
nnoremap <silent> <F11> <cmd>setlocal spell! spelllang=en,sk<CR>
nnoremap z+ 1z=

" Show nine spell checking candidates at most
set spellsuggest=best,9
hi clear SpellBad
" Default spellbad colloring.
" hi SpellBad cterm=underline ctermfg=204 gui=underline guifg=#E06C75
hi SpellBad cterm=underline gui=underline

" Verbose file for debug.
function! ToggleVerbose()
    if !&verbose
        echo 'verbose file set'
        set verbosefile=~/.vim/verbose.log
        set verbose=15
    else
        echo 'verbose file unset'
        set verbose=0
        set verbosefile=
    endif
endfunction
command ToggleVerbose <cmd>call ToggleVerbose()
command! -complete=file -nargs=1 Rm :echo 'Remove: '.'<f-args>'.' '.(delete(<f-args>) == 0 ? 'SUCCEEDED' : 'FAILED')


" ----- Plugin specific mappings -----

" --- Fuzzy search ---

" FIles
nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>g <cmd>Telescope git_files<cr>
nnoremap <leader>c <cmd>Telescope buffers<cr>
nnoremap <leader><Tab> <cmd>Telescope oldfiles<CR>

" Git
nnoremap <leader>x <cmd>Telescope git_status<cr>
nnoremap <leader>c <cmd>Telescope git_commits<cr>

" Search in files
nnoremap <leader>/ <cmd>Telescope live_grep<cr>
nnoremap <leader>? <cmd>lua require('telescope.builtin').grep_string { search = vim.fn.input("Grep for ") } <cr>

" Telescope colorscheme is anther useful one.

lua <<EOF
local actions = require('telescope.actions')
require('telescope').setup {
  defaults = {
    file_ignore_patterns = {'build/.*', 'bin/.*'},
    path_display = { truncate = 2 },
    color_devicons = true,
    set_env = { ['COLORTERM'] = 'truecolor' },
    mappings = {
      i = {
        ['<esc>'] = actions.close,
        ['jj'] = { '<esc>', type = 'command' },
      },
    }
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,  -- overrides the generic sorter
      override_file_sorter = true,     -- overrides the file sorter
      case_mode = "smart_case",
    }
  }
}
require('telescope').load_extension('fzf')
EOF

" ----- Airline -----
let g:airline_powerline_fonts = 1

" ----- Nerdtree -----
map <C-n> <cmd>NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeShowHidden=1                    " Show hidden files
let g:NERDTreeWinPos = "right"

" --- Undo tree ---
nnoremap <leader>u <cmd>UndotreeToggle<cr>
set undodir=~/.vim/undodir
set undofile
"let g:undotree_WindowLayout = 2  " bigger diff window
let g:undotree_ShortIndicators = 1
"let g:undotree_SetFocusWhenToggle = 0  " set focus on undotree

"--- Nvim treesitter ---
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "java", "kotlin" },
  highlight = {
    enable = true,
    -- disable = { "c", "rust" },  -- Disable for these.
  },
}
EOF

" --- COC ---

" - Sets -
" These sets are COC specific.

" TextEdit might fail if hidden is not set.
set hidden
" Don't show annoying completion messages on autocompletion.
set shortmess+=c


" - Autocompletion -
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

" Quick fixes
" Using e not q, because Q is used for fast quit.
nnoremap <leader>E <cmd>CocFix<CR>
nmap <leader>e <plug>(coc-fix-current)

nnoremap <leader>l <Plug>(coc-format)
nnoremap <leader>L  <Plug>(coc-format-selected)

nnoremap <leader>o <cmd>call CocAction('runCommand', 'editor.action.organizeImport')'<CR>
"
" Use K to show documentation in preview window.
nnoremap <silent> K <cmd>call <SID>show_documentation()<CR>

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
command! -nargs=0 Format <cmd>call CocAction('format')
command! -nargs=? Fold <cmd>call CocAction('fold', <f-args>)
command! -nargs=0 OptimizeImports <cmd>call CocAction('runCommand', 'editor.action.organizeImport')'

augroup signiturehelp
  autocmd!
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Show current function on statusline
" This does not work. TODO: Look into it.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

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
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)

" Autocomplete on .
" au filetype go inoremap <buffer> . .<C-x><C-o>
" au filetype go nnoremap gm <cmd>GoRename
" au filetype go nnoremap ga <cmd>GoReferrers<CR> <C-w>j
" au filetype go inoremap <C-Space> <C-x><C-o>
" au filetype go inoremap <C-@> <C-Space>

" For Omni-completion:
" Close preview window after autocomple selection is made
" au CompleteDone * pclose
if has('win32') || has('win64')
  function Fnameescape(f)
    return '`='.json_encode(a:f).'`'
  endfunction
else
  let Fnameescape = function('fnameescape')
endif

