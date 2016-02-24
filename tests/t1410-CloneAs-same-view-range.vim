" Test keeping the current view when cloning a range.

set hidden
edit ++enc=utf-16le text.txt
call setline(3, repeat([''], 40) + ['last line' . repeat('.', 80) . 'X!'] + repeat([''], 20))
normal! G{j$h
let [s:originalLnum, s:originalCol] = getpos('.')[1:2]

23,45CloneAs new.txt

call vimtest#StartTap()
call vimtap#Plan(1)

call vimtap#Is(getpos('.')[1:2], [s:originalLnum - 22, s:originalCol], 'Adapted original cursor position is retained with :CloneAs')

call vimtest#SaveOut()
call vimtest#Quit()
