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
"
"
" Todos:
" TODO: fix undercurl
" TODO: Configure java debug.
" TODO: Remap :diffget //2 and diffget //3
" TODO: Fix java formatting settings.
"
"
" Notes:
" Im writing this down, cause it help me to remember these mappings and use them.
"

" Bugs_or_Restrictions:
"
" Gradle annotation processing does not work by default.
" It must be configured in build.gradle of project with plugin 'net.ltgt.apt-eclipse'.
"
" Starting neovim from gitbash breaks terminal.
" See https://github.com/neovim/neovim/issues/14605
"

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

filetype plugin indent on

set autowrite


" ----- Plugins -----

call plug#begin('~/.vim/plugged')    " initialize plugin system

" Changes to behaviour
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'         " make surround repeatable with .
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'numToStr/Comment.nvim'
" Plug 'justinmk/vim-sneak'     " add after I'm good with f/t
Plug 'AndrewRadev/switch.vim'
Plug 'junegunn/vim-easy-align'
Plug 'kana/vim-textobj-user'         " dependency of textobj-entire
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-line'
Plug 'wellle/targets.vim'       " adds more textobjects like args, separators (, . /) and so on
" Plug 'vim-scripts/argtextobj.vim'    " reconsider using intead of targets argtextobj
Plug 'michaeljsmith/vim-indent-object'
Plug 'machakann/vim-highlightedyank'
Plug 'windwp/nvim-autopairs'
Plug 'windwp/nvim-ts-autotag'

Plug 'AndrewRadev/bufferize.vim' " put command output in tmp buffer

" Tried both smooth scrolling plugins, both are slow in large files.
" They lagged a lot in my master thesis in latex - +2000 lines file.
Plug 'karb94/neoscroll.nvim'

" Themes
Plug 'nvim-lualine/lualine.nvim'
"Plug 'rafi/awesome-vim-colorschemes'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'savq/melange'
Plug 'mhinz/vim-startify'       " better info about buffer change in statusline
Plug 'lukas-reineke/indent-blankline.nvim'

" Git
Plug 'tpope/vim-fugitive' " rival is https://github.com/lewis6991/gitsigns.nvim
Plug 'lewis6991/gitsigns.nvim'
Plug 'junegunn/gv.vim'

" Working directory navigation
Plug 'ryanoasis/vim-devicons'
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ivalkeen/nerdtree-execute'

" Zen mode
Plug 'folke/zen-mode.nvim' " junegunn/goyo.vim is slowers on quit, because of highlights restoring

" Fuzzy finder
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'                    " telescope requirement
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' } " better sort and search
Plug 'kyazdani42/nvim-web-devicons'  " devicons for telescope

Plug 'mbbill/undotree'

Plug 'akinsho/toggleterm.nvim'

Plug 'folke/trouble.nvim'

Plug 'lewis6991/impatient.nvim' " improve staruptime by caching lua modules

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'ElmCast/elm-vim' " better syntax highliging
Plug 'udalov/kotlin-vim'
Plug 'lervag/vimtex'
"Plug 'jackguo380/vim-lsp-cxx-highlight' " TODO: maybe delete this, it may not be needed since I have treesitter
" More syntax highlighting.
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/playground'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'  " set commentstring base on treesitter context

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'mfussenegger/nvim-jdtls'


Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'
" Not using COQ, because in lua it throws utf8 errors and does not work with . (repeat).
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/nvim-cmp'
Plug 'saadparwaiz1/cmp_luasnip'

call plug#end()

" ------ Highlighting --------
"
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
if (has("termguicolors"))
   set termguicolors
endif

set colorcolumn=80

