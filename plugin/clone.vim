" clone.vim: Create a duplicate clone of the current buffer.
"
" DEPENDENCIES:
"   - clone.vim autoload script
"   - ingo/err.vim autoload script
"
" Copyright: (C) 2011-2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.010	15-Mar-2014	Split off autoload script and documentation.
"				New implementation doesn't need reversal of
"				'splitbelow'.
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

"- configuration ---------------------------------------------------------------

if ! exists('g:clone_splitmode')
    let g:clone_splitmode = (&splitbelow ? 'belowright' : 'aboveleft')
endif


"- commands --------------------------------------------------------------------

command! -bar -range=% -nargs=1 -complete=file CloneAs  if ! clone#CloneAs(<q-args>, 0, <line1>, <line2>) | echoerr ingo#err#Get() | endif
command! -bar -range=% -nargs=1 -complete=file SCloneAs if ! clone#CloneAs(<q-args>, 1, <line1>, <line2>) | echoerr ingo#err#Get() | endif

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
