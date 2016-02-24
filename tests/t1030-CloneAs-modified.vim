" Test cloning of modified buffer.

set hidden
edit ++enc=utf-16le text.txt
setf custom
call setline(3, 'modified here.')

CloneAs new.txt

call vimtest#StartTap()
call vimtap#Plan(3)

call vimtap#Ok(&l:modified, 'Clone is modified')
call vimtap#Ok(! filereadable('new.txt'), 'Clone has not been persisted')
call vimtest#SaveOut()

buffer text.txt
call vimtap#Ok(&l:modified, 'Original is still modified')

call vimtest#Quit()
