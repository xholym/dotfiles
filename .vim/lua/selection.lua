local strings = require "plenary.strings"

local M = { state = nil }

--M.state : {
--  choices : Array<T>,
--  on_select : function(id: Int, value : <Any + { text : string }>),
--  popup : { win : Int, buf : int }
--}

M.open = function(choices, on_select)
  if not choices and vim.tbl_isempty() then
    print 'No selection choices to show'
    return
  end
  M.state = {choices = choices, on_select = on_select}
  local text = {}
  local width = 20
  for i, it in ipairs(choices) do
    local line = ' [' .. i-1 .. '] ' .. it.text
    table.insert(text, line)
    width = math.max(width, strings.strdisplaywidth(it.text) + 6)
  end

  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_option(buf, "filetype", "selector")
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_call(buf, function()
    vim.cmd("setlocal norelativenumber")
    vim.cmd("setlocal nonumber")
  end)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, text)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  local key_opts = { noremap = true, nowait = true, silent = true }
  for i, _ in ipairs(choices) do
    vim.api.nvim_buf_set_keymap(buf, 'n', '' .. i-1, '<cmd>lua require("selector").choose(' .. i .. ')<CR>', key_opts)
  end

  vim.api.nvim_buf_set_keymap(buf, 'n', '<ESC>', '<cmd>q<CR>', key_opts)
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>q<CR>', key_opts)
  vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', '<cmd>lua require("selector").choose()<CR>', key_opts)

  local win = vim.api.nvim_open_win(buf, true, {
    focusable = true,
    border = "rounded", style = "minimal",
    width = width,
    height = #choices,
    relative = "cursor",
    row = 0, col = 0
    --row = row, col = col
  })
  M.state.popup = { win = win, buf = buf }

  vim.cmd 'autocmd CursorMoved <buffer> lua require("selector").set_cursor()'
  vim.cmd 'autocmd WinLeave <buffer> lua require("selector").close()'
end

M.choose = function(idx)
  if not M.state then
    print 'there is nothing to select from'
    return
  end
  if not M.state.choices then
    print 'no choices'
    return
  end
  if not M.state.on_select then
    print 'nothing to do on selection'
    return
  end
  if not idx then
    idx = tonumber(vim.fn.expand("<cword>"))
  end
  local choice = M.state.choices[idx]
  local on_select = M.state.on_select

  M.close()
  print 'running selection choice'
  on_select(idx, choice)
end

M.set_cursor = function()
  local column = 3
  local current_line = vim.fn.line "."

  vim.fn.cursor(current_line, column)
end

-- Not used so far
M.close = function()
  print 'closing selection window'
  if not M.state or not M.state.popup then
    print 'no windown to close'
    return
  end
  vim.api.nvim_win_close(M.state.popup.win, true)
end

return M
