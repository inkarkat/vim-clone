" Test cloning to a different path.

edit ++enc=utf-16le text.txt

let s:cloneFilespec = tempname()
execute 'CloneAs' ingo#compat#fnameescape(s:cloneFilespec)

call vimtest#StartTap()
call vimtap#Plan(2)

call vimtap#Is(fnamemodify(bufname(''), ':p'), s:cloneFilespec, 'Clone in temp directory is edited')
call vimtap#Ok(! filereadable(s:cloneFilespec), 'Clone has not been persisted')

call vimtest#Quit()
