# Neovim IDE configuration

This is my configuration for [Neovim](https://neovim.io/), I mostly work on web frontend development.

- **Editor** - enhanced vim motions, extended text objects, folding
- **Code** - formatter, comments, code completion, AI powered suggestions
- **LSP** - Language Server Protocol client, symbols navigation, diagnostics
- **Syntax** - highlighting, syntax aware motions and text objects
- **Git integration** - status, diffview, commit message editor, buffer integration
- **Search** - fuzzy find anything, file and workspace scoped search and replace
- **Application** - files and directory explorer, notifications, command palette

<sub>Works on Neovim v0.10.4</sub>

## Screenshots

![screenshot](https://raw.githubusercontent.com/ruicsh/nvim-config/refs/heads/main/assets/screenshot.png)

## Theme

- **NordStone** - Custom theme based on [Nord Theme](https://www.nordtheme.com/).
- [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads)

## Plugins

### UI

- [mini.clue](https://github.com/echasnovski/mini.clue) - Keybidings helper
- [mini.notify](https://github.com/echasnovski/mini.notify) - Notifications
- [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) - Files tree explorer
- [oil.nvim](https://github.com/stevearc/oil.nvim) - Edit filesystem like a buffer
- [snacks.nvim](https://github.com/folke/snacks.nvim) - Pickers, statuscolumn, indent lines

### Editing

- [csvview.nvim](https://github.com/hat0uma/csvview.nvim) - CSV editing
- [flash.nvim](https://github.com/folke/flash.nvim) - Search labels, enhanced character motions
- [mini.ai](https://github.com/echasnovski/mini.ai) - around/inside textobjects
- [mini.move](https://github.com/echasnovski/mini.move) - move lines/selection
- [mini.operators](https://github.com/echasnovski/mini.operators) - Text edit operators
- [mini.surround](https://github.com/echasnovski/mini.surround) - Surround pairs
- [nvim-spider](https://github.com/chrisgrieser/nvim-spider) - Move by subwords (camelCase, ...)

### Coding

- [CopilotChat.nvim](https://github.com/CopilotC-Nvim/CopilotChat.nvim) - AI assistant
- [conform.nvim](https://github.com/stevearc/conform.nvim) - Formatter
- [copilot.lua](https://github.com/zbirenbaum/copilot.lua) - AI suggestions
- [mini.hipatterns](https://github.com/echasnovski/mini.hipatterns) - CSS Colors
- [mini.pairs](https://github.com/echasnovski/mini.pairs) - Autopairs
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - Autocompletion
- [timber.nvim](https://github.com/Goose97/timber.nvim) - Insert log statements

### LSP/Syntax

- [lazydev.nvim](https://github.com/folke/trouble.nvim) - Lua language server
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - Config
- [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) - AST aware text objects
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Treesitter syntax parsers
- [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) - Auto close/rename HTML tags
- [treewalker.nvim](https://github.com/aaronik/treewalker.nvim) - Fast navigation around the AST tree
- [ts-comments.nvim](https://github.com/folke/ts-comments.nvim) - Custom comments configurations per language

### Git

- [diffview](https://github.com/sindrets/diffview.nvim) - Diffview/Git log
- [fugitive.vim](https://github.com/tpope/vim-fugitive) - Git wrapper
- [mini.diff](https://github.com/echasnovski/mini.diff) - Git diff/hunks

## Config

Complex configuration options.

|                                                                                                        |                                                           |
| ------------------------------------------------------------------------------------------------------ | --------------------------------------------------------- |
| [foldtext](https://github.com/ruicsh/nvim-config/blob/main/plugin/config/foldtext.lua)                 | Text displayed for a closed fold                          |
| [quickfixtextfunc](https://github.com/ruicsh/nvim-config/blob/main/plugin/config/quickfixtextfunc.lua) | Text to display in the quickfix and location list windows |
| [statusline](https://github.com/ruicsh/nvim-config/blob/main/plugin/config/statusline.lua)             | Content of the status line                                |

## Commands

Custom built commands to be invoked on the `cmdline` or with keymaps.

|                                                                                                                            |                                              |
| -------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------- |
| [CopyFilePathToClipboard](https://github.com/ruicsh/nvim-config/blob/main/plugin/commands/copy-file-path-to-clipboard.lua) | Copy current buffer's path to clipboard.     |
| [JumpToLastVisitedBuffer](https://github.com/ruicsh/nvim-config/blob/main/plugin/commands/jump-to-last-visited-buffer.lua) | Jump to last visited buffer (including Oil). |
| [OpenChangesInQuickfix](https://github.com/ruicsh/nvim-config/blob/main/plugin/commands/quickfix-lists.lua)                | Open jumplist/changelist on quickfix window  |
| [ToggleTerminal](https://github.com/ruicsh/nvim-config/blob/main/plugin/commands/toggle-terminal.lua)                      | Toggle terminal open/closed                  |
| [WindowToggleMaximize](https://github.com/ruicsh/nvim-config/blob/main/plugin/commands/window-toggle-maximize.lua)         | Maximize and restore current window.         |

## Ftplugins

Custom configuration, keymaps and features dependent on the file's type.

|                                                                                                |                    |
| ---------------------------------------------------------------------------------------------- | ------------------ |
| [csv](https://github.com/ruicsh/nvim-config/blob/main/plugin/ftplugin/csv.lua)                 | CSV                |
| [fugitive](https://github.com/ruicsh/nvim-config/blob/main/plugin/ftplugin/fugitive.lua)       | fugitive           |
| [gitcommit](https://github.com/ruicsh/nvim-config/blob/main/plugin/ftplugin/gitcommit.lua)     | git commit message |
| [help](https://github.com/ruicsh/nvim-config/blob/main/plugin/ftplugin/help.lua)               | help               |
| [htmlangular](https://github.com/ruicsh/nvim-config/blob/main/plugin/ftplugin/htmlangular.lua) | Angular Templates  |
| [qf](https://github.com/ruicsh/nvim-config/blob/main/plugin/ftplugin/qf.lua)                   | Quickfix           |
| [scss](https://github.com/ruicsh/nvim-config/blob/main/plugin/ftplugin/scss.lua)               | Sass               |
| [terminal](https://github.com/ruicsh/nvim-config/blob/main/plugin/ftplugin/terminal.lua)       | Terminal windows   |
| [text](https://github.com/ruicsh/nvim-config/blob/main/plugin/ftplugin/text.lua)               | Text, Markdown     |

## Autocmds

New features built around autocmds (events).

|                                                                                                                                |                                                                       |
| ------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------- |
| [auto-resize-splits](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/auto-resize-splits.lua)                   | Auto resize splits when window is resized                             |
| [cleanup-cmdline](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/cleanup-cmdline.lua)                         | Cleanup command line after use                                        |
| [create-intermediate-dirs](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/create-intermediate-dirs.lua)       | Create intermediate directories                                       |
| [disable-new-line-comments](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/disable-new-line-comments.lua)     | Disable new line comments                                             |
| [git-branch](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/git-branch.lua)                                   | Keep the git branch updated on a buffer local variable                |
| [load-env-vars](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/load-env-vars.lua)                             | Load environment variables, global and project scoped.                |
| [lsp-attach](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/lsp-attach.lua)                                   | LSP diagnostics, keymaps and custom handlers                          |
| [open-directory-oil](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/open-directory-oil.lua)                   | If neovim is opened with a directory as argument open oil-filemanager |
| [restore-changed-files](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/restore-changed-files.lua)             | On VimEnter, open all git changed files in current working directory  |
| [scoped-tabs](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/scoped-tabs.lua)                                 | Keep buffers in tabs scoped to the tab they were opened in            |
| [scroll-eof](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/scroll-eof.lua)                                   | Scroll past the end of file with scrolloff                            |
| [show-cursorline-only-active](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/show-cursorline-only-active.lua) | Show cursorline only on active window.                                |
| [toggle-hlsearch](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/toggle-hlsearch.lua)                         | Toogle off hlsearch when entering insert mode and the cursor is moved |
| [views](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/views.lua)                                             | Save and restore views for each buffer                                |
| [yank-highlight](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/yank-highlight.lua)                           | Highlight selection when yanking                                      |
| [yank-keep-cursor-position](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/yank-keep-cursor-position.lua)     | Keep cursor position on yank                                          |

## Custom

Random features added.

|                                                                                                                  |                                                 |
| ---------------------------------------------------------------------------------------------------------------- | ----------------------------------------------- |
| [close-shortcut](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/close-shortcut.lua)               | Use the same shortcut to close different panels |
| [inline-search-count](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/inline-search-count.lua)     | Search count inline indicator                   |
| [pause-folds-on-search](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/pause-folds-on-search.lua) | Pause folds on search                           |

# Mappings

### Files explorer

- `-` open directory explorer
- `<leader><leader>` fuzzy find files
- `<leader>ee` file tree explorer
- `<leader>pp` projects

### Directory explorer

- `<enter>` open
- `<c-v>` open entry in vertical split
- `<c-p>` preview
- `-` open parent directory
- `_` open current working directory (root)
- `gs` change sort
- `g.` toggle hidden
- `g\` toggle trash
- `<c-]>` close explorer

### Buffers

- `<c-]>` close
- `<leader>bC` close all
- `<leader>bo` close the other
- `<leader>,` open
- `<leader>.` recent

### Windows

- `|` switch windows
- `<c-w>[` move buffer to window on the left
- `<c-w>]` move buffer to window on the right
- `<c-]>` close window
- `<c-w>m` maximize window

### Tabs

- `gt` jump to next tab
- `gT` jump to previous tab
- `{number}gt` jump to tab {number}
- `<leader>tc` close tab
- `<leader>tn` new tab

### Navigation

- `s` jump with search labels
- `{` jump up 6 lines
- `}` jump down 6 lines
- `'0` jump to position where last exited Vim

### Editing

- `[<space>` add blank line above cursor
- `]<space>` add blank line below cursor
- `[e` move line/selection above
- `]e` move line/selection below
- `[p` paste to new line above
- `]p` paste to new line below
- `ycc` duplicate a line, comment out the first line.
- `U` redo

### Insert mode navigation

- `<c-a>` jump to beginning of line
- `<c-b>` jump backwards one character
- `<c-d>` delete character in front of cursor
- `<c-e>` jump to end of line
- `<c-f>` jump forward one character
- `<c-r>` paste from clipboard
- `<c-u>` delete before the cursor in current line
- `<c-w>` delete word before

### Text objects

- `a` function argument
- `b` brackets ({}, (), [])
- `f` function
- `g` buffer
- `h` git hunk
- `q` quotes ("", '', ``)
- `t` tags

### Operators

- `gsa{motion}{char}` add surrounding character
- `gsd{char}` delete surrounding character
- `gsr{target}{replacement}` replace surrounding character
- `<leader>r{motion}` replace with last yank
- `<leader>m{motion}` multiply
- `<leader>s{motion}` sort

### Search

- `/` find in document forward
- `?` find in document backward
- `<leader>f` fuzzy find in workspace

### Autocompletion

- `<tab>` complete/next entry
- `<s-tab>` previous entry
- `<cr>` confirm
- `<c-]>` abort

### AI chat

- `<leader>aa` open
- `<leader>am` models
- `<c-l>` accept diff
- `<c-x>` reset

### AI operations

- `<leader>ae` explain
- `<leader>af` fix
- `<leader>ai` implement
- `<leader>ao` optimize
- `<leader>ar` refactor
- `<leader>ar` review (ft:fugitive)

### AI suggestions

- `<c-l>` accept
- `<c-j>` next
- `<c-k>` previous
- `<c-]>` dismiss

### Logging

- `glv` insert variable log below
- `glV` insert variable log above
- `glp` insert statement log below
- `glP` insert statement log above
- `glb` insert batch log below
- `glt` insert timestamp below
- `glT` insert timestamp below
- `<leader>glt` insert timestamp above/below

### Syntax (AST)

- `<s-left>` jump to parent node
- `<s-right>` jump to child node
- `<s-up>` jump to previous sibling node
- `<s-down>` jump to next sibling node
- `<leader>v` start node target mode (with search labels)
- `<c-s-left>` select current node
- `<c-s-left>` increase selection (on node selection mode)
- `<c-s-right>` decrease selection (on node selection mode)
- `<c-s-h>` swap with lateral previous node
- `<c-s-l>` swap with lateral next node
- `<c-s-k>` swap with vertical previous node
- `<c-s-j>` swap with vertical next node

### LSP

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

### TypeScript

- `<leader>tso` organize imports
- `<leader>tss` sort imports
- `<leader>tsu` remove unused imports
- `<leader>tsd` jump to source definition
- `<leader>tsr` rename file and update changes to connected files

### Diagnostics

- `<leader>dd` open diagnostics for buffer
- `[d` jump to previous diagnostic
- `]d` jump to next diagnostic

### Git

- `[c` previous hunk
- `]c` next hunk
- `ghh` stage hunk
- `gHh` reset hunk
- `gh_` stage line
- `gH_` reset line
- `<leader>hb` blame line
- `<leader>hd` diff buffer
- `<leader>hdd` diff workspace
- `<leader>hh` status
- `<leader>hl` log file/selection
- `<leader>hll` log
- `<leader>ho` push -u origin HEAD
- `<leader>hp` push
- `<leader>hx` git open in browser

### Merge Conflicts

- `co` choose ours
- `ct` choose theirs
- `cb` choose both
- `c0` choose none
- `]x` jump to next conflict
- `[x` jump to previous conflict

### Quickfix

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
- `<c-p>` open previous list
- `<c-n>` open next list

### Marks

- `''` jump to position before last jump
- `'.` jump to position where last change was made
- `'0` jump to position when last exited Vim
- `'{a-z}` jump to line in local mark
- `'{A-Z}` jump to line in global mark
- `'{0-9}` jump to last lines when last exited Vim

### Folds

- `<tab>` toggle
- `<s-tab>` toggle one foldlevel
- `[z` more
- `]z` reduce
- `zR` set foldlevel to zero
- `zM` set foldlevel to maximum

### Application

- `<leader>nc` show commands
- `<leader>nh` help
- `<leader>nk` keyboard shortcuts

<div style="margin-top:80px"></div>

---

<sup>&copy; 2024 Rui Costa, MIT License</sup>
