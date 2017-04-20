" Test custom filetype overrides filetype detection.

set hidden
filetype on
edit main.c
call vimtest#SkipAndQuitIf(&l:filetype !=# 'c', 'Default filetype detection did not set C filetype')

call vimtest#StartTap()
call vimtap#Plan(1)

setf custom
CloneAs new.c

call vimtap#Is(&l:filetype, 'custom', 'Custom filetype is cloned')
call vimtest#Quit()
