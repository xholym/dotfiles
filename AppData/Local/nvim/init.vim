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
" TODO: Configure java debug.
" TODO: Consider lsp status line
" TODO: Remap :diffget //2 and diffget //3
" TODO: Fix java formatting settings.
"
"
" Notes:
" Im writing this down, cause it help me to remember these mappings and use them.
"
" In nerdtree:
" p     - go to parent
"

" Bugs_or_Restrictions:
"
" Gradle annotation processing does not work by default.
" It must be configured in build.gradle of project with plugin 'net.ltgt.apt-eclipse'.
"
" Starting neovim from gitbash breaks terminal.
" See https://github.com/neovim/neovim/issues/14605
"
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
Plug 'junegunn/vim-easy-align'

" Textobjects
Plug 'kana/vim-textobj-user'         " dependency of textobj-entire
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-line'
Plug 'wellle/targets.vim'       " adds more textobjects like args, separators (, . /) and so on
" Plug 'vim-scripts/argtextobj.vim'    " reconsider using intead of targets argtextobj

" Changes to behaviour
Plug 'machakann/vim-highlightedyank'
Plug 'tpope/vim-speeddating'         " <C-a> increment for dates and such, vim not seeing '-' as minus
Plug 'karb94/neoscroll.nvim'

Plug 'windwp/nvim-autopairs'
Plug 'AndrewRadev/bufferize.vim' " put command output in tmp buffer
Plug 'windwp/nvim-ts-autotag'

" Themes
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'norcalli/nvim-colorizer.lua'
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
"Plug 'ivalkeen/nerdtree-execute'

" Distraction free mode
Plug 'junegunn/goyo.vim'

" Fuzzy finder
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'                    " telescope requirement
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' } " better sort and search
Plug 'kyazdani42/nvim-web-devicons'  " devicons for telescope

Plug 'mbbill/undotree'

Plug 'akinsho/toggleterm.nvim'

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

Plug 'tami5/lspsaga.nvim', {'branch' : 'nvim6.0'}

" latest release has an utf encoding bug
Plug 'ms-jpq/coq_nvim', {'branch': 'coq' }
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
    hi MyIdentifier ctermfg=LightMagenta guifg=#B075A5
    hi link yamlTSField MyIdentifier
    hi link elmType MyIdentifier
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

    hi link htmlArg Normal

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
    hi FloatBorder guifg=#8D857E
    hi link LspSagaCodeActionBorder FloatBorder
    hi link LspSagaRenameBorder FloatBorder
    hi link LspSagaCodeActionTitle Statement
    " This is PreProc collor
    hi LspSagaCodeActionContent gui=bold guifg=#99D59D

    hi link SelectionBracket Delimiter
    hi link SelectionIndex Number
endfunction
call s:my_highlights()
" Show nine spell checking candidates at most
set spellsuggest=best,10

noremap <M-+> :call AdjustFontSize(1)<CR>
noremap <M-_> :call AdjustFontSize(-1)<CR>

augroup my_syntax
    au!
    " Indent sizes
    " TODO: fix this, vim stil uses 4 spaces
    autocmd Filetype lua             setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
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
nmap z+ 1z=

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
R = function(module)
  require("plenary.reload").reload_module(module)
  return require(module)
end
EOF

" ----- Plugin specific mappings -----

" ----- Selection ----
lua << EOF
local selection = require'selection'
function Select_spell_suggestion()
  local cursor_word = vim.fn.expand "<cword>"
  local spellsuggest = vim.api.nvim_get_option('spellsuggest')
  local max = nil
  if spellsuggest then
    local matches = string.gmatch(spellsuggest, "%s*,([^,]+)")
    for match in matches do
      max = match
      break -- we just want the first match
    end
  end
  local suggestions = vim.fn.spellsuggest(cursor_word, max)

  if limit then
    -- (safely) remove items above limit
    for i=#suggestions,1,-1 do
      if i <= limit then
        break
      end
      table.remove(suggestions, i)
    end
  end

  P(sugg)
  local on_select = function (_, suggestion)
    vim.cmd("normal! ciw" .. suggestion)
    vim.cmd "stopinsert"
  end
  selection.open(suggestions, on_select)
end
EOF
nnoremap z= <cmd>lua Select_spell_suggestion()<cr>

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

