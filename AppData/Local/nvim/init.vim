"
" Requirements:
" - C compiler is needed for treesitter to work (otherwise the is C compiler not found error.
" - lombok in C:\tools\lombok.jar
" - install coc-java, coc-kotlin, coc-json, coc-tsserver
" - copy ~/.vim/treesitter/<lang>-highlights.scm to the respective language syntax queries
" - install ripgrep for telescope
" - install make for telescope-fzf-native
" - install elm-language-server with npm install -g @elm-tooling/elm-language-server
" - install MikTex and SumatraPDF for latex.
" - install ccls (On windows using choco install ccls)
"
"
" Todos:
" TODO: Checkout easy align plugin https://www.giters.com/junegunn/vim-easy-align
" TODO: Make vim airline shorter or act different with vertical splits.
" TODO: Remap :diffget //2 and diffget //3
" TODO: Import static codeaction missing for java.
" - https://github.com/neoclide/coc-java/issues/64
" TODO: Fix java formatting settings.
" TODO: Shorten filename in tabs.
" - https://stackoverflow.com/questions/2468939/how-to-let-tab-display-only-file-name-rather-than-the-full-path-in-vim
" TODO: Trying out syntax highlighting for java types, so consider keeping it.
" TODO: Do not show telescope preview for some file extensions.
"  - it wrote with default previewer 'binary cannot be previewed' on my work pc
"       so this may work on its own.
" TODO: Configure java debug.
" TODO: Checkout https://github.com/ivalkeen/nerdtree-execute
"   to execute file from nerdtree. Useful to open pdfs and so on.
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
" Coc config:
" https://github.com/neoclide/coc.nvim/blob/master/data/schema.json
" For documentation of completion, use 'suggest.floatEnable': false in settings.json.
" For diagnostic messages, use 'diagnostic.messageTarget': 'echo' in settings.json.
" For signature help, use 'signature.target': 'echo' in settings.json.
" For documentation on hover, use 'hover.target': 'echo' in settings.json.
"
"
"

"
"
" Bugs_or_Restrictions:
"
" Gradle annotation processing does not work by default.
" It must be configured in build.gradle of project with plugin 'net.ltgt.apt-eclipse'.
"
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
Plug 'JoosepAlviste/nvim-ts-context-commentstring'  " set commentstring base on treesitter context
Plug 'tpope/vim-repeat'         " make surround repeatable with .
Plug 'vim-scripts/ReplaceWithRegister'
" Plug 'justinmk/vim-sneak'     " add after I'm good with f/t
Plug 'AndrewRadev/switch.vim'

" Textobjects
Plug 'kana/vim-textobj-user'         " dependency of textobj-entire
Plug 'kana/vim-textobj-entire'
Plug 'wellle/targets.vim'       " adds more textobjects like args, separators (, . /) and so on
" Plug 'vim-scripts/argtextobj.vim'    " reconsider using intead of targets argtextobj

