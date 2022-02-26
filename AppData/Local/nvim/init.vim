"
" Requirements:
" - C compiler is needed for treesitter to work (otherwise the is C compiler not found error.
" - lombok in C:\tools\lombok.jar
" - install ripgrep for telescope
" - install make for telescope-fzf-native
" - install elm-language-server with npm install -g @elm-tooling/elm-language-server
" - install MikTex and SumatraPDF for latex.
" - install ccls (On windows using choco install ccls)
" - install tar (lsp-installer requires it)
" - if coq snipets do not work copy coq.artifacts/coq+snippets+v2
"     to coq_nvim/.vars/clients/snippets/users+v2.json
"
"
" Todos:
" TODO: Setup git bash in toggle terminal https://github.com/akinsho/toggleterm.nvim
"       - example https://github.com/kabinspace/AstroVim/blob/main/lua/configs/toggleterm.lua
" TODO: Checkout easy align plugin https://www.giters.com/junegunn/vim-easy-align
" TODO: Checkout smooth scrolling karb94/neoscroll.nvim
" TODO: Remap :diffget //2 and diffget //3
" TODO: Import static codeaction missing for java.
" - https://github.com/neoclide/coc-java/issues/64
" TODO: Fix java formatting settings.
" - https://stackoverflow.com/questions/2468939/how-to-let-tab-display-only-file-name-rather-than-the-full-path-in-vim
" TODO: Do not show telescope preview for some file extensions.
"  - it wrote with default previewer 'binary cannot be previewed' on my work pc
"       so this may work on its own.
" TODO: Configure java debug.
"
"
" Notes:
" Im writing this down, cause it help me to remember these mappings and use them.
"
" In nerdtree:
" p     - go to parent
"
" Coc config:
" https://github.com/neoclide/coc.nvim/blob/master/data/schema.json
" For documentation of completion, use 'suggest.floatEnable': false in settings.json.
" For diagnostic messages, use 'diagnostic.messageTarget': 'echo' in settings.json.
" For signature help, use 'signature.target': 'echo' in settings.json.
" For documentation on hover, use 'hover.target': 'echo' in settings.json.
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
Plug 'tpope/vim-repeat'         " make surround repeatable with .
Plug 'vim-scripts/ReplaceWithRegister'
" Plug 'justinmk/vim-sneak'     " add after I'm good with f/t
Plug 'AndrewRadev/switch.vim'

" Textobjects
Plug 'kana/vim-textobj-user'         " dependency of textobj-entire
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-line'
Plug 'wellle/targets.vim'       " adds more textobjects like args, separators (, . /) and so on
" Plug 'vim-scripts/argtextobj.vim'    " reconsider using intead of targets argtextobj

" Changes to behaviour
Plug 'machakann/vim-highlightedyank'
Plug 'tpope/vim-speeddating'         " <C-a> increment for dates and such, vim not seeing '-' as minus
"
" Autopairs may be causing more problems than helping.
" TODO: Try https://github.com/windwp/nvim-autopairs
"   here is an example config https://github.com/kabinspace/AstroVim/blob/main/lua/configs/autopairs.lua
Plug 'Raimondi/delimitMate'          " automatically close ('`\"
Plug 'AndrewRadev/bufferize.vim' " put command output in tmp buffer
Plug 'alvan/vim-closetag'

" Themes
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'ap/vim-css-color'
Plug 'savq/melange'
Plug 'ryanoasis/vim-devicons'        " adds icons to plugins
Plug 'mhinz/vim-startify'       " better info about buffer change in statusline
Plug 'lukas-reineke/indent-blankline.nvim'

" Git
Plug 'tpope/vim-fugitive' " rival is https://github.com/lewis6991/gitsigns.nvim
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/gv.vim'

" Working directory navigation
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ivalkeen/nerdtree-execute'

" Distraction free mode
Plug 'junegunn/goyo.vim'

" Fuzzy finder
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'                    " telescope requirement
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' } " better sort and search
Plug 'kyazdani42/nvim-web-devicons'  " devicons for telescope

Plug 'mbbill/undotree'

" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" Language support
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" \ 'coc-java', " java jump to definition does not work for jars in windows