" --- Colorizer ---
lua << EOF
require'colorizer'.setup()
EOF
" --- Neoscroll ---
" smooth scrolling
lua << EOF
require('neoscroll').setup()
-- speed it up compared to defaults.
require('neoscroll.config').set_mappings({
  ['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '30'}},
  ['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '30'}},
  ['<C-b>'] = {'scroll', {'-vim.api.nvim_win_get_height(0)', 'true', '60'}},
  ['<C-f>'] = {'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '60'}},
  ['<C-y>'] = {'scroll', {'-0.10', 'false', '5'}},
  ['<C-e>'] = {'scroll', { '0.10', 'false', '5'}},
  ['zt']    = {'zt', {'20'}},
  ['zz']    = {'zz', {'20'}},
  ['zb']    = {'zb', {'20'}}
})
EOF
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
" --- Autopairs ---
lua << EOF
require('nvim-autopairs').setup({
  check_ts = true,
  ts_config = {
    lua = { "string", "source" },
    javascript = { "string", "template_string" },
    java = false,
  },
})
EOF
" --- Autotags ---
lua << EOF
require('nvim-ts-autotag').setup()
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
command! Dotfiles execute 'lua require("telescope.builtin").git_files { cwd = "~" }'

command! Nocheckin silent execute 'Ggrep nocheckin'
command! Nch silent execute 'Ggrep nocheckin'

" --- Startify ---
command! SQuit execute 'SClose | qa'

" --- EasyAlign ---
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" ----- Nerdtree -----
nnoremap <C-n> <cmd>NERDTreeToggle<CR>
" TODO: Create a lua function which finds the last visited buffer.
nnoremap <leader>n <cmd>NERDTreeFind<CR>
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

" unmap nerdtree execute, it's only needed in menu
" Do not use nvim Netrw plugin explorer
let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1

" --- Undo tree ---
nnoremap <leader>u <cmd>UndotreeToggle<cr><cmd>UndotreeFocus<cr>
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

" --- Toggle terminal ---
lua << EOF
require("toggleterm").setup{
  open_mapping = [[<c-t>]],
  shell = 'C:\\tools\\bash.exe',
  direction = 'float',
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.45
    else
      return 20
    end
  end,
  float_opts = {
    border = "curved",
    highlights = {
      border = "FloatBorder",
      background = "DarkenedPanel",
    },
  },
}
function _G.set_terminal_keymaps()
  local opts = {noremap = true}
  vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-v>', [[<C-\><C-n>"*pa]], opts)
  -- TODO: add copy mapping
end
EOF
augroup my_term
    au!
    autocmd TermEnter term://*toggleterm#*
          \ tnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
    autocmd! TermOpen term://* lua set_terminal_keymaps()
augroup end
command! Tt execute 'ToggleTerm direction=tab'
command! Tf execute 'ToggleTerm direction=float'
command! Tv execute 'ToggleTerm direction=vertical'
command! Th execute 'ToggleTerm direction=horizontal'

" --- Ultisnips ---
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-tab>"
let g:UltiSnipsEditSplit="tabdo"

"--- Nvim treesitter ---
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "c", "cpp", "java", "javascript", "typescript", "tsx", "css", "html" },
  highlight = {
    enable = true,
    disable = { "kotlin" }, -- kotlin syntax highlight does not work correctly.
  },
  indent = {
    enable = true
  },
  context_commentstring = {
    enable = true
  },
  playground = {
    enable = true
  }
}
EOF

" Buffers can stay hidden in background after closing, good for lsps.
set hidden
" Don't show annoying completion messages on autocompletion.
set shortmess+=c


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


" ----- Lsp saga ----
lua << EOF
-- Do not use Lspsaga lspfinder, it's broken.
local saga = require 'lspsaga'
saga.init_lsp_saga({
  border_style = "round",
  use_saga_diagnostic_sign = false,
  diagnostic_header_icon = "   ",
  code_action_icon = " ",
  code_action_prompt = {
    enable = false,
    --sign = false,
    --sign_priority = 40,
    --virtual_text = false,
  },
  code_action_keys = { quit = {"q", "<ESC>"}, exec = "<CR>", },
  rename_prompt_prefix = "",
  rename_output_qflist = { enable = true },
  rename_action_keys = { quit = "<C-c>", exec = "<CR>", },
  finder_action_keys = {
    quit = {"q", "<ESC>"},
    open = "o",
    vsplit = "s",
    split = "i",
    quit = "q",
    scroll_down = "<C-f>",
    scroll_up = "<C-b>",
  }
})
EOF

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
--local telescope = require'telescope.builtin'
--local view = require('telescope.themes').get_ivy()
--function Lsp_references_in_telescope()
--  local request = vim.lsp.util.make_position_params()
--  request.context = { includeDeclaration = false }
--
--  vim.lsp.buf_request(0, "textDocument/references", request, function (err, result, ctx, config)
--    if err then
--      print 'TextDocument/references returned an error'
--      P(err)
--      return
--    end
--    if not result then
--      print 'TextDocument/references returned no result'
--      return
--    end
--    local locations = vim.lsp.util.locations_to_items(result, vim.lsp.get_client_by_id(ctx.client_id).offset_encoding) or {}
--    vim.fn.setqflist(locations, 'r')
--
--    view.on_complete = { function() vim.cmd"stopinsert" end }
--    telescope.quickfix(view)
--  end)
--
--end

Lsp_on_attach = function (client, bufnr)
  print("Attaching", client.name, "lsp")

  local opts = { noremap=true, silent=true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)

  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K',  '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gx', '<cmd>lua vim.lsp.buf.references({includeDeclaration = false})<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gm', '<cmd>Lspsaga rename<cr>', opts) -- TODO: also rewrite this
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-S-K>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>l', '<cmd>lua vim.lsp.buf.formatting()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>L', '<cmd>lua vim.lsp.buf.range_formatting()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'v', '<leader>L', '<cmd>lua vim.lsp.buf.range_formatting()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>a', '<cmd>lua require("lspops").list_code_actions()<cr>', opts)


  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q', '<cmd>lua require("lspops").run_fix()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>Q', '<cmd>lua require("lspops").list_code_actions({only = {"quickfix"}})<cr>', opts)

  -- what does this mean/do ?
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

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
    local ts_cfg = {
      handlers = {
        ["textDocument/publishDiagnostics"] = function(err, result, ctx, hconfig)
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
          local handler = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = false,
          })

          handler(err, result, ctx, hconfig)
        end,
        -- TODO: create code action with only quick fix items, but each lsp has it's own kind's.
        --["textDocument/codeAction"] = function(err, result, ctx, ...)
            --print('code action called'
            --P(result)
            --P(ctx)
            --vim.lsp.buf.code_action(err, result, ctx, ...)
        --end
      }
    }
    config = vim.tbl_deep_extend("force", ts_cfg, config)
  elseif server.name == "elmls" then
    local elm_cfg = {
      command = "elm-language-server.cmd",
      filetypes = {"elm"},
      root_patterns = {"elm.json"},
      initialization_options = {
        elm_path = "elm",
        elm_format_path = "elm-format",
        elm_test_path = "elm-test",
        elm_review_path = "elm-review",
        disable_elmls_diagnostics = false,
        skip_install_package_confirmation = false,
        only_update_diagnostics_on_save = false
      }
    }
    config = vim.tbl_deep_extend("force", elm_cfg, config)
  elseif server.name == "sumneko_lua" then
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")
    local lua_cfg = {
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
            path = runtime_path,
            unicode_name = false
          },
          diagnostics = { globals = {'vim', 'P', 'R'}, },
          workspace = { library = vim.api.nvim_get_runtime_file("", true), },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = { enable = false, },
        },
      },
      hanlders = {
        ["textDocument/hover"] = function (err, result, ctx, cfg)
          P(result)
          vim.lsp.with(vim.lsp.handlers.hover, {
              border = "rounded",
            })
          end
      }
    }
    config = vim.tbl_deep_extend("force", lua_cfg, config)
    -- TODO texlab
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

