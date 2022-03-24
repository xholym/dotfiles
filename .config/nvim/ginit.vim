GuiPopupmenu 0
GuiTabline 0
call GuiWindowMaximized(1)
GuiFont! FiraCode\ NF:h10
let g:fontsize = 10
function! AdjustFontSize(amount)
  let g:fontsize = g:fontsize+a:amount
  :execute "GuiFont! FiraCode\ NF:h" . g:fontsize
  " This echo statment does not work.
  :execute "echo \"Fontsize adjusted to \"" . g:fontsize
endfunction

noremap <c-s-+> :call AdjustFontSize(1)<CR>
noremap <c-s-_> :call AdjustFontSize(-1)<CR>
