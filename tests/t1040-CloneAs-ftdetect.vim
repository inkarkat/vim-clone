" Test custom filetype overrides filetype detection.

set hidden
filetype on
edit main.c

call vimtest#StartTap()
call vimtap#Plan(2)

call vimtap#Is(&l:filetype, 'c', 'Detected C filetype')
setf custom

CloneAs new.c

call vimtap#Is(&l:filetype, 'custom', 'Custom filetype is cloned')

call vimtest#Quit()
