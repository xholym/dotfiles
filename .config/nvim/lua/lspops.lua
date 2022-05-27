local selection = require('selection')

local M = {} -- : {
--   ...functions...,
--   config = {
--     rename_prefix : String
--   }
--   renema_win : Int
-- }
M.config = { rename_prefix = '' }

local function request_code_actions(ctx, callback)
  local params = vim.lsp.util.make_range_params()
  params.context = {
    diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
  }
  if ctx then
    params = vim.tbl_deep_extend("force", ctx, params)
  end
  vim.lsp.buf_request_all(0, "textDocument/codeAction", params, callback)
end

local function execute_action(act, client)
  if act.edit or type(act.command) == "table" then
    if act.edit then
      vim.lsp.util.apply_workspace_edit(act.edit, client.offset_encoding)
    end
    if type(act.command) == "table" then
      vim.lsp.buf.execute_command(act.command)
    end
  else
    vim.lsp.buf.execute_command(act)
  end
end

local function do_action(action, client_id)

  local client = vim.lsp.get_client_by_id(client_id)
  if
    not action.edit
    and client
    and type(client.resolved_capabilities.code_action) == "table"
    and client.resolved_capabilities.code_action.resolveProvider
  then
    client.request("codeAction/resolve", action, function(err, real)
      if err then
        print 'codeAction/resolve returned an error'
        P(err)
        return
      end
      if real then
        execute_action(real, client)
      else
        execute_action(action, client)
      end
    end)
  else
    execute_action(action, client)
  end
end

M.run_fix = function()

  request_code_actions({only = "quickfix"}, function(results)

    for cid, resp in pairs(results) do
      if resp.result then
        for _, action in pairs(resp.result) do

          -- Run the first action
          do_action(action, cid)
          return

        end
      end
    end

    vim.notify('No quickfixes available.', vim.log.levels.INFO)
  end)
end

M.list_code_actions = function(ctx)

  request_code_actions(nil, function(results)

    if not results or vim.tbl_isempty(results) then
      vim.notify('No code actions available', vim.log.levels.INFO)
      return
    end
    local action_choices = {}
    for cid, resp in pairs(results) do
      if resp.result then
        for _, action in pairs(resp.result) do

          local text
          if action.title then
            text = action.title
          elseif action.command then
            text = action.command.title
          else
            print "Can't find text for code aciton"
          end
          local choice = {
            -- data for code action running
            data = action,
            client_id = cid,
            -- data for selection view
            text = text
          }
          table.insert(action_choices, choice)
        end
      end
    end

    local on_select = function (_, action)
      do_action(action.data, action.client_id)
    end
    selection.open(action_choices, on_select)
  end)
end


M.rename = function()

  -- Callback structure taken from Neovim/share/nvim/runtime/lua/vim/lsp/buf.lua
  vim.lsp.buf_request(0, 'textDocument/prepareRename', vim.lsp.util.make_position_params(), function (err, result, ctx, cfg)
    if err == nil and result == nil then
      vim.notify('Nothing to rename.', vim.log.levels.INFO)
      return
    end
    if err ~= nil then
      if err.code ~= -32601 then -- This is error with msg "Unhandled method textDocument/prepareRename"
        vim.notify('Renamed failed with error', vim.log.levels.INFO)
        P(err)
        return
      end
    end

    local variable_name
    P(result)
    if result ~= nil and result.placeholder ~= nil then
      variable_name = result.placeholder
    else
      variable_name = vim.fn.expand '<cword>'
    end

    local buf = vim.api.nvim_create_buf(false, true)
    local set_option = vim.api.nvim_buf_set_option
    set_option(buf, "filetype", "rename")
    set_option(buf, "bufhidden", "wipe")
    set_option(buf, "modifiable", true)

    set_option(buf, "buftype", "prompt")
    vim.fn.prompt_setprompt(buf, M.config.rename_prefix .. ' ')

    local hl = vim.api.nvim_buf_add_highlight
    hl(buf, -1, 'RenamePrefix', 0, 0, #M.config.rename_prefix)
    hl(buf, -1, 'RenameText', 0, #M.config.rename_prefix, -1)

    local keymap = vim.api.nvim_buf_set_keymap
    local key_opts = { noremap = true, nowait = true, silent = true }
    keymap(buf, 'n', '<ESC>', '<cmd>close!<CR>', key_opts)
    keymap(buf, 'n', 'q', '<cmd>close!<CR>', key_opts)
    keymap(buf, 'n', '<CR>', '<cmd>lua require("lspops").execute_rename()<CR>', key_opts)
    keymap(buf, 'i', '<CR>', '<cmd>lua require("lspops").execute_rename()<CR>', key_opts)


    local width = #variable_name
    if width < 30 then
      width = 30
    end

    local win_opts = {
      focusable = true,
      border = "rounded", style = "minimal",
      width = width, height = 1,
      -- relative = "editor",
      -- row = vim.fn.screenrow(), col = vim.fn.screencol(),
      relative = "cursor",
      row = 0, col = 0,
      anchor = "NW"
    }
    if win_opts.row + win_opts.height > vim.o.lines - 4 then -- 4 is for padding
      win_opts.anchor = "SW"
    end
    local win = vim.api.nvim_open_win(buf, true, win_opts)
    M.rename_win = win

    vim.api.nvim_win_set_option(win, "scrolloff", 0)
    vim.api.nvim_win_set_option(win, "sidescrolloff", 0)
    vim.api.nvim_win_set_option(win, 'winhl', 'Normal:RenameFloat')

    vim.cmd "startinsert"

    -- Fills prompt with cword and puts us back in normal mode at the word start.
    local key_sequence = vim.api.nvim_replace_termcodes(variable_name.."<esc>", true, false, true)
    if #variable_name > 1 then
      key_sequence = key_sequence..'B'
    end
    vim.fn.feedkeys(key_sequence)

    vim.cmd 'autocmd WinLeave <buffer> lua require("lspops").close_rename()'
    vim.cmd 'autocmd QuitPre <buffer> lua require("lspops").close_rename()'
  end)

end

M.execute_rename = function ()
  local new_name = vim.trim(vim.fn.getline("."):sub(#M.config.rename_prefix + 1, -1))
  M.close_rename()
  local current_name = vim.fn.expand "<cword>"
  if not (new_name and #new_name > 0) or new_name == current_name then
    return
  end
  local params = vim.lsp.util.make_position_params()
  params.newName = new_name
  print 'renaming'
  vim.lsp.buf_request(0, "textDocument/rename", params, function(_, result, ctx, _)
    -- source: vim.lsp.handlers['textDocument/rename']
    if not result then return end
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    vim.lsp.util.apply_workspace_edit(result, client.offset_encoding)

    -- Pouplate quickfix_list.
    local offset_encoding = vim.lsp.get_client_by_id(ctx.client_id).offset_encoding
    if result.changes then
      local locations = vim.lsp.util.locations_to_items(result.changes)
      if #locations == 0 then
        return
      else
        vim.fn.setqflist(vim.lsp.util.locations_to_items(locations, offset_encoding), ' ')
    end
      -- We could open quickfix list here.
      -- vim.cmd "copen"
    end
  end)
  vim.cmd "stopinsert" -- Make sure to exit insert mode.
end

M.close_rename = function()
  if M.rename_win then
    vim.api.nvim_win_close(M.rename_win, true)
    M.rename_win = nil
  end
end

return M
