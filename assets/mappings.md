# Mappings

### Files explorer

- `\` toggle tree explorer
- `-` open directory explorer
- `<leader>f` fuzzy find files
- `<leader>,` fuzzy find recent files

#### Tree explorer

- `<enter>` open
- `a` add
- `r` rename
- `c` duplicate
- `y` copy
- `d` delete
- `x` cut
- `p` paste
- `<c-v>` open file to the side
- `<c-]>` close explorer
- `[c` previous git change
- `]c` next git change

#### Directory explorer

- `<enter>` open
- `<c-v>` open entry in vertical split
- `<c-p>` preview
- `-` open parent directory
- `_` open current working directory (root)
- `gs` change sort
- `g.` toggle hidden
- `g\` toggle trash
- `<c-]>` close explorer

### Buffers, Windows and Tabs

#### Buffers

- `§` list buffers
- `<bs>` next opened buffer
- `<s-bs>` previous opened buffer
- `<c-]>` close buffer
- `<leader>bC` close all buffers
- `<leader>bo` close the other buffers

#### Windows

- `|` switch windows
- `<c-w>[` move buffer to window on the left
- `<c-w>]` move buffer to window on the right
- `<c-w>m` maximize window
- `<c-]>` close window

#### Tabs

- `gt` jump to next tab
- `gT` jump to previous tab
- `{number}gt` jump to tab {number}
- `<leader>td` close tab
- `<leader>tn` new tab
- `<leader>to` close all other
- `<leader>tH` move current tab to before
- `<leader>tL` move current tab to after

### Editor

#### Navigation

- `{` jump up 6 lines
- `}` jump down 6 lines
- `H` jump to first non-empty character in line
- `L` jump to end of line
- `'0` jump to position where last exited Vim

#### Editing

- `[<space>` add blank line above cursor
- `]<space>` add blank line below cursor
- `[e` move line/selection above
- `]e` move line/selection below
- `[p` paste to new line above
- `]p` paste to new line below
- `S{char}` surround selection (visual mode)
- `cs{target}{replacement}` change surrounding character
- `ds{char}` delete surrounding character
- `ys{motion}{char}` insert surrounding character
- `yc` duplicate a line, comment out the first line.
- `U` redo

#### Insert mode navigation

- `<c-a>` jump to beginning of line
- `<c-b>` jump backwards one character
- `<c-d>` delete character in front of cursor
- `<c-e>` jump to end of line
- `<c-f>` jump forward one character
- `<c-r>` paste from clipboard
- `<c-u>` delete before the cursor in current line
- `<c-w>` delete word before

#### Text objects

- `#` color in CSS
- `S` word in camelCase, PascalCase, snake_case and kebab-case
- `a` function argument
- `b` brackets ({}, (), [])
- `c` class in CSS
- `d` code blocks (if, while, for, ...)
- `f` function
- `k` key, left side of assignment
- `q` quotes ("", '', ``)
- `v` value, right side of assignment
- `x` HTML attribute

#### Sorting

- `<leader>so` sort selection
- `<leader>s(` sort inside ()
- `<leader>s[` sort inside []
- `<leader>s{` sort inside {}
- `<leader>s'` sort inside ''
- `<leader>s"` sort inside ""
- `<leader>s}` sort paragraph

#### Search

- `/` find in document forward
- `?` find in document backward
- `<leader>ff` find in workspace
- `<leader>fd` find in directory
- `<leader>r` replace in selection/document/workspace

### Coding

#### Autocomplete

- `<cr>` accept
- `<c-n>` select next entry
- `<c-p>` select previous entry
- `<c-e>` close menu

#### Debug

- `glv` insert variable log below
- `glV` insert variable log above
- `glp` insert statement log below
- `glP` insert statement log above
- `glb` insert batch log below

#### Syntax (AST)

- `<cr>` start/increase node selection
- `<bs>` decrease node selection
- `<s-left>` jump to parent node
- `<s-down>` jump to next sibling node
- `<s-up>` jump to previous sibling node
- `<s-right>` jump to child node
- `[a` jump to previous argument start
- `]a` jump to next argument start
- `[[` jump to previous function start
- `]]` jump to next function start

#### LSP