" Changes to behaviour
Plug 'machakann/vim-highlightedyank'
Plug 'tpope/vim-speeddating'         " <C-a> increment for dates and such, vim not seeing '-' as minus
" Autopairs is causing more problems than helping.
"Plug 'jiangmiao/auto-pairs'          " automatically close ('`\"
Plug 'Raimondi/delimitMate'          " automatically close ('`\"

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
let g:coc_global_extensions = [
\ 'coc-json',
\ 'coc-html',
\ 'coc-html-css-support',
\ 'coc-css',
\ 'coc-java',
\ 'coc-kotlin',
\ 'coc-json',
\ 'coc-tsserver',
\ 'coc-tslint-plugin',
\ 'coc-emmet',
\ 'coc-texlab',
\ 'coc-vimtex']
Plug 'honza/vim-snippets'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'ElmCast/elm-vim' " better syntax highliging
Plug 'udalov/kotlin-vim'
Plug 'lervag/vimtex'
Plug 'jackguo380/vim-lsp-cxx-highlight'
" More syntax highlighting.
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/playground'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
call plug#end()

" ----- Theme ------
if (has("nvim"))
   let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
if (has("termguicolors"))
   set termguicolors
 endif
" Colorschemes
colorscheme onedark

set colorcolumn=80

" TSTypes are disabled for java by editing java/highlights.scm.
" Consider disabling TStypes this way.
"hi link TSType NONE
hi Comment ctermfg=Green guifg=Green
" Do not highlight indented text in markdown
hi clear markdownCodeBlock
" I like undercurl better here.
hi CocUnderline cterm=underline gui=undercurl


" Use this for something else than nvim-qt
" set guifont=FiraCode\ NF:h10
" let g:fontsize = 10
" function! AdjustFontSize(amount)
"   let g:fontsize = g:fontsize+a:amount
"   :execute "set guifont=FiraCode\ NF:h" . g:fontsize
"   " This echo statment does not work.
"   :execute "echo \"Fontsize adjusted to \"" . g:fontsize
" endfunction

noremap <M-+> :call AdjustFontSize(1)<CR>
noremap <M-_> :call AdjustFontSize(-1)<CR>

" -- Neovide --
"let g:neovide_fullscreen=v:true
let neovide_remember_window_size = v:true
let g:neovide_refresh_rate=100
let g:neovide_no_idle=v:true
let g:neovide_cursor_animation_length=0
let g:neovide_cursor_trail_length=0
command! -nargs=0 NeovideToggleFullscreen :let g:neovide_fullscreen = !g:neovide_fullscreen
nnoremap <C-+> <cmd>NeovideToggleFullscreen<CR>

set noshowmode                          " don't show because of airline
set signcolumn=yes " column to show diagnostics and not appear and disappear
" Give more space for displaying messages.
set cmdheight=2     " Try now and maybe remove later.

" ----- Airline -----
" Airline theme should be automatically selected.
" let g:airline_theme = 'onedark'
let g:airline_stl_path_style = 'short'
let g:airline_section_c_only_filename = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

augroup my_spaces
    au!
    autocmd Filetype python          setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
    autocmd Filetype go              setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
    autocmd Filetype java            setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
    autocmd Filetype markdown        setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
    autocmd Filetype tex             setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
    autocmd Filetype json            setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
    autocmd Filetype typescript      setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
    autocmd Filetype typescriptreact setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
augroup end

augroup my_comments
    au!
    autocmd FileType cpp setlocal commentstring=//\ %s
augroup end

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" " delays and poor user experience.
set updatetime=100

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
command! ToggleVerbose <cmd>call ToggleVerbose()
command! -complete=file -nargs=1 Rm :echo 'Remove: '.'<f-args>'.' '.(delete(<f-args>) == 0 ? 'SUCCEEDED' : 'FAILED')


command! Qother execute '%bdelete | edit # | normal `"'
command! Qo execute '%bdelete | edit # | normal `"'

" ----- Plugin specific mappings -----

" --- Git ---
" https://dpwright.com/posts/2018/04/06/graphical-log-with-vimfugitive/
command! -nargs=* Glg Git! log --graph --abbrev-commit --decorate --format=format:'%s %C(bold yellow)%d%C(reset) %C(bold green)(%ar)%C(reset) %C(dim white)<%an>%C(reset) %C(bold blue)%h%C(reset)' --all<args>
" --- Fuzzy search ---

" FIles
nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>g <cmd>Telescope git_files<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader><Tab> <cmd>Telescope oldfiles<CR>

" Git
nnoremap <leader>s <cmd>Telescope git_status<cr>
nnoremap <leader>c <cmd>Telescope git_commits<cr>

" Search in files
nnoremap <leader>/ <cmd>Telescope live_grep<cr>
nnoremap <leader>? <cmd>lua require('telescope.builtin').grep_string { search = vim.fn.input("Grep for ") } <cr>

" Resume last search
nnoremap <leader>, <cmd>Telescope resume<cr>

" Vim help
" Search for marks
nnoremap <leader>m <cmd>Telescope marks<cr>
" Quickly go to some my config file
command! Dotfiles :lua require('telescope.builtin').git_files { cwd = '~' } <cr>

" Telescope colorscheme is anther useful one.

lua <<EOF
local actions = require('telescope.actions')
local previewers = require('telescope.previewers')

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
        -- Use same horizontal and vertical mappings as Nerdtree.
        ["<C-i>"] = actions.select_horizontal,
        ["<C-s>"] = actions.select_vertical,
      },
    },
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