" let g:coc_global_extensions = [
" \ 'coc-json',
" \ 'coc-html',
" \ 'coc-html-css-support',
" \ 'coc-css',
" \ 'coc-kotlin',
" \ 'coc-json',
" \ 'coc-tsserver',
" \ 'coc-tslint-plugin',
" \ 'coc-emmet',
" \ 'coc-texlab',
" \ 'coc-vimtex',
" \ 'coc-yaml',
" \ 'coc-prettier']
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'ElmCast/elm-vim' " better syntax highliging
Plug 'udalov/kotlin-vim'
Plug 'lervag/vimtex'
Plug 'jackguo380/vim-lsp-cxx-highlight'
" More syntax highlighting.
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/playground'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'  " set commentstring base on treesitter context
" Plug 'SmiteshP/nvim-gps' " needs lualine not airline

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'mfussenegger/nvim-jdtls'

Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
" Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
call plug#end()

" ------ Highlighting --------
"
if (has("nvim"))
   let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
if (has("termguicolors"))
   set termguicolors
 endif

" Colorschemes
colorscheme melange
" colorscheme onedark

set colorcolumn=80

function! s:my_highlights()
    " Disable italics for melange colorscheme
    hi Comment gui=NONE
    hi String gui=NONE
    hi Todo gui=NONE
    hi TSVariableBuiltin gui=NONE
    hi TSConstBuiltin gui=NONE

    hi Comment ctermfg=Green guifg=Green
    " consider String color change for melange
    " hi String ctermfg=DarkGreen guifg=#69764D

    " For melange colorscheme
    " hi Function guifg=#EBC06D " This is the default fo melange
    " hi Function guifg=#FFE88D
    hi Function guifg=#ECDFA0
    " This is the normal default
    " hi Normal guifg=#ECE1D7
    " Consider making normal little brighter
    " hi Normal guifg=#FCF1E7
    hi MyIdentifier ctermfg=LightMagenta guifg=#EFC0EA
    hi link yamlTSField MyIdentifier
    " hi Delimiter guifg=#8E733F " This is the default.
    " Making Delimiter a little brighter.
    hi Delimiter guifg=#AE935F

    hi ColorColumn guibg=#2E2822

    hi clear markdownCodeBlock

    hi link gitCommitSummary Normal
    hi link gitCommitOverflow SpellBad

    hi link tsxAttrib Normal
    hi link tsxTag TSConstructor
    hi link tsxTagName TSConstructor

    " hi CocUnderline cterm=underline gui=underline

    hi clear SpellBad
    " Default spellbad colloring.
    " hi SpellBad cterm=underline ctermfg=204 gui=underline guifg=#E06C75
    hi SpellBad cterm=underline gui=underline

    " Use same colors as DiagnosticError / DiagnosticWarn and so on.
    hi DiagnosticUnderlineError guisp=#B65C60
    hi DiagnosticUnderlineWarn guisp=#EBC06D
    hi DiagnosticUnderlineInfo guisp=#9AACCE
    hi DiagnosticUnderlineHint guisp=#99D59D

    hi MyLspCursorWord ctermbg=242 guibg=#383029
    hi link LspReferenceText  MyLspCursorWord
    hi link LspReferenceRead  MyLspCursorWord
    hi link LspReferenceWrite MyLspCursorWord

    " this is melange background color
    hi Background guifg=#2A2520
    " Whitespace is #4D453E
    hi IndentGuide guifg=#3A3029
endfunction
call s:my_highlights()
" Show nine spell checking candidates at most
set spellsuggest=best,9

noremap <M-+> :call AdjustFontSize(1)<CR>
noremap <M-_> :call AdjustFontSize(-1)<CR>