- `K` display hover information for symbol
- `gO` list symbols in document
- `gd` jump to definition
- `go` jump to type definition
- `gra` code actions
- `grt` jump to type definition
- `gri` jump to implementation
- `grj` incoming calls
- `grk` outgoing calls
- `grn` rename symbol
- `grr` list references
- `grI` toggle inlay hints
- `gD` jump to declaration
- `[r` jump to previous symbol reference
- `]r` jump to next symbol reference
- `<c-s>` display signature help

#### TypeScript

- `<leader>tso` organize imports
- `<leader>tss` sort imports
- `<leader>tsu` remove unused imports
- `<leader>tsd` jump to source definition
- `<leader>tsr` rename file and update changes to connected files

#### Diagnostics

- `<leader>dd` open diagnostics for buffer
- `[d` jump to previous diagnostic
- `]d` jump to next diagnostic

#### Debugger

- `<c-9>`toggle breakpoint
- `<c-5>` start
- `<c-s-5>` stop
- `<c-->` step into
- `<c-s-->` step out
- `<c-0>` step over
- `<leader>ki` hover
- `<leader>dB` set breakpoint condition
- `<leader>dC` run to cursor
- `<leader>da` run with args
- `<leader>dg` go to line
- `<leader>dj` go down in the stacktrace
- `<leader>dk` go up in the stacktrace
- `<leader>dl` run last
- `<leader>dp` pause
- `<leader>dr` toggle REPL
- `<leader>ds` session

### Git

- `<leader>hf` list changed files
- `<leader>hg` diffview
- `<leader>hh` status
- `<leader>hj` log
- `<leader>ho` push set-upstream origin HEAD
- `<leader>hp` push
- `<leader>hr` reset hunk
- `<leader>hR` reset file
- `<leader>hs` stage hunk
- `<leader>hS` stage file
- `<leader>hu` unstage hunk
- `<leader>hv` preview change
- `<leader>hy` share file permalink
- `[c` previous change
- `]c` next change

#### Diffview

- `<up>` open diff for previous file
- `<down>` open diff for next file
- `cc` commit
- `s` stage file
- `X` reset file
- `<c-]>` close panel

#### Merge Conflicts

- `co` choose ours
- `ct` choose theirs
- `cb` choose both
- `c0` choose none
- `]x` jump to next conflict
- `[x` jump to previous conflict

### UI

#### Quickfix

- `<leader>qq` toggle quickfix list
- `<leader>ql` toggle location list
- `<leader>qc` toggle changes list
- `<leader>qj` toggle jumps list
- `[q` previous entry
- `]q` next entry
- `[Q` first entry
- `]Q` last entry
- `[<c-q>` previous file
- `]<c-q>` next file
- `<leader>r` search and replace on all entries
- `dd` remove entry
- `<c-p>` open previous list
- `<c-n>` open next list

#### Marks

- `''` jump to position before last jump
- `'.` jump to position where last change was made
- `'0` jump to position when last exited Vim
- `'{a-z}` jump to line in local mark
- `'{A-Z}` jump to line in global mark
- `'{0-9}` jump to last lines when last exited Vim

#### Folds

- `zr` decrement foldlevel
- `zm` increment foldlevel
- `zR` decrement foldlevel to zero
- `zM` increment foldlevel to maximum
- `zo` open current fold
- `zc` close current fold
- `zO` open current fold recursively
- `zC` close current fold recursively
- `za` toggle fold
- `zA` toggle fold recursively
- `[z` jump to parent fold
- `zk` jump to previous fold
- `zj` jump to next fold

#### Workspaces

- `<leader>pp` list workspaces

#### Application

- `<leader>n,` search configuration / open settings
- `<leader>n<` open settings (JSON) _(only vscode)_
- `<leader>nn` show notifications history _(only neovim)_
- `<leader>nc` show commands
- `<leader>nh` help
- `<leader>nk` keyboard shortcuts
- `<leader>nK` keyboard shortcuts (JSON) _(only vscode)_
- `<leader>nt` select fuzzy finder to use _(only neovim)_
- `<leader>vb` toggle sidebar visibility _(only vscode)_

<div style="margin-top:80px"></div>

---

<sup>&copy; 2024 Rui Costa, MIT License</sup>
