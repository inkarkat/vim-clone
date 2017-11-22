" Test existing unpersisted buffer error.

edit unpersisted.txt
split ++enc=utf-16le text.txt

call vimtest#StartTap()
call vimtap#Plan(3)
call vimtap#err#Errors('Buffer with this name already exists', 'CloneAs unpersisted.txt', 'exception thrown')


call vimtap#Is(bufname(''), 'text.txt', 'Original is edited')
call vimtap#Ok(! &l:modified, 'Original is not modified')

call vimtest#Quit()
