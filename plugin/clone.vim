" clone.vim: Create a duplicate clone of the current buffer.
"
" DEPENDENCIES:
"   - ingo/compat.vim autoload script
"   - ingo/err.vim autoload script
"
" Copyright: (C) 2011-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	008	08-Aug-2013	Move escapings.vim into ingo-library.
"	007	14-Jun-2013	Abort on error through ingo/err.vim.
"	007	10-Feb-2012	Add g:clone_splitmode configuration variable.
"	006	23-Jan-2012	The cloned buffer should always be editable.
"	005	17-Nov-2011	Rename :SplitAs to :SCloneAs.
"	004	08-Nov-2011	file creation from ingocommands.vim.
"	001	01-Oct-2011	Initial implementation.
"				file creation

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_clone') || (v:version < 700)
    finish
endif
let g:loaded_clone = 1

if ! exists('g:clone_splitmode')
    " Because of the split semantics, the mode needs to be the opposite of the
    " 'splitbelow' setting.
    let g:clone_splitmode = (&splitbelow ? 'aboveleft' : 'belowright')
endif


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

	" Cloning is done via :file {name}: "If the buffer did have a name, that
	" name becomes the alternate-file name. An unlisted buffer is created to
	" hold the old name."
	execute 'file' ingo#compat#fnameescape(a:filespec)
	" Re-list the buffer to hold the old name.
	call setbufvar('#', '&buflisted', 1)
	" The clone should always be editable, so do not inherit those buffer
	" settings.
	setlocal noreadonly modifiable

	if a:isSplit
	    execute g:clone_splitmode 'sbuffer #'
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

	return 1
    catch /^Vim\%((\a\+)\)\=:E/
	call ingo#err#SetVimException()
	return 0
    endtry
endfunction
"command! -bar -nargs=1 -complete=file CloneAs file <args> | call setbufvar('#', '&buflisted', 1)
"command! -bar -nargs=1 -complete=file SCloneAs CloneAs <args> | sbuffer # | wincmd p
command! -bar -range=% -nargs=1 -complete=file CloneAs  if ! <SID>CloneAs(<q-args>, 0, <line1>, <line2>) | echoerr ingo#err#Get() | endif
command! -bar -range=% -nargs=1 -complete=file SCloneAs if ! <SID>CloneAs(<q-args>, 1, <line1>, <line2>) | echoerr ingo#err#Get() | endif

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
