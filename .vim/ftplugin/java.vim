lua <<EOF
local workspace_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local on_attach = function (client, bufnr)
Lsp_on_attach(client, bufnr)

  local opts = { noremap=true, silent=true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>o', [[ <cmd>lua require'jdtls'.organize_imports()<cr> ]], opts)
end
--local capabilities = vim.lsp.protocol.make_client_capabilities()
--capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
local config = {
  on_attach = on_attach,
  cmd = {
    'java',
	'-Declipse.application=org.eclipse.jdt.ls.core.id1',
	'-Dosgi.bundles.defaultStartLevel=4',
	'-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
	'-Dlog.level=ALL',
	'-noverify',
	'-Xmx1G',
  '-javaagent:C:/tools/lombok.jar',
	'-jar', 'C:/tools/jdt-language-server-1.8.0/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
	'-configuration', 'C:/tools/jdt-language-server-1.8.0/config_win',
	'-data', vim.fn.expand('~/.cache/jdtls-workspace') .. workspace_dir,
  '--add-modules=ALL-SYSTEM',
  '--add-opens', 'java.base/java.util=ALL-UNNAMED',
  '--add-opens', 'java.base/java.lang=ALL-UNNAMED'
  },
  root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
    }
  },
 -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = {}
  },
  --capabilities = capabilities,
}
local coq = require "coq"
config = coq.lsp_ensure_capabilities(config)
require('jdtls').start_or_attach(config)

function format_range_operator()
  local old_func = vim.go.operatorfunc
  _G.op_func_formatting = function()
    local start = vim.api.nvim_buf_get_mark(0, '[')
    local finish = vim.api.nvim_buf_get_mark(0, ']')
    vim.lsp.buf.range_formatting({}, start, finish)
    vim.go.operatorfunc = old_func
    _G.op_func_formatting = nil
  end
  vim.go.operatorfunc = 'v:lua.op_func_formatting'
  vim.api.nvim_feedkeys('g@', 'n', false)
  -- range format is not supported
  --vim.api.nvim_set_keymap("n", "<leader>l", "<cmd>lua format_range_operator()<CR>", {noremap = true})
end
EOF

" TODO: setup nvim dap
" nnoremap <leader>df <Cmd>lua require'jdtls'.test_class()<CR>
" nnoremap <leader>dn <Cmd>lua require'jdtls'.test_nearest_method()<CR>

command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JavaCompile lua require('jdtls').compile(<f-args>)
command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JavaSetRuntime lua require('jdtls').set_runtime(<f-args>)
command! -buffer JavaUpdateConfig lua require('jdtls').update_project_config()
command! -buffer JavaOl lua require('jdtls').jol()
command! -buffer JavaBytecode lua require('jdtls').javap()
command! -buffer JavaShell lua require('jdtls').jshell()
