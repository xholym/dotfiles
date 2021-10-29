GuiFont! FiraCode NF:h10
GuiPopupmenu 0

let g:fontsize = 10
function! AdjustFontSize(amount)
  let g:fontsize = g:fontsize+a:amount
  :execute "GuiFont! FiraCode NF:h" . g:fontsize
  " This echo statment does not work.
  :execute "echo \"Fontsize adjusted to \"" . g:fontsize
endfunction

noremap <C-ScrollWheelUp> :call AdjustFontSize(1)<CR>
noremap <C-ScrollWheelDown> :call AdjustFontSize(-1)<CR>