function! s:my_highlights()
    " Disable italics for melange colorscheme
    hi Comment gui=NONE
    hi String gui=NONE
    hi Todo gui=NONE
    hi TSVariableBuiltin gui=NONE
    hi TSConstBuiltin gui=NONE

    "hi Search guifg=#2A2520 guibg=#8E733F " default
    hi Search guifg=#2A2520 guibg=#BEA35F

    "hi Comment ctermfg=Green guifg=Green
    " consider String color change for melange
    " hi String ctermfg=DarkGreen guifg=#69764D

    " For melange colorscheme
    " hi Function guifg=#EBC06D " This is the default fo melange
    " hi Function guifg=#FFE88D
    hi Function guifg=#FFDFAA
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
    hi link typescriptCall Normal

    hi link htmlArg Normal

    hi clear SpellBad
    " Default spellbad colloring.
    " hi SpellBad cterm=underline ctermfg=204 gui=underline guifg=#E06C75
    hi SpellBad cterm=underline gui=underline

    " Use same colors as DiagnosticError / DiagnosticWarn and so on.
    " Nvim-qt does not render unercurl correctly, checkout their 2.17 release, it should be fixed there
    hi DiagnosticUnderlineError guisp=#B65C60 gui=underline
    hi DiagnosticUnderlineWarn guisp=#EBC06D gui=underline
    hi DiagnosticUnderlineInfo guisp=#9AACCE gui=NONE guibg=#353025
    hi DiagnosticUnderlineHint guisp=#99D59D gui=NONE guibg=#353025
    hi clear DiagnosticHint
    hi link DiagnosticHint Ignore

    hi MyLspCursorWord ctermbg=242 guibg=#383029
    hi link LspReferenceText  MyLspCursorWord
    hi link LspReferenceRead  MyLspCursorWord
    hi link LspReferenceWrite MyLspCursorWord

    hi link CmpItemKind Label
    hi link CmpItemMenu Ignore

    " this is melange background color
    hi Background guifg=#2A2520
    " Whitespace is #4D453E
    hi IndentGuide guifg=#3A3029
    hi NormalFloat guibg=#2A2520
    hi FloatBorder guifg=#8D857E

    hi link SelectionBracket Delimiter
    hi link SelectionIndex Number
    hi link SelectionHover Visual

    hi link RenamePrefix PreProc

    " Consider
    "hi GitSignsChange guifg=#B380B0
    " hi GitSignsChange guifg=#A9BDE2
endfunction

colorscheme melange
call s:my_highlights() " done this way to run highlights every time I source this file


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

function! DeleteHiddenBuffers()
    let tpbl=[]
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
        silent execute 'bwipeout' buf
    endfor
endfunction
command! Bdhidden call DeleteHiddenBuffers()

command! Qother execute '%bdelete | edit # | normal `"'
command! Qo execute '%bdelete | edit # | normal `"'

" Use lua module cache
lua require('impatient')

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

