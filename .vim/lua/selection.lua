local strings = require "plenary.strings"

local M = {}

--M : {
--  ... funcitons ...
--  choices : Array<T>,
--  on_select : function(id: Int, value : <string | Any + { text : string }>),
--  win : Int,
--  buf : Int
--}
local function str_rpad(str, len, char)
  if char == nil then char = ' ' end
  return str .. string.rep(char, len - #str)
end

local function extract_choice_text(choice)
  if type(choice) == "string" then
    return choice
  else
    if not choice.text or not type(choice) == "string" then
      print "Choice items have to be strings are have to have a text property"
      return
    end
    return choice.text
  end
end

M.open = function(choices, on_select)
  if not choices or vim.tbl_isempty(choices) then
    print 'No selection choices to show'
    return
  end
  M.choices = choices
  M.on_select = on_select
  local lines = {}
  local width = 8
  for _, it in ipairs(choices) do
    local txt = extract_choice_text(it)
    width = math.max(width, strings.strdisplaywidth(txt) + 7)
  end
  for i, it in ipairs(choices) do
    local txt = extract_choice_text(it)
    local line = ' [' .. i-1 .. '] ' .. txt .. ' '
    line = str_rpad(line, width)
    table.insert(lines, line)
  end

  local buf = vim.api.nvim_create_buf(false, true)

  -- options
  local set_option = vim.api.nvim_buf_set_option
  set_option(buf, "filetype", "selection")
  set_option(buf, "buftype", "nofile")
  set_option(buf, "bufhidden", "wipe")

  -- content
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  -- keymaps
  local key_opts = { noremap = true, nowait = true, silent = true }
  local keymap = vim.api.nvim_buf_set_keymap
  for i, _ in ipairs(choices) do
    keymap(buf, 'n', '' .. i-1, '<cmd>lua require("selection").choose(' .. i .. ')<CR>', key_opts)

    -- highlights
    local hl = vim.api.nvim_buf_add_highlight
    local idx_width = strings.strdisplaywidth(i)
    hl(buf, -1, 'SelectionBracket', i-1, 1, 2)
    hl(buf, -1, 'SelectionIndex', i-1, 2, 2 + idx_width)
    hl(buf, -1, 'SelectionBracket', i-1, 2 + idx_width, 3 + idx_width)
    hl(buf, -1, 'SelectionText', i-1, idx_width + 3, -1)

  end
  keymap(buf, 'n', '<ESC>', '<cmd>q<CR>', key_opts)
  keymap(buf, 'n', 'q', '<cmd>q<CR>', key_opts)
  keymap(buf, 'n', '<CR>', '<cmd>lua require("selection").choose()<CR>', key_opts)


  local win_opts = {
    focusable = true,
    border = "rounded", style = "minimal",
    width = width, height = #choices,
    relative = "editor",
    row = vim.fn.screenrow(), col = vim.fn.screencol(),
    anchor = "NW"
  }
  if win_opts.row + win_opts.height > vim.o.lines - 4 then -- 4 is for padding
     win_opts.anchor = "SW"
  end
  local win = vim.api.nvim_open_win(buf, true, win_opts)
  M.win = win
  M.buf = buf

  vim.api.nvim_win_set_option(win, 'winhl', 'Normal:SelectionFloat')

  vim.cmd 'autocmd CursorMoved <buffer> lua require("selection").set_cursor()'
  vim.cmd 'autocmd WinLeave <buffer> lua require("selection").clear_and_close()'
end

local function close()
  if not M.win then
    print 'no windown to close'
    return
  end
  vim.api.nvim_win_close(M.win, true)
  M.win = nil
  M.buf = nil
end

M.choose = function(idx)
  if not M.choices then
    print 'There are no choices to select from.'
    return
  end
  if not M.on_select then
    print 'There is nothing to do on selection.'
    return
  end
  if not idx then
    idx = tonumber(vim.fn.expand("<cword>"))
  end
  local choice = M.choices[idx]
  local on_select = M.on_select

  close()
  on_select(idx, choice)
  M.choices = nil
  M.on_select = nil
end

local namespace = vim.api.nvim_create_namespace("selection-namespace")
M.set_cursor = function()
  local column = 3
  local current_line = vim.fn.line "."

  vim.fn.cursor(current_line, column)
  if M.buf then
    vim.api.nvim_buf_clear_namespace(M.buf, namespace, 0, -1)
    vim.api.nvim_buf_add_highlight(M.buf, namespace, 'SelectionHover', current_line - 1 , 0, -1)
  end
end

-- Not used so far
M.clear_and_close = function()
  M.choices = nil
  M.on_select = nil

  close()
end

M.mock = function()
  local items = { "ahoj", "foo", "bar", "fizzbuzz" }
  local on_select = function(_, it)
    print(it)
  end
  M.open(items, on_select)
end

return M