" ----- Nerdtree -----
nnoremap <C-n> <cmd>NERDTreeToggle<CR>
nnoremap <leader>r <cmd>NERDTreeFind<CR>
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeShowHidden=1                    " Show hidden files
let g:NERDTreeWinPos = "right"
let NERDTreeQuitOnOpen=1
let g:NERDTreeWinSize=60           " Maybe do this just for some file types.
" Refresh devicons so nerdtree does not show [] around icons
if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif

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
  ensure_installed = { "java", "javascript", "typescript", "tsx" },
  highlight = {
    enable = true,
    disable = { "kotlin" },
  },
  context_commentstring = {
    enable = true
  }
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
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <silent><expr> <c-@> coc#refresh()

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
nnoremap <leader>e <cmd>CocFix<CR>
nmap <leader>E <plug>(coc-fix-current)

nmap <leader>l <Plug>(coc-format)
nmap <leader>L  <Plug>(coc-format-selected)
vmap <leader>L  <Plug>(coc-format-selected)

nnoremap <leader>o <cmd>call CocAction('runCommand', 'editor.action.organizeImport')'<CR>

nnoremap <leader>h <cmd>call CocAction('doHover')<CR>
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

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

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

" ----- Java ----
command JavaProjektImport CocCommand java.projectConfiguration.update
" Switch for java properties <-> getters usages.
autocmd FileType java let b:switch_custom_definitions =  [
    \   {
    \     '\.\(get\)\@!\(\k\)\(\k*\)\>': '\.get\u\2\3\(\)',
    \     '\.\get\(\k\)\(\k*\)\>()':     '.\l\1\2',
    \   }
    \ ]

nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>

" ----- Golang ------

let g:go_def_mapping_enables = 0  " use gd from COC
let g:go_doc_keywordprg_enabled = 0 " use K from COC

" Go syntax highlighting
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
" let g:go_highlight_types = 1
" let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1

 " Auto formatting and importing
let g:go_fmt_autosave = 0
let g:go_imports_autosave = 0
let g:go_fmt_command = "goimports"

" Status line types/signatures
let g:go_auto_type_info = 1

" Autocomplete on .
" au filetype go inoremap <buffer> . .<C-x><C-o>
" au filetype go nnoremap gm <cmd>GoRename
" au filetype go nnoremap ga <cmd>GoReferrers<CR> <C-w>j
" au filetype go inoremap <C-Space> <C-x><C-o>
" au filetype go inoremap <C-@> <C-Space>

" ----- Elm -----
let g:elm_setup_keybindings = 0
let g:elm_format_autosave = 0       " Fuck this. Wasted so much time disabling this..
let g:elm_format_fail_silently = 0

" ----- Latex -----
" Set previewer to SumatraPDF
let g:tex_flavor='latex'
let g:vimtex_quickfix_mode=0

let g:vimtex_view_general_viewer = 'SumatraPDF'
let g:vimtex_view_general_options
    \ = '-reuse-instance -forward-search @tex @line @pdf'
let g:vimtex_view_general_options_latexmk = '-reuse-instance'

augroup my_latex
    au!
    autocmd FileType tex set wrap
augroup end

" ----- C++ -------
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
" For more highlights run
" :help vim-lsp-cxx-highlight