" ---- Diagnostics ----
lua << EOF
_G.Diagnostic_signs = {
  error = "", --"",
  warning = "", -- "",
  hint = "",
  info = "", -- "",
  other = "﫠"
}
local config = {
  virtual_text = false,
  signs = {
    active = {
      { name = "DiagnosticSignError", text = Diagnostic_signs.error },
      { name = "DiagnosticSignWarn",  text = Diagnostic_signs.warn },
      { name = "DiagnosticSignInfo",  text = Diagnostic_signs.info },
      { name = "DiagnosticSignHint",  text = Diagnostic_signs.hint },
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
" ----- Plugin specific mappings -----

" ----- Selection ----
lua << EOF
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

  local on_select = function (_, suggestion)
    vim.cmd("normal! ciw" .. suggestion)
    vim.cmd "stopinsert"
  end
  require'selection'.open(suggestions, on_select)
end
EOF
nnoremap z= <cmd>lua Select_spell_suggestion()<cr>

" ----- Status line -----
lua << EOF
local utils = require'lualine.utils.utils'

local colors = {
  -- Can be done dynamicly, but using raw colors for speed.
  normal  = '#C1A78E',
  insert  = '#9AACCE',
  ignore  = '#A38D78',
  visual  = '#B380B0',
  command = '#E49B5D',
  replace = '#86A3A3',
  fore    = '#ECE1D7',
  back1   = '#352F2A',
  back2   = '#2A2520',
  --normal  = utils.extract_color_from_hllist('fg', { 'StatusLineNC' }, 'NONE'),
  --insert  = utils.extract_color_from_hllist('fg', { 'String' }, 'NONE'),
  --ignore  = utils.extract_color_from_hllist('fg', { 'Ignore' }, 'NONE'),
  --visual  = utils.extract_color_from_hllist('fg', { 'Constant' }, 'NONE'),
  --command = utils.extract_color_from_hllist('fg', { 'Statement' }, 'NONE'),
  --replace = utils.extract_color_from_hllist('fg', { 'Type' }, 'NONE'),
  --fore    = utils.extract_color_from_hllist('fg', { 'Normal' }, 'NONE'),
  --back2   = utils.extract_color_from_hllist('bg', { 'StatusLine' }, 'NONE'),
  --back1   = utils.extract_color_from_hllist('bg', { 'StatusLineNC' }, 'NONE'),
}
local melange = {
  normal = {
    a = { bg = colors.normal,  fg = colors.back1, gui = 'bold' },
    b = { bg = colors.back1,   fg = colors.normal },
    c = { bg = colors.back2,   fg = colors.fore },
    x = { bg = colors.back2,   fg = colors.ignore },
  },
  insert = {
    a = { bg = colors.insert,  fg = colors.back1, gui = 'bold' },
    b = { bg = colors.back1,   fg = colors.insert },
    c = { bg = colors.back2,   fg = colors.fore },
    x = { bg = colors.back2,   fg = colors.ignore },
  },
  replace = {
    a = { bg = colors.replace, fg = colors.back1, gui = 'bold' },
    b = { bg = colors.back1,   fg = colors.replace },
    c = { bg = colors.back2,   fg = colors.fore },
    x = { bg = colors.back2,   fg = colors.ignore },
  },
  visual = {
    a = { bg = colors.visual,  fg = colors.back1, gui = 'bold' },
    b = { bg = colors.back1,   fg = colors.visual },
    c = { bg = colors.back2,   fg = colors.fore },
    x = { bg = colors.back2,   fg = colors.ignore },
  },
  command = {
    a = { bg = colors.command, fg = colors.back1, gui = 'bold' },
    b = { bg = colors.back1,   fg = colors.command },
    c = { bg = colors.back2,   fg = colors.fore },
    x = { bg = colors.back2,   fg = colors.ignore },
  },
}

require('lualine').setup({
  options = {
    theme = melange,
    -- Just disable these, even though there are extensions for them.
    disabled_filetypes = {'nerdtree', 'fugitive', 'toggleterm' },
  },
  sections = {
    lualine_b = {
      'branch', 'diff',
      {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
      }
    },
    lualine_x = {'filetype'},
    lualine_y = {
      { 'progress', separators = '', padding = { left = 0, right = 1 }}
    }
  },
  tabline = {
    lualine_c = {{
      'tabs',
       mode = 2,
       tabs_color = {
         active = 'lualine_a_normal',
         inactive = 'lualine_b_normal',
       }
    }},
    lualine_y = { 'encoding', { 'fileformat', padding = { left = 1, right = 2 }}},
    lualine_z = {{
      -- Shows only active buffer number with filetype icon.
      'buffers',
      mode = 1,
      max_length = 1,
      show_modified_status = false,
      buffers_color = {
        active = 'lualine_a_normal',
        inactive = 'lualine_x_normal',
      }
    }}
  },
  extensions = { 'quickfix' },
})
EOF
" --- Colorizer ---
lua << EOF
require'colorizer'.setup()
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
let g:indent_blankline_enabled = v:false
nnoremap <leader>gi <cmd>IndentBlanklineToggle<cr>
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
" Close tag in normal mode.
nmap <leader>> a<bs>><esc>

" --- Comment ---
lua << EOF
require('Comment').setup({
  --ignore = '^$' -- ignore empty lines
  toggler = { line = 'gcc', block = 'gbb', },
  pre_hook = function(ctx)
    -- In these files use nvim-ts-context-commentstring.
    if vim.bo.filetype == 'typescriptreact' then
      local U = require('Comment.utils')

      -- Detemine whether to use linewise or blockwise commentstring
      local type = ctx.ctype == U.ctype.line and '__default' or '__multiline'

      -- Determine the location where to calculate commentstring from
      local location = nil
      if ctx.ctype == U.ctype.block then
        location = require('ts_context_commentstring.utils').get_cursor_location()
      elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
        location = require('ts_context_commentstring.utils').get_visual_start_location()
      end

      return require('ts_context_commentstring.internal').calculate_commentstring({ key = type, location = location, })
    end
  end,
})
EOF

" --- Git ---
" https://dpwright.com/posts/2018/04/06/graphical-log-with-vimfugitive/
command! -nargs=* Glg Git! log --graph --abbrev-commit --decorate --format=format:'%s %C(bold yellow)%d%C(reset) %C(bold green)(%ar)%C(reset) %C(dim white)<%an>%C(reset) %C(bold blue)%h%C(reset)' --all<args>

" --- Telescope ---
lua <<EOF
local actions = require('telescope.actions')
local previewers = require('telescope.previewers')
local action_state = require("telescope.actions.state")
local delete_buffer = function (force)
  return function (prompt_buf)
    local current_picker = action_state.get_current_picker(prompt_buf)
    local multi_selections = current_picker:get_multi_selection()

    if next(multi_selections) == nil then
      local selection = action_state.get_selected_entry()
      actions.close(prompt_buf)
      vim.api.nvim_buf_delete(selection.bufnr, {force = force, unload = false})
    else
      actions.close(prompt_buf)
      for _, selection in ipairs(multi_selections) do
        vim.api.nvim_buf_delete(selection.bufnr, {force = force, unload = false})
      end
    end
  end
end

require('telescope').setup {
  defaults = {
    file_ignore_patterns = {'build/.*', 'bin/.*'},
    path_display = { truncate = 2 },
    color_devicons = true,
    prompt_prefix = ' ',
    set_env = { ['COLORTERM'] = 'truecolor' },
    mappings = {
      i = {
        --['<esc>'] = actions.close,
        --['jj'] = { '<esc>', type = 'command' },
        -- Use same horizontal and vertical mappings as Nerdtree.
        ["<C-i>"] = actions.select_horizontal,
        ["<C-s>"] = actions.select_vertical,
        ["<C-b>"] = actions.preview_scrolling_up,
        ["<C-f>"] = actions.preview_scrolling_down,
        ["<C-u>"] = false, -- clears prompt
      },
      n = {
        ["<C-i>"] = actions.select_horizontal,
        ["<C-s>"] = actions.select_vertical,
      }
    },
  },
  pickers = {
    buffers = {
      mappings = {
        i = {
          ["<c-d>"] = delete_buffer(false),
          ["<c-S-D>"] = delete_buffer(true),
        },
        n = {
          ["<c-d>"] = delete_buffer(false),
          ["<c-S-D>"] = delete_buffer(true),
          ["d"] = delete_buffer(false),
          ["D"] = delete_buffer(true),
        }
      }
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
nnoremap <leader>gh <cmd>Telescope help_tags<cr>
nnoremap <leader>gH <cmd>Telescope highlights<cr>
nnoremap <leader>g, <cmd>Telescope resume<cr>
nnoremap <leader>gb <cmd>Telescope git_branches<cr>

" Quickly go to some my config file
command! Dotfiles execute 'lua require("telescope.builtin").git_files { cwd = "~" }'

command! Nocheckin silent execute 'Ggrep nocheckin'
command! Nch silent execute 'Ggrep nocheckin'

" --- Startify ---
command! SQuit execute 'SClose | qa'
lua << EOF
function _G.webDevIcons(path)
  local filename = vim.fn.fnamemodify(path, ':t')
  local extension = vim.fn.fnamemodify(path, ':e')
  return require'nvim-web-devicons'.get_icon(filename, extension, { default = true })
end
EOF

function! StartifyEntryFormat() abort
  return 'v:lua.webDevIcons(absolute_path) . " " . entry_path'
endfunction

" --- EasyAlign ---
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)


" ----- Nerdtree -----
nnoremap <C-n> <cmd>NERDTreeToggle<CR>
nnoremap <leader>n <cmd>NERDTreeFind<CR>
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeShowHidden=1                    " Show hidden files
let g:NERDTreeWinPos = "right"
let NERDTreeQuitOnOpen=1
let g:NERDTreeWinSize=50           " Maybe do this just for some file types.
" let g:NERDTreeWinSize=50           " Maybe do this just for some file types.
" Refresh devicons so nerdtree does not show [] around icons
if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif
augroup my_nerdtree
  au!
  autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
  " autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
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

" --- Git signs ---
lua << EOF
require('gitsigns').setup {
  on_attach = function(bufnr)
    local function map(mode, lhs, rhs, opts)
        opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
        vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
    end

    -- Navigation
    map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
    map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})

    -- Actions
    map('n', '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map('v', '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map('n', '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map('v', '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>')
    map('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>')
    map('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>')
    map('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>')
    map('n', '<leader>hb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
    map('n', '<leader>hB', '<cmd>Gitsigns toggle_current_line_blame<CR>')
    map('n', '<leader>hd', '<cmd>Gitsigns diffthis<CR>')
    map('n', '<leader>hD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')
    map('n', '<leader>ht', '<cmd>Gitsigns toggle_deleted<CR>')

    -- Text object
    map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}
EOF

" --- Zen mode ---

nnoremap <leader>z <cmd>ZenMode<cr>
lua << EOF
require("zen-mode").setup {
  window = {
    --backdrop = 1,
    height = 0.9,
    options = {
      signcolumn     = "yes",
      number         = true,
      relativenumber = true,
    }
  }
}
EOF

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

" --- Smooth scroll (Neo scroll) ---
lua << EOF
require('neoscroll').setup()
-- speed it up compared to defaults.
require('neoscroll.config').set_mappings({
  ['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '30'}},
  ['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '30'}},
  ['<C-b>'] = {'scroll', {'-vim.api.nvim_win_get_height(0)', 'true', '60'}},
  ['<C-f>'] = {'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '60'}},
--  ['<C-y>'] = {'scroll', {'-0.10', 'false', '5'}},
--  ['<C-e>'] = {'scroll', { '0.10', 'false', '5'}},
  ['zt']    = {'zt', {'20'}},
  ['zz']    = {'zz', {'20'}},
  ['zb']    = {'zb', {'20'}}
})
EOF

" --- Trouble ---
" Warning: trouble has mapping all over this file.
" TODO: figure out a way to add custom mapping wichih pipes Trouble items to qflist
nnoremap <leader>t <cmd>TroubleToggle<cr>
nnoremap <leader>T <cmd>TroubleToggle workspace_diagnostics<cr>
nnoremap [t <cmd>lua require("trouble").next({skip_groups = true, jump = true})<cr>
nnoremap ]t <cmd>lua require("trouble").prev({skip_groups = true, jump = true})<cr>
nnoremap <leader>[T <cmd>TroubleToggle quickfix<cr>
nnoremap <leader>]T <cmd>TroubleToggle loclist<cr>

lua << EOF
require("trouble").setup {
   action_keys = {
     jump = {"<cr>", "<tab>"},
     jump_close = {"o"},
     -- same as telescope and nerdtree
     open_split = { "i", "<c-i>" },
     open_vsplit = { "s", "<c-s>" },
     open_tab = { "t","<c-t>" },
     toggle_fold = {"x"},
   },
   group = true,
   auto_preview = true,
   auto_close = false,
   auto_jump = {"lsp_definitions", "lsp_references", "lsp_implementations", "lsp_type_definitions"},
   signs = {
     error       = Diagnostic_signs.error,
     warning     = Diagnostic_signs.warn,
     hint        = Diagnostic_signs.hint,
     information = Diagnostic_signs.info,
     other       = Diagnostic_signs.other
   },
   use_diagnostic_signs = false
}
EOF
" --- Switch ---
let g:switch_mapping = "gw"

" --- Luasnip ---
imap <silent><expr> <c-;> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<c-,>'
inoremap <silent> <c-l> <cmd>lua require'luasnip'.jump(-1)<cr>

snoremap <silent> <c-;> <cmd>lua require('luasnip').jump(1)<cr>
snoremap <silent> <c-l> <cmd>lua require('luasnip').jump(-1)<cr>

" For changing choices in choiceNodes (not strictly necessary for a basic setup).
imap <silent><expr> <c-'> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-'>'
smap <silent><expr> <C-'> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-'>'
lua << EOF
local ls = require("luasnip")
require("luasnip.loaders.from_vscode").load()
ls.config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
})
EOF

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
" Do not open quickfix on each compilation.
let g:vimtex_quickfix_mode=0
" Matchin of environments is too slow, escpecially for large files
let g:vimtex_matchparen_enabled = 0
let g:vimtex_view_general_viewer = 'SumatraPDF'
let g:vimtex_view_general_options
    \ = '-reuse-instance -forward-search @tex @line @pdf'
 let g:vimtex_compiler_latexmk = {
    \ 'options' : [
        \   '-reuse-instance',
        \ ],
    \ }

"\   '-interaction=nonstopmode', maybe use

augroup my_latex
    au!
    autocmd FileType tex set wrap
augroup end

" ----- Native lsp -----

" set completeopt=menu,menuone,noselect,noinsert
" set omnifunc=''
" inoremap <C-space> <Cmd>lua require('cmp').complete()<CR>
" inoremap <C-n> <Cmd>lua require('cmp').complete()<CR>


nnoremap <silent> [d <cmd>lua vim.diagnostic.goto_prev()<cr>
nnoremap <silent> ]d <cmd>lua vim.diagnostic.goto_next()<cr>
nnoremap <silent> [D <cmd>lua vim.diagnostic.open_float()<cr>
nnoremap <silent> ]D <cmd>TroubleToggle document_diagnostics<cr>
"nnoremap <silent> ]D <cmd>lua vim.diagnostic.setloclist()<cr>
nnoremap <silent> [e <cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<cr>
nnoremap <silent> ]e <cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<cr>
lua <<EOF
Lsp_on_attach = function (client, bufnr)

  local opts = { noremap=true, silent=true }

  if client.name == "elmls" then
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  else
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>TroubleToggle lsp_definitions<cr>', opts)
  end
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>TroubleToggle lsp_type_definitions<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gs', '<cmd>TroubleToggle lsp_references<cr>', opts)
  -- I chaned trouble.nvim/lua/trouble/providers/lsp.lua includeDeclaration to false, since I can't pass it as arg.
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gS', '<cmd>TroubleToggle lsp_implementations<cr>', opts)

  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gm', '<cmd>lua require("lspops").rename()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K',  '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
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
    if client.name ~= "vimls" and client.name ~= "texlab" then
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

  vim.api.nvim_notify("... " .. client.name .. " lsp attached. ", vim.log.levels.INFO, {})
end


local lsp_installer = require("nvim-lsp-installer")

lsp_installer.on_server_ready(function(server)
  local config = { on_attach = Lsp_on_attach }
  config.capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

  if server.name == "tsserver" then
    local ts_cfg = {
      handlers = {
        ["textDocument/publishDiagnostics"] = function(err, result, ctx, hconfig)
         -- Do nothing since tsserver diagnostics are too slow.

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
          vim.lsp.with(vim.lsp.handlers.hover, {
              border = "rounded",
            })
          end
      }
    }
    config = vim.tbl_deep_extend("force", lua_cfg, config)
    -- TODO texlab (maybe)
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

EOF

" --- Autocompletion ---
lua <<EOF
local kind_icons = {
  Text          = "",
  Method        = "m",
  Function      = "",
  Constructor   = "",
  Field         = "",
  Variable      = "",
  Class         = "",
  Interface     = "",
  Module        = "",
  Property      = "",
  Unit          = "",
  Value         = "",
  Enum          = "",
  Keyword       = "",
  Snippet       = "",
  Color         = "",
  File          = "",
  Reference     = "",
  Folder        = "",
  EnumMember    = "",
  Constant      = "",
  Struct        = "",
  Event         = "",
  Operator      = "",
  TypeParameter = "",
}
-- Nvim-cmp

local cmp = require'cmp'

cmp.setup({
  --completion = {
    --autocomplete = true -- can disable and invoke manually
  --},
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
     ['<C-n>'] = function(fallback)
         -- either open window or select next item
       if cmp.visible() then
         cmp.select_next_item()
       else
         cmp.complete()
       end
     end,
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    -- Try C-y instead fo <CR>
    --['<C-y>'] = cmp.mapping.confirm({ -select = true, behavior = cmp.ConfirmBehavior.Insert, }),
    ['<CR>'] = cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Insert, }),
  },
  sources = cmp.config.sources({
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' }
  }, {
    { name = 'buffer', keyword_length = 4 },
    { name = 'path' },
    { name = 'emoji'}
  }),
  formatting = {
    format = function(entry, vim_item)
     vim_item.kind = string.format("%s", kind_icons[vim_item.kind])

     vim_item.menu = ({
        buffer    = '{buf}',
        nvim_lsp  = '{ls}',
        nvim_lua  = '{nlua}',
        path      = '{path}',
        luasnip   = '{snip}',
     })[entry.source.name]

     return vim_item
    end
  },
  view = {
    entries = "custom",
  },
})
