" clone.vim: Create a duplicate clone of the current buffer.
"
" DEPENDENCIES:
"   - ingo/compat.vim autoload script
"   - ingo/err.vim autoload script
"
" Copyright: (C) 2011-2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	010	15-Mar-2014	Split off autoload script and documentation.
"				Apply 'fileformat' and 'fileencoding' before
"				pasting the buffer contents.
"				Make the two-step buffer creation in case of
"				existing file safe against changes to CWD.
"	009	14-Mar-2014	Complete reimplementation without using :file.
"				This is way simpler (no workarounds for
"				unpersisted changes) and doesn't have the
"				negative side effects of having the cloned file
"				contained in the argument list, and having all
"				buffer- / window-local variables assigned to the
"				clone.
"	008	08-Aug-2013	Move escapings.vim into ingo-library.
"	007	14-Jun-2013	Abort on error through ingo/err.vim.
"	007	10-Feb-2012	Add g:clone_splitmode configuration variable.
"	006	23-Jan-2012	The cloned buffer should always be editable.
"	005	17-Nov-2011	Rename :SplitAs to :SCloneAs.
"	004	08-Nov-2011	file creation from ingocommands.vim.
"	001	01-Oct-2011	Initial implementation.
"				file creation

function! clone#CloneAs( filespec, isSplit, startLnum, endLnum )
    try
	let l:filetype = &l:filetype
	let l:fileformat = &l:fileformat
	let l:fileencoding = &l:fileencoding

	let l:contents = getline(a:startLnum, a:endLnum)

	if filereadable(a:filespec)
	    " We don't want to read the original file from disk, but rather
	    " create a new empty buffer with the same name.

	    " In between the two separate steps, autocmds may change the CWD.
	    " Go through the absolute filespec to be safe.
	    let l:absoluteFilespec = fnamemodify(a:filespec, ':p')

	    silent execute (a:isSplit ? g:clone_splitmode . ' new' : 'enew')
	    execute 'file' ingo#compat#fnameescape(fnamemodify(l:absoluteFilespec, ':~:.'))
	else
	    execute (a:isSplit ? g:clone_splitmode . ' split' : 'edit') ingo#compat#fnameescape(a:filespec)
	endif

	let &l:fileformat = l:fileformat
	let &l:fileencoding = l:fileencoding

	call setline(1, l:contents)

	if ! empty(l:filetype)
	    let &l:filetype = l:filetype
	endif

	return 1
    catch /^Vim\%((\a\+)\)\=:E/
	call ingo#err#SetVimException()
	return 0
    endtry
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
