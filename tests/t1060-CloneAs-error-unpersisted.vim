" Test existing unpersisted buffer error.

edit unpersisted.txt
split ++enc=utf-16le text.txt

call vimtest#StartTap()
call vimtap#Plan(3)
try
    CloneAs unpersisted.txt
    call vimtap#Fail('expected exception')
catch
    call vimtap#err#Thrown('Buffer with this name already exists', 'exception thrown')
endtry


call vimtap#Is(bufname(''), 'text.txt', 'Original is edited')
call vimtap#Ok(! &l:modified, 'Original is not modified')

call vimtest#Quit()
