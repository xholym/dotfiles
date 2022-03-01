local selection = require('selection')

local M = {}

local function request_code_actions(ctx)

  local params = vim.lsp.util.make_range_params()
  params.context = {
    diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
  }
  if ctx then
    params = vim.tbl_deep_extend("force", ctx, params)
  end

  local results, err = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 900)
  if err then
    print 'textDocument/codeAction returned an error'
    P(err)
    return
  end

  return results
end

local function execute_action(act)
  if act.edit or type(act.command) == "table" then
    if act.edit then
      vim.lsp.util.apply_workspace_edit(act.edit)
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
        execute_action(real)
      else
        execute_action(action)
      end
    end)
  else
    execute_action(action)
  end
end

M.run_fix = function()

  local results = request_code_actions({ only = {"quickfix"}})

  if not results or vim.tbl_isempty(results) then
    print "No quickfixes!"
    return
  end

  for cid, resp in pairs(results) do
    if resp.result then
      for _, result in pairs(resp.result) do

        -- Run the first action
        do_action(result, cid)
        return

      end
    end
  end
end

M.list_code_actions = function(ctx)
  local results = request_code_actions(ctx)
  if not results then
    return
  end

  local action_choices = {}
  for cid, resp in pairs(results) do
    if resp.result then
      for _, result in pairs(resp.result) do

        -- Run the first action
        local choice = {
          -- data for code action running
          data = result,
          client_id = cid,
          -- data for selection view
          text = result.command.title
        }
        table.insert(action_choices, choice)
      end
    end
  end

  local on_select = function (_, action)
    do_action(action.data, action.client_id)
  end
  selection.open(action_choices, on_select)
end


return M