augroup my_syntax
    au!
    " Indent sizes
    " nocheckin fix this, vim stil uses 4 spaces
    autocmd Filetype vim             setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
    autocmd Filetype python          setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
    autocmd Filetype go              setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
    autocmd Filetype java            setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
    autocmd Filetype markdown        setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
    autocmd Filetype tex             setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
    autocmd Filetype json            setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
    autocmd Filetype typescript      setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
    autocmd Filetype typescriptreact setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

    " Use my highlights for these languages
    autocmd Filetype java             setlocal syntax=java
    " autocmd Filetype typescript       setlocal syntax=typescript
    " autocmd Filetype typescriptreact  setlocal syntax=typescript

    autocmd BufNewFile,BufRead *.ts  set syntax=typescript
    autocmd BufNewFile,BufRead *.tsx set syntax=typescriptreact


    autocmd FileType cpp setlocal commentstring=//\ %s

    " Custom switch definitions
    autocmd FileType java let b:switch_custom_definitions =  [
        \   {
        \     '\.\(get\)\@!\(\k\)\(\k*\)\>': '\.get\u\2\3\(\)',
        \     '\.\get\(\k\)\(\k*\)\>()':     '.\l\1\2',
        \   }
        \ ]
augroup end

set noshowmode                          " don't show because of airline
set signcolumn=yes " column to show diagnostics and not appear and disappear
" Give more space for displaying messages.
set cmdheight=2     " Try now and maybe remove later.

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

" Lua utils
lua << EOF
-- easily print lua table
P = function(thing)
    print(vim.inspect(thing))
    return thing
end
EOF

" ----- Plugin specific mappings -----

" ----- Airline -----
" Airline theme should be automatically selected.
" let g:airline_theme = 'base16_espresso'
" let g:airline_theme = 'minimalist'
" let g:airline_theme = 'monochrome'
" let g:airline_theme = 'term'
let g:airline_theme = 'tomorrow'
" let g:airline_theme = 'transparent'
let g:airline_stl_path_style = 'short'
let g:airline_section_c_only_filename = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
" let g:airline#extensions#tabline#left_sep = ' '
" let g:airline#extensions#tabline#left_alt_sep = '|'

function! s:update_highlights()
    " For tomorrow airline theme
    "hi airline_tab guifg=#4D453E
    hi airline_tab guifg=#9D958E
endfunction
autocmd User AirlineAfterTheme call s:update_highlights()
command! BufMessages execute 'Bufferize messages'

" --- Indent blank line ---
lua<<EOF
vim.g.indent_blankline_show_trailing_blankline_indent = false
vim.g.indent_blankline_show_first_indent_level = false
vim.g.indent_blankline_use_treesitter = true
vim.g.indent_blankline_buftype_exclude = {
"nofile",
"terminal",
"lsp-installer",
"lspinfo",
}
vim.g.indent_blankline_filetype_exclude = {
    "nerdtree",
    "help",
    "startify"
}
require("indent_blankline").setup {
    indent_blankline_use_treesitter = true,
    char_highlight_list = {
        "IndentGuide",
        "IndentGuide",
        "IndentGuide",
        "IndentGuide",
        "IndentGuide",
        "IndentGuide",
        "IndentGuide",
        "IndentGuide",
        "IndentGuide",
        "IndentGuide",
    },
}
EOF

" --- Git ---
" https://dpwright.com/posts/2018/04/06/graphical-log-with-vimfugitive/
command! -nargs=* Glg Git! log --graph --abbrev-commit --decorate --format=format:'%s %C(bold yellow)%d%C(reset) %C(bold green)(%ar)%C(reset) %C(dim white)<%an>%C(reset) %C(bold blue)%h%C(reset)' --all<args>

" --- Telescope ---
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

-- This is not needed, since Telescope does this by default with find_files
--Home_git = vim.fn.fnamemodify(vim.fn.expand('$homepath/.git'), ':p'):gsub("\\", "/"):sub(1, -2)
--Project_files = function(theme)
--    local current_git_dir = vim.fn.fnamemodify(vim.fn.system('git rev-parse --absolute-git-dir'), ':p')
--    local view = {}
--    if theme == "files_only" then
--      view = require('telescope.themes').get_dropdown{ previewer = false }
--    end
--
--    if current_git_dir ~= "" then
--        current_git_dir = current_git_dir:gsub("\n", "")
--        if current_git_dir ~= Home_git then
--            require'telescope.builtin'.git_files(view)
--            return
--        end
--    end
--    require'telescope.builtin'.find_files(view)
--end
--vim.api.nvim_set_keymap('n', '<leader>f', '<cmd>lua Project_files("files_only")<cr>', {})
--vim.api.nvim_set_keymap('n', '<leader>F', '<cmd>lua Project_files()<cr>', {})
EOF

