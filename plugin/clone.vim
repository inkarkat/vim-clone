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
function! s:CloneAs( filespec, isSplit, startLnum, endLnum )
    try
	let l:filetype = &l:filetype

	let l:contents = getline(a:startLnum, a:endLnum)

	execute (a:isSplit ? g:clone_splitmode . ' split' : 'edit') ingo#compat#fnameescape(a:filespec)
	call setline(1, l:contents)

	" Filetype detection will run on the new buffer containing the original
	" file, but may not succeed before the file contents have been restored.
	" Therefore, re-apply the original filetype, too.
	if ! empty(l:filetype)
	    let &l:filetype = l:filetype
	endif

	return 1
    catch /^Vim\%((\a\+)\)\=:E/
	call ingo#err#SetVimException()
	return 0
    endtry
endfunction
command! -bar -range=% -nargs=1 -complete=file CloneAs  if ! <SID>CloneAs(<q-args>, 0, <line1>, <line2>) | echoerr ingo#err#Get() | endif
command! -bar -range=% -nargs=1 -complete=file SCloneAs if ! <SID>CloneAs(<q-args>, 1, <line1>, <line2>) | echoerr ingo#err#Get() | endif

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
