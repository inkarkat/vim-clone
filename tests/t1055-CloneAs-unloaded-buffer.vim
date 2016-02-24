" Test unloaded persisted buffer.

edit another.txt
let s:bufnr = bufnr('')
edit ++enc=utf-16le text.txt
bdelete another.txt

call vimtest#StartTap()
call vimtap#Plan(2)
try
    CloneAs another.txt
    call vimtap#Is(bufname(''), 'another.txt', 'Clone is edited')
    call vimtap#Isnt(bufnr(''), s:bufnr, 'unloaded buffer is not recycled')
catch
    call vimtap#Fail('exception has been thrown: ' . v:exception)
endtry

call vimtest#Quit()
