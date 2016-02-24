" Test cloning.

set fileformats=unix,dos
edit ++enc=utf-16le text.txt
setf custom

CloneAs new.txt

call vimtest#StartTap()
call vimtap#Plan(7)

call vimtap#Is(winnr('$'), 1, 'Clone replaces original file')
call vimtap#Is(bufname(''), 'new.txt', 'Clone is edited')
call vimtap#Is(&l:fileformat, 'dos', 'Fileformat is cloned')
call vimtap#Is(&l:filetype, 'custom', 'Filetype is cloned')
call vimtap#Is(&l:fileencoding, 'utf-16le', 'File encoding is cloned')
call vimtap#Ok(&l:modified, 'Clone is modified')
call vimtap#Ok(! filereadable('new.txt'), 'Clone has not been persisted')

call vimtest#SaveOut()
call vimtest#Quit()
