CLONE
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

Often, it is efficient to base a new file (e.g. unit test, meeting minutes) on
an existing one, and just apply the changes instead of re-creating the entire
file. In Vim, one can create a duplicate copy of the current buffer via
:write {newfile} or :saveas {newfile}. But the former doesn't
automatically open the cloned file, whereas with the latter, you're losing the
buffer containing the original file. Also, the identical clone is immediately
persisted, which may confuse automated build tools (or yourself, should you
get interrupted and forget to make the actual modifications). Transferring the
buffer contents via :yank is also cumbersome and clobbers a register.

This plugin offers a :CloneAs command that duplicates the current buffer (or
only parts of it) without persisting the clone right away (only on :w), and
keeping the original buffer loaded and unmodified inside Vim (with
:SCloneAs, it'll even be kept displayed in a window).

Oftentimes, duplication in source code is a code smell. Please use this plugin
responsibly ;-)

### SEE ALSO

The cloneSimilar.vim plugin ([vimscript #4897](http://www.vim.org/scripts/script.php?script_id=4897)) adds additional command
variants powered by the EditSimilar.vim ([vimscript #2544](http://www.vim.org/scripts/script.php?script_id=2544)) plugin.

USAGE
------------------------------------------------------------------------------

    :[range]CloneAs[!] {file}
                            Duplicate and edit the current buffer / specified
                            lines with a new name, keep the existing one.
                            Writes over existing buffer with [!].
    :[range]SCloneAs[!] {file}
                            Duplicate and split the current buffer / specified
                            lines with a new name, keep the existing one.

                            The original cursor position / window view will be
                            kept, as well as the 'fileformat', 'fileencoding' and
                            'filetype' settings of the original buffer.

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-clone
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim clone*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.
- Requires the ingo-library.vim plugin ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)), version 1.033 or
  higher.

CONFIGURATION
------------------------------------------------------------------------------

For a permanent configuration, put the following commands into your vimrc:

The :SCloneAs command uses the default 'splitbelow' behavior; you can
influence this via:

    let g:clone_splitmode = 'belowright'

CONTRIBUTING
------------------------------------------------------------------------------

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-clone/issues or email (address below).

HISTORY
------------------------------------------------------------------------------

##### 1.10    RELEASEME
- ENH: Also emit custom User BufCloneFile event.

__You need to update to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.033!__
- ENH: Support [!] to overwrite an existing target buffer.

##### 1.02    19-Jun-2014
- Avoid setting 'filetype' when it already has the value of the original
  buffer, because even that triggers FileType autocmds, and may result in
  disturbing duplicate messages.
- Also handle unreadable files (and directories).

__You need to update to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.019!__

##### 1.01    25-Apr-2014
- Allow cloning into unloaded buffer.
- Suppress BufNewFile event, and instead emit the more appropriate BufRead
  event for the clone buffer.

##### 1.00    18-Mar-2014
- First published version.

##### 0.01    11-Oct-2011
- Started development.

------------------------------------------------------------------------------
Copyright: (C) 2011-2020 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat &lt;ingo@karkat.de&gt;
