" clone.vim: Create a duplicate clone of the current buffer.
"
" DEPENDENCIES:
"   - ingo/buffer.vim autoload script
"   - ingo/compat.vim autoload script
"   - ingo/err.vim autoload script
"   - ingo/event.vim autoload script
"   - ingo/fs/path.vim autoload script
"   - ingo/range.vim autoload script
"
" Copyright: (C) 2011-2017 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.10.020	08-Dec-2017	Replace :doautocmd with ingo#event#Trigger().
"   1.10.019	19-Nov-2017	ENH: Add a:isForce flag to clone#CloneAs() and
"				handle existing buffer.
"   1.03.018	08-Nov-2017	Use ingo#range#IsEntireBuffer().
"   1.03.017	11-Oct-2016	Trigger BufCloneFile after BufRead; else, the
"				BufRead will immediately undo the definition of
"				b:nofile done by my NofileDetect customizations.
"   1.03.016	15-Jul-2016	ENH: Also emit custom User BufCloneFile event.
"   1.02.015	23-May-2014	Also handle unreadable files (and directories).
"   1.02.014	07-May-2014	Avoid setting 'filetype' when it already has the
"				value of the original buffer, because even that
"				triggers FileType autocmds, and may result in
"				disturbing duplicate messages.
"   1.01.013	25-Apr-2014	Suppress BufNewFile event, and instead emit the
"				more appropriate BufRead event for the clone
"				buffer.
"   1.01.012	20-Mar-2014	Allow cloning into unloaded buffer.
"   1.00.011	17-Mar-2014	Handle automatic template insertion in the new
"				cloned buffer.
"				Check for existing buffer name and return error
"				in that case. This avoids the inconsistency that
"				the :file command causes an E95 whereas the
"				:edit / :split grabs and silently overrides the
"				existing buffer.
"				Also clone the original cursor position / window
"				view.
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

function! clone#CloneAs( isForce, filespec, isSplit, startLnum, endLnum )
    if bufexists(a:filespec) && bufloaded(a:filespec)
	let l:bufNr = bufnr(a:filespec)
	if l:bufNr == bufnr('')
	    call ingo#err#Set('Cannot clone buffer onto itself')
	    return 0
	elseif ! a:isForce
	    call ingo#err#Set('Buffer with this name already exists (add ! to override)')
	    return 0
	endif
    endif

    let l:save_eventignore = &eventignore
    set eventignore+=BufNewFile " Do not trigger template systems etc.; the appropriate event is BufRead, and we'll emit that instead.
    try
	let l:filetype = &l:filetype
	let l:fileformat = &l:fileformat
	let l:fileencoding = &l:fileencoding
	let l:isEntireBuffer = ingo#range#IsEntireBuffer(a:startLnum, a:endLnum)
	let l:view = winsaveview()

	let l:contents = getline(a:startLnum, a:endLnum)


	if exists('l:bufNr')
	    execute (a:isSplit ? g:clone_splitmode . ' ' . l:bufNr . 'sbuffer' : l:bufNr . 'buffer')
	elseif ingo#fs#path#Exists(a:filespec)
	    " We don't want to read the original file from disk, but rather
	    " create a new empty buffer with the same name.

	    " In between the two separate steps, autocmds may change the CWD.
	    " Go through the absolute filespec to be safe.
	    let l:absoluteFilespec = fnamemodify(a:filespec, ':p')

	    silent execute (a:isSplit ? g:clone_splitmode . ' new' : 'enew')
	    execute 'file' ingo#compat#fnameescape(fnamemodify(l:absoluteFilespec, ':~:.'))
	    " Note: If the :file command failed, this would leave behind an
	    " unnamed buffer. But our initial bufexists() check should prevent
	    " any failures.
	else
	    execute (a:isSplit ? g:clone_splitmode . ' split' : 'edit') ingo#compat#fnameescape(a:filespec)
	endif

	if ! ingo#buffer#IsEmpty()
	    " A template system (:autocmd BufNewFile) may have seeded the new
	    " buffer with contents; we don't want those. Or this was an existing
	    " buffer.
	    silent %delete _
	endif

	let &l:fileformat = l:fileformat
	let &l:fileencoding = l:fileencoding

	call setline(1, l:contents)

	if ! l:isEntireBuffer
	    let l:view.lnum -= a:startLnum - 1
	    let l:view.topline -= a:startLnum - 1
	endif
	silent! call winrestview(l:view)

	doautocmd BufRead
	call ingo#event#TriggerCustom('BufCloneFile')

	if ! empty(l:filetype) && &l:filetype !=# l:filetype
	    let &l:filetype = l:filetype
	endif

	return 1
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    finally
	let &eventignore = l:save_eventignore
    endtry
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
