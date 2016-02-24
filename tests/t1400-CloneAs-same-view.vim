" Test keeping the current view when cloning.

set hidden
edit ++enc=utf-16le text.txt
call setline(3, repeat([''], 40) + ['last line' . repeat('.', 80) . 'X!'])
normal! G$h
let s:originalCursor = getpos('.')[1:2]

CloneAs new.txt

call vimtest#StartTap()
call vimtap#Plan(2)

call vimtap#Is(getpos('.')[1:2], s:originalCursor, 'Original cursor position is retained with :CloneAs')

SCloneAs newer.txt
call vimtap#Is(getpos('.')[1:2], s:originalCursor, 'Original cursor position is retained with :SCloneAs')

call vimtest#SaveOut()
call vimtest#Quit()