" --- Fuzzy search ---

" FIles
nnoremap <leader>f <cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{ previewer = false })<cr>
nnoremap <leader>F <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader><Tab> <cmd>lua require('telescope.builtin').oldfiles(require('telescope.themes').get_dropdown{ previewer = false })<cr>

" Search in files
nnoremap <leader>/ <cmd>Telescope live_grep<cr>
nnoremap <leader>? <cmd>lua require('telescope.builtin').grep_string { search = vim.fn.input("Grep for ") } <cr>


" Maybe temporary mappings
" May change this mappind. <leader>g can have multiple key mappings, since it's easy to press.
nnoremap <leader>gm <cmd>Telescope marks<cr>
nnoremap <leader>gH <cmd>Telescope help_tags<cr>
nnoremap <leader>gh <cmd>Telescope highlights<cr>
nnoremap <leader>g, <cmd>Telescope resume<cr>
nnoremap <leader>gb <cmd>Telescope git_branches<cr>

" Quickly go to some my config file
command! Dotfiles :lua require('telescope.builtin').git_files { cwd = '~' } <cr>

" Telescope colorscheme is anther useful one.


" ----- Nerdtree -----
nnoremap <C-n> <cmd>NERDTreeToggle<CR>
" TODO: Create a lua function which finds the last visited buffer.
nnoremap <leader>r <cmd>NERDTreeFind<CR>
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeShowHidden=1                    " Show hidden files
let g:NERDTreeWinPos = "right"
let NERDTreeQuitOnOpen=1
let g:NERDTreeWinSize=50           " Maybe do this just for some file types.
" Refresh devicons so nerdtree does not show [] around icons
if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif
augroup my_nerdtree
  au!
  " Exit Vim if NERDTree is the only window remaining in the only tab.
  autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
  " Close the tab if NERDTree is the only window remaining in it.
  autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
augroup end

" --- Undo tree ---
nnoremap <leader>u <cmd>UndotreeToggle<cr>
set undodir=~/.vim/undodir
set undofile
"let g:undotree_WindowLayout = 2  " bigger diff window
let g:undotree_ShortIndicators = 1
"let g:undotree_SetFocusWhenToggle = 0  " set focus on undotree

" --- Git gutter ---
let g:gitgutter_signs = 0
nnoremap <leader>hh <cmd>GitGutterSignsToggle<cr>

" --- Goyo ---
nnoremap <leader>z <cmd>Goyo<cr>
let g:goyo_linenr=1
let g:goyo_width=120
augroup my_goyo
    au!
    autocmd! User GoyoLeave nested call <SID>my_highlights()
augroup end

" --- Ultisnips ---
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-tab>"
let g:UltiSnipsEditSplit="tabdo"

" --- close tag ---
let g:closetag_filenames = '*.html,*.xhtml,*.jsx,*.tsx'
let g:closetag_xhtml_filenames = '*.xml,*.xhtml,*.jsx,*.tsx'
let g:closetag_filetypes = 'html,xhtml,jsx,tsx'
let g:closetag_xhtml_filetypes = 'xhtml,jsx,tsx,typescriptreact,typescript'
let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_regions = {
    \ 'typescriptreact': 'jsxRegion,tsxRegion',
    \ 'javascriptreact': 'jsxRegion',
    \ }
let g:closetag_shortcut = '>'
let g:closetag_close_shortcut = '<leader>>'

