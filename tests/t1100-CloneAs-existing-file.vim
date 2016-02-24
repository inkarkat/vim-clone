" Test cloning to an existing file.
" Tests that the file content's aren't read, but an alternative buffer is
" created "over" the existing file.

edit ++enc=utf-16le text.txt

CloneAs another.txt

call vimtest#StartTap()
call vimtap#Plan(4)

call vimtap#Is(bufname(''), 'another.txt', 'Clone is edited')
call vimtap#Ok(filereadable('another.txt'), 'There is an existing file with the same name')
call vimtap#Ok(&l:modified, 'Clone is modified')
call vimtap#Is(line('$'), 2, 'Clone has same number of lines as original, not as existing file') " Exact correspondence is tested via .out file.

call vimtest#SaveOut()
call vimtest#Quit()
