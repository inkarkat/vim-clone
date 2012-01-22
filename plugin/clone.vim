" clone.vim: Create a duplicate clone of the current buffer. 
"
" DEPENDENCIES:
"   - escapings.vim autoload script. 
"
" Copyright: (C) 2011 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"	005	17-Nov-2011	Rename :SplitAs to :SCloneAs. 
"	004	08-Nov-2011	file creation from ingocommands.vim. 
"	001	01-Oct-2011	Initial implementation. 
"				file creation

" Avoid installing twice or when in unsupported Vim version. 
if exists('g:loaded_clone') || (v:version < 700)
    finish
endif
let g:loaded_clone = 1

":[range]CloneAs	Duplicate and edit the current buffer / specified lines
"			with a new name, keep the existing one. 
":[range]SCloneAs	Duplicate and split the current buffer / specified lines
"			with a new name, keep the existing one. 
function! s:UpdateBuffer( isInBuffer, bufname, contents, filetype )
    if ! empty(a:bufname) && empty(a:contents)
	" Nothing to do. 
	return
    endif

    if ! a:isInBuffer
	buffer #
    endif

    if empty(a:bufname)
	silent! keepalt 0file
    endif

    if ! empty(a:contents)
	silent %delete _
	call setline(1, a:contents)

	if ! empty(a:filetype)
	    let &l:filetype = a:filetype
	endif
    endif

    if ! a:isInBuffer
	buffer #
    endif
endfunction
function! s:CloneAs( filespec, isSplit, startLine, endLine )
    try
	let l:bufname = expand('%')
	let l:contents = []
	let l:filetype = &l:filetype

	if empty(l:bufname)
	    " An unlisted buffer will only be created if the buffer had a name. 
	    silent file _tempBufferNameForCloneAs_
	endif

	if &l:modified || empty(l:bufname) || ! filereadable(l:bufname)
	    let l:contents = getline(1, '$')
	endif

	execute 'file' escapings#fnameescape(a:filespec)
	call setbufvar('#', '&buflisted', 1)

	if a:isSplit
	    sbuffer #
	    call s:UpdateBuffer(1, l:bufname, l:contents, l:filetype)
	    wincmd p
	else
	    call s:UpdateBuffer(0, l:bufname, l:contents, l:filetype)
	endif
	" On :file, the original buffer will lose the modifications that have
	" not yet been persisted. 
	" Filetype detection will run on the new buffer containing the original
	" file, but may not succeed before the file contents have been restored.
	" Therefore, re-apply the original filetype, too. 

	" If the original buffer was unnamed, the clone is empty, too. 
	if empty(l:bufname)
	    " Re-use the existing function for this, but do not apply the :0file
	    " stuff, so pass a dummy bufname instead of l:bufname. 
	    call s:UpdateBuffer(1, 'clonebuffer', l:contents)
	endif

	if a:endLine < line('$')
	    silent execute (a:endLine + 1) . ',$delete _'
	endif
	if a:startLine > 1
	    silent execute '1,' . (a:startLine - 1) . 'delete _'
	endif
    catch /^Vim\%((\a\+)\)\=:E/
	" v:exception contains what is normally in v:errmsg, but with extra
	" exception source info prepended, which we cut away. 
	let v:errmsg = substitute(v:exception, '^Vim\%((\a\+)\)\=:', '', '')
	echohl ErrorMsg
	echomsg v:errmsg
	echohl None
    endtry
endfunction
"command! -bar -nargs=1 -complete=file CloneAs file <args> | call setbufvar('#', '&buflisted', 1)
"command! -bar -nargs=1 -complete=file SCloneAs CloneAs <args> | sbuffer # | wincmd p
command! -bar -range=% -nargs=1 -complete=file CloneAs  call <SID>CloneAs(<q-args>, 0, <line1>, <line2>)
command! -bar -range=% -nargs=1 -complete=file SCloneAs call <SID>CloneAs(<q-args>, 1, <line1>, <line2>)

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
