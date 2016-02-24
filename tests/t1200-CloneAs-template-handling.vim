" Test handling automatic insertion of templates for new buffers.

autocmd BufNewFile *.txt call setline(1, ['# Template', '# inserted', '# here'])
edit ++enc=utf-16le text.txt

CloneAs new.txt

call vimtest#SaveOut()
call vimtest#Quit()
