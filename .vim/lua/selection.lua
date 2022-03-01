local strings = require "plenary.strings"

local M = { state = nil }

--M.state : {
--  choices : Array<T>,
--  on_select : function(id: Int, value : <string | Any + { text : string }>),
--  popup : { win : Int, buf : int }
--}

M.open = function(choices, on_select)
  if not choices or vim.tbl_isempty(choices) then
    print 'No selection choices to show'
    return
  end
  M.state = {choices = choices, on_select = on_select}
  local text = {}
  local width = 5
  for i, it in ipairs(choices) do
    local item_text
    if type(it) == "string" then
      item_text = it
    else
      if not it.text or not type(it) == "string" then
        print "Choice items have to be strings are have to have a text property"
        return
      end
      item_text = it.text
    end
    local line = ' [' .. i-1 .. '] ' .. item_text
    table.insert(text, line)
    width = math.max(width, strings.strdisplaywidth(item_text) + 6)
  end

  local buf = vim.api.nvim_create_buf(false, true)

  -- options
  local set_option = vim.api.nvim_buf_set_option
  set_option(buf, "filetype", "selection")
  set_option(buf, "buftype", "nofile")
  set_option(buf, "bufhidden", "wipe")

  -- content
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, text)
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


  local win = vim.api.nvim_open_win(buf, true, {
    focusable = true,
    border = "rounded", style = "minimal",
    width = width,
    height = #choices,
    relative = "cursor",
    row = 0, col = 0
  })
  M.state.popup = { win = win, buf = buf }

  vim.api.nvim_win_set_option(win, 'winhl', 'Normal:SelectionFloat')

  vim.cmd 'autocmd CursorMoved <buffer> lua require("selection").set_cursor()'
  vim.cmd 'autocmd WinLeave <buffer> lua require("selection").close()'
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
  on_select(idx, choice)
end

M.set_cursor = function()
  local column = 3
  local current_line = vim.fn.line "."

  vim.fn.cursor(current_line, column)
end

-- Not used so far
M.close = function()
  if not M.state or not M.state.popup then
    print 'no windown to close'
    return
  end
  vim.api.nvim_win_close(M.state.popup.win, true)
end

M.mock = function()
  local items = { "ahoj", "foo", "bar", "fizzbuzz" }
  local on_select = function(i, it)
    print(it)
  end
  M.open(items, on_select)
end

return M