-- Global handlers
-- Make border arount these floats.
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
})
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = false,
})

-- Diagnostics
local config = {
  virtual_text = false,
  signs = {
    active = {
      { name = "DiagnosticSignError", text = "" },
      { name = "DiagnosticSignWarn", text = "" },
      { name = "DiagnosticSignHint", text = "" },
      { name = "DiagnosticSignInfo", text = "" },
    },
  },
  underline = true,
  severity_sort = true,
  --update_in_insert = true,
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
for _, sign in ipairs(config.signs.active) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

vim.diagnostic.config(config)
EOF


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
    buffers = { enabled = true, short_name = "buf" },
    tree_sitter = { enabled = false, short_name = "ts", weight_adjust = -2},
    --snippets = { user_path = "~/.vim/snip"} -- put here custom snippets
  }
}
-- TODO this causes bugs
-- I don't know why this is needed, it breaks stuff like:
-- press of " on ) does not insert and also other way around.
-- Make <CR> and <BS> to work with autopairs
--_G.MUtils= {}

--local npairs = require('nvim-autopairs')
--MUtils.CR = function()
--  if vim.fn.pumvisible() ~= 0 then
--    if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
--      return npairs.esc('<c-y>')
--    else
--      return npairs.esc('<c-e>') .. npairs.autopairs_cr()
--    end
--  else
--    return npairs.autopairs_cr()
--  end
--end
--
--MUtils.BS = function()
--  if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ 'mode' }).mode == 'eval' then
--    return npairs.esc('<c-e>') .. npairs.autopairs_bs()
--  else
--    return npairs.autopairs_bs()
--  end
--end
EOF
" 🐓 Coq completion settings
"inoremap <expr> <cr> v:lua.MUtils.CR()
"inoremap <expr> <bs> v:lua.MUtils.BS()
ino <silent><expr> <BS>    pumvisible() ? "\<C-e><BS>"  : "\<BS>"
ino <silent><expr> <CR>    pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"
command! COQmySnipEdit execute 'tabe ~/.vim/plugged/coq_nvim/.vars/clients/snippets/users+v2.json'

