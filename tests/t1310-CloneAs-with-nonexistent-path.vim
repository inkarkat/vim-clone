" Test cloning to a non-existent path.

edit ++enc=utf-16le text.txt

let s:cloneFilespec = 'X:/doesNotExist/file.txt'
call vimtest#StartTap()
call vimtap#Plan(3)
call vimtap#Ok(! filereadable(s:cloneFilespec), 'Target is non-existent')

execute 'CloneAs' ingo#compat#fnameescape(s:cloneFilespec)

call vimtap#file#IsFilespec(bufname(''), s:cloneFilespec, 'Clone in non-existent directory is edited')
call vimtap#Ok(! filereadable(s:cloneFilespec), 'Clone has not been persisted')

call vimtest#Quit()