"--- Nvim treesitter ---
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "c", "cpp", "java", "javascript", "typescript", "tsx", "css", "html" },
  highlight = {
    enable = true,
    disable = { "kotlin" }, -- kotlin syntax highlight does not work correctly.
  },
  context_commentstring = {
    enable = true
  },
  playground = {
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
" Use <c-space> to trigger completion.
" inoremap <silent><expr> <c-space> coc#refresh()

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
"                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" let g:coc_suggest_disable = 1

" - Mappings -

" Diagnostic navigation
" nmap <silent> [g <Plug>(coc-diagnostic-prev)
" nmap <silent> ]g <Plug>(coc-diagnostic-next)
" nmap <silent> [e <Plug>(coc-diagnostic-prev-error)
" nmap <silent> ]e <Plug>(coc-diagnostic-next-error)
" nnoremap <silent><nowait> <leader>]g  :<C-u>CocList diagnostics<cr>

" " Code syntax tree operations
" nmap <silent> gd <Plug>(coc-definition)
" " Maybe I'll use this, if not remove
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> ga <Plug>(coc-references)
" nmap <silent> gm <Plug>(coc-rename)

" " Quick fixes
" " Using e not q, because Q is used for fast quit.
" nnoremap <leader>e <cmd>CocFix<CR>
" nmap <leader>E <plug>(coc-fix-current)

" nmap <leader>l  <Plug>(coc-format-selected)
" nmap <leader>L <Plug>(coc-format)
" vmap <leader>l  <Plug>(coc-format-selected)

" nnoremap <leader>o <cmd>call CocAction('runCommand', 'editor.action.organizeImport')'<CR>

" " Use K to show documentation in preview window.
" nnoremap <silent> K <cmd>call <SID>show_documentation()<CR>

" function! s:show_documentation()
"   if (index(['vim','help'], &filetype) >= 0)
"     execute 'h '.expand('<cword>')
"   elseif (coc#rpc#ready())
"     call CocActionAsync('doHover')
"   else
"     execute '!' . &keywordprg . " " . expand('<cword>')
"   endif
" endfunction

" " CodeActions

" " Apply codeAction to the selected region.
" xmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>a  <Plug>(coc-codeaction-selected)
" " Apply codeAction to the current buffer.
" nmap <leader>A  <Plug>(coc-codeaction)

" " Map function and class text objects
" " " NOTE: Requires 'textDocument.documentSymbol' support from the language
" " server.
" xmap if <Plug>(coc-funcobj-i)
" omap if <Plug>(coc-funcobj-i)
" xmap af <Plug>(coc-funcobj-a)
" omap af <Plug>(coc-funcobj-a)
" xmap ic <Plug>(coc-classobj-i)
" omap ic <Plug>(coc-classobj-i)
" xmap ac <Plug>(coc-classobj-a)
" omap ac <Plug>(coc-classobj-a)

" " Remap <C-f> and <C-b> for scroll float windows/popups.
" if has('nvim-0.4.0') || has('patch-8.2.0750')
"   nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"   nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"   inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
"   inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
"   vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"   vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
" endif

" " Use CTRL-S for selections ranges.
" " Requires 'textDocument/selectionRange' support of language server.
" " TODO: Delete if I won't use it.
" nmap <silent> <C-s> <Plug>(coc-range-select)
" xmap <silent> <C-s> <Plug>(coc-range-select)

"augroup my_current_word_highlight
"    " Highlight the symbol and its references when holding the cursor.
"    autocmd CursorHold * silent call CocActionAsync('highlight')
"    "use to change color of current word highlight IngoMeyer441/coc_current_word
"augroup end


" - Other settings -

" Adds commands from COC
" command! -nargs=0 Format <cmd>call CocAction('format')
" command! -nargs=? Fold <cmd>call CocAction('fold', <f-args>)
" command! -nargs=0 OptimizeImports <cmd>call CocAction('runCommand', 'editor.action.organizeImport')'

" augroup signiturehelp
"   autocmd!
  " Update signature help on jump placeholder.
  " autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
" augroup end

" command! Coc execute 'echo coc#status()'
" set statusline^=%{coc#status()}
" let g:airline#extensions#coc#enabled = 1
" let g:airline#extensions#coc#show_coc_status = 1

" command! JavaProjektImport CocCommand java.projectConfiguration.update


" ----- Golang ------

let g:go_def_mapping_enables = 0  " use gd from LSP
let g:go_doc_keywordprg_enabled = 0 " use K from LSP

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



" ----- Native lsp -----

set completeopt=menu,menuone,noselect,noinsert
" set omnifunc=''
" inoremap <C-space> <Cmd>lua require('cmp').complete()<CR>
" inoremap <C-n> <Cmd>lua require('cmp').complete()<CR>


nnoremap <silent> [d <cmd>lua vim.diagnostic.goto_prev()<cr>
nnoremap <silent> ]d <cmd>lua vim.diagnostic.goto_next()<cr>
nnoremap <silent> [D <cmd>lua vim.diagnostic.open_float()<cr>
nnoremap <silent> ]D <cmd>lua vim.diagnostic.setloclist()<cr>
nnoremap <silent> [e <cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<cr>
nnoremap <silent> ]e <cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<cr>
lua <<EOF
Lsp_on_attach = function (client, bufnr)

  local opts = { noremap=true, silent=true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)

  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K',  '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'ga', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gm', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-m>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>L', '<cmd>lua vim.lsp.buf.formatting()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>l', '<cmd>lua vim.lsp.buf.range_formatting()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'v', '<leader>l', '<cmd>lua vim.lsp.buf.range_formatting()<cr>', opts)

  -- what does this mean/do ?
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

  if client.resolved_capabilities.document_highlight then
    if client.name ~= "vimls" then
      vim.api.nvim_exec(
        [[
        augroup lsp_document_highlight
          autocmd! * <buffer>
          autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
          autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
      ]],
        false
      )
    end
  end

  --if client.name == "tsserver" then
    --P(client.resolved_capabilities.code_action.codeActionKinds)
  --end
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.lsp.buf.code_action({ only = "quickfix"})<cr>', opts)
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>E', '<cmd>lua vim.lsp.buf.range_code_action({ only = "quickfix"})<cr>', opts)

end


local lsp_installer = require("nvim-lsp-installer")

lsp_installer.on_server_ready(function(server)
  local config = { on_attach = Lsp_on_attach }
  config = coq.lsp_ensure_capabilities(config)

  if server.name == "tsserver" then
    local ts_config = {
      handlers = {
        ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
            if result ~= nil and result.diagnostics ~= nil then
              -- Do not report React is unused import.
              local isTsx = result.uri:sub(-#"tsx") == "tsx"
              if isTsx then
                for i, diag in ipairs(result.diagnostics) do
                  if diag.message == "'React' is declared but its value is never read." then
                      table.remove(result.diagnostics, i)
                  end

                end
              end
            end
          vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
        end,
        -- nocheckin remove
        -- TODO: create code action with only quick fix items, but each lsp has it's own kind's.
        --["textDocument/codeAction"] = function(err, result, ctx, ...)
            --print('code action called'
            --P(result)
            --P(ctx)
            --vim.lsp.buf.code_action(err, result, ctx, ...)
        --end
      }
    }
    config = vim.tbl_deep_extend("force", ts_config, config)
  end

  server:setup(config)
end)

-- Setup ccls manually since, lsp-installer does not support it on windows (even though it works).
local lspconfig = require'lspconfig'
-- ccls uses cmake or .ccls file to recognize sources
lspconfig.ccls.setup {
  filetypes = {"c", "cpp", "cuda", "objc", "objcpp"},
  rootPatterns = { "compile_commands.json", ".ccls-root", ".ccls", ".git"},
  ls_ranges = true,
  init_options = {
    cache = {
      directory = "C:\\tools\\ccls\\.ccls_cache"
    },
    client = {
      snippet_support = true
    },
    index = { on_change = true },
    highlight = { ls_ranges = true }
  },

  on_attach = Lsp_on_attach
}


-- Diagnostics
local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}
for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

local config = {
  virtual_text = false,
  signs = {
    active = signs,
  },
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    --style = "minimal",
    border = "rounded",
    --source = false,
    source = "always",
    header = "",
    prefix = "",
  },
}
vim.diagnostic.config(config)
EOF


" nocheckin continue:
"  remove coc comments

lua <<EOF
local kind_icons = {
  Text = "",
  Method = "m",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}

vim.g.coq_settings = {
  auto_start = true,
  keymap = {
    recommended = false,
    pre_select = false,
    jump_to_mark = "<c-,>"
    --bigger_preview = "<C-k>"
  }, -- use the recommended keymap
  -- auto trigger completion
  -- Did not find a seeting to change replace on confirm behaviour.
  completion = { always = true, smart = true },
  display = {
    ghost_text = { enabled = false },
    pum = {
      ellipsis = ".. ",
      kind_context = {"", ""},
      source_context = {"[", "]"},
    },
    preview = { border = "rounded" },
    icons = { mode = "short", spacing = 1, mappings = kind_icons },
  },
  clients = {
    lsp = { short_name = "lsp", weight_adjust = 1.5 },
    snippets = { enabled = true, short_name = "snip", weight_adjust = 1.2 },
    paths = { short_name = "path", path_seps = { "/" } }, -- always use / even in Windows
    buffers = { short_name = "buf" },
    tree_sitter = { enabled = false, short_name = "ts", weight_adjust = -2},
    --snippets = { user_path = "~/.vim/snip"} -- put here custom snippets
  }
}
EOF
" 🐓 Coq completion settings
ino <silent><expr> <Esc>   pumvisible() ? "\<C-e><Esc>" : "\<Esc>"
ino <silent><expr> <C-c>   pumvisible() ? "\<C-e><C-c>" : "\<C-c>"
ino <silent><expr> <BS>    pumvisible() ? "\<C-e><BS>"  : "\<BS>"
ino <silent><expr> <CR>    pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"
command! COQmySnipEdit execute 'tabe ~/.vim/plugged/coq_nvim/.vars/clients/snippets/users+v2.json'

" hi link CmpItemAbbr Normal
" hi link CmpItemKind Label
" hi link CmpItemMenu Ignore
" nocheckin experiment
lua <<EOF
-- local on_attach = function(client, bufnr)
--   -- Enable completion triggered by <c-x><c-o>
--   vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
--
--   -- Mappings.
--   -- See `:help vim.lsp.*` for documentation on any of the below functions
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
-- end
-- local servers = {'jdtls'}
-- for _, lsp in pairs(servers) do
--   require('lspconfig')[lsp].setup {
--     on_attach = on_attach,
--   }
-- end
EOF

" nocheckin make sure everything in this config works the same
"{
"    "languageserver": {
"        "goLS": {
"           "command": "gopls",
"            "rootPatterns": ["go.mod", ".vim/", ".git/", ".hg/"],
"            "filetypes": ["go"]
"        },
"        "elmLS": {
"            "command": "elm-language-server.cmd",
"            "filetypes": ["elm"],
"            "rootPatterns": ["elm.json"],
"            "initializationOptions": {
"                "elmPath": "elm",
"                "elmFormatPath": "elm-format",
"                "elmTestPath": "elm-test",
"                "elmReviewPath": "elm-review",
"                "disableElmLSDiagnostics": false,
"                "skipInstallPackageConfirmation": false,
"                "onlyUpdateDiagnosticsOnSave": false
"            }
"        },
"        "ccls": {
"          "command": "ccls",
"          "filetypes": ["c", "cpp", "cuda", "objc", "objcpp"],
"          "rootPatterns": [".ccls-root", "compile_commands.json"],
"          "initializationOptions": {
"            "cache": {
"              "directory": "C:\\tools\\ccls\\.ccls_cache"
"            },
"            "client": {
"              "snippetSupport": true
"            },
"            "index": { "onChange": true },
"            "highlight": { "lsRanges" : true }
"          }
"        }
"    },
"    "java.configuration.runtimes": [
"      {
"        "name": "JavaSE-11",
"        "path": "C:\\Program Files\\Java\\jdk-11.0.2",
"        "default": true
"      },
"      {
"        "name": "JavaSE-14",
"        "path": "C:\\Program Files\\Java\\jdk-14.0.2"
"      }
"    ],
"    "suggest.echodocSupport": true,
"    "suggest.enablePreselect": false,
"    "suggest.autoTrigger": "trigger",
"    "signature.enable": true,
"    "java.format.settings.url": "https://raw.githubusercontent.com/xholym/dotfiles/master/.vim/eclipse-formatter.xml",
"    "java.completion.favoriteStaticMembers": [
"        "*"
"    ],
"    "java.signatureHelp.enabled": true,
"    "java.enabled": true,
"    "java.trace.server": "verbose",
"    "java.jdt.ls.vmargs": "-javaagent:C:\\tools\\lombok.jar"
"}
