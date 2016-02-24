" Test split window configuration.

edit ++enc=utf-16le text.txt

call vimtest#StartTap()
call vimtap#Plan(6)

let g:clone_splitmode = 'belowright'
SCloneAs new.txt
call vimtap#Is(winnr('$'), 2, 'Clone is opened in split window')
call vimtap#Is(winnr(), 2, 'Clone is opened in split window configured below original')
call vimtap#Is(bufname(''), 'new.txt', 'Clone is edited')
bdelete!

let g:clone_splitmode = 'aboveleft'
SCloneAs new2.txt
call vimtap#Is(winnr('$'), 2, 'Clone is opened in split window')
call vimtap#Is(winnr(), 1, 'Clone is opened in split window configured forced above original')
call vimtap#Is(bufname(''), 'new2.txt', 'Clone is edited')
bdelete!

call vimtest#Quit()
