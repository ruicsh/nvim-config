# Neovim IDE configuration

This is my configuration for [Neovim](https://neovim.io/), mostly for frontend development (typescript, css, python, rust).

- **Editor** - enhanced vim motions, extended text objects, folding
- **Code** - formatter, comments, code completion, AI powered suggestions
- **AI Assistant** - suggestions, chat, system prompts, operations, chat history
- **LSP** - Language Server Protocol client, symbols navigation, diagnostics
- **Syntax** - highlighting, syntax aware motions, text objects
- **Debugger** - Debug Adapter Protocol client, breakpoints, stack traces, locals
- **Git integration** - status, diffview, commit message editor, buffer integration
- **Search** - fuzzy find anything, file, workspace scoped search and replace
- **UI** - files and directory explorer, notifications, command palette, bookmarks

<sub>Works on Neovim v0.11 (and vscode-neovim)</sub>

## Screenshots

![screenshot](https://raw.githubusercontent.com/ruicsh/nvim-config/refs/heads/main/assets/screenshot.png)

## Theme

- **NordStone** - Custom theme based on [Nord Theme](https://www.nordtheme.com/).
- [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads)

## Plugins

<sub>37 plugins</sub>

### UI

- [flash.nvim](https://github.com/folke/flash.nvim) - Search labels
- [gx.nvim](https://github.com/chrishrb/gx.nvim) - Open links/files
- [mini.clue](https://github.com/echasnovski/mini.clue) - Keybindings helper
- [mini.notify](https://github.com/echasnovski/mini.notify) - Notifications
- [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) - Files tree explorer
- [oil.nvim](https://github.com/stevearc/oil.nvim) - Edit filesystem like a buffer
- [other.nvim](https://github.com/rgroli/other.nvim) - Open alternative files
- [snacks.nvim](https://github.com/folke/snacks.nvim) - Pickers, statuscolumn, indent lines

### Editing

- [mini.ai](https://github.com/echasnovski/mini.ai) - around/inside textobjects
- [mini.move](https://github.com/echasnovski/mini.move) - move lines/selection
- [mini.operators](https://github.com/echasnovski/mini.operators) - Text edit operators
- [mini.pairs](https://github.com/echasnovski/mini.pairs) - Autopairs
- [mini.surround](https://github.com/echasnovski/mini.surround) - Surround pairs
- [nvim-spider](https://github.com/chrisgrieser/nvim-spider) - Move by subwords (camelCase, ...)

### Coding

- [blink.cmp](https://github.com/saghen/blink.cmp) - Autocomplete
- [conform.nvim](https://github.com/stevearc/conform.nvim) - Formatter
- [copilot.lua](https://github.com/zbirenbaum/copilot.lua) - AI suggestions
- [CopilotChat.nvim](https://github.com/CopilotC-Nvim/CopilotChat.nvim) - AI assistant
- [csvview.nvim](https://github.com/hat0uma/csvview.nvim) - CSV editing
- [mini.hipatterns](https://github.com/echasnovski/mini.hipatterns) - CSS Colors
- [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) - Auto close/rename HTML tags
- [ts-comments.nvim](https://github.com/folke/ts-comments.nvim) - Custom comments configurations per language

### LSP/Syntax

- [lazydev.nvim](https://github.com/folke/lazydev.nvim) - Lua language server
- [mason](https://github.com/williamboman/mason.nvim) - LSP package manager
- [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) - AST aware text objects
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Treesitter syntax parsers
- [treewalker.nvim](https://github.com/aaronik/treewalker.nvim) - AST aware navigation

### Debugging

- [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) - Debugger
- [nvim-dap](https://github.com/mfussenegger/nvim-dap) - Debugger Adapter Protocol
- [timber.nvim](https://github.com/Goose97/timber.nvim) - Insert log statements

### Git

- [diffview](https://github.com/sindrets/diffview.nvim) - diff, log
- [fugitive.vim](https://github.com/tpope/vim-fugitive) - status, commit, push
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) - hunks, blame

## Config

### Config

Complex configuration options.

|                                                                                                        |                                                           |
| ------------------------------------------------------------------------------------------------------ | --------------------------------------------------------- |
| [disable-unused](https://github.com/ruicsh/nvim-config/blob/main/plugin/config/disable-unused.lua)     | Disable unused native plugins                             |
| [foldtext](https://github.com/ruicsh/nvim-config/blob/main/plugin/config/foldtext.lua)                 | Text displayed for a closed fold                          |
| [quickfixtextfunc](https://github.com/ruicsh/nvim-config/blob/main/plugin/config/quickfixtextfunc.lua) | Text to display in the quickfix and location list windows |
| [statusline](https://github.com/ruicsh/nvim-config/blob/main/plugin/config/statusline.lua)             | Content of the status line                                |

### Commands

Custom built commands to be invoked on the `cmdline` or with keymaps.

|                                                                                                                            |                                                                      |
| -------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| [JumpToLastVisitedBuffer](https://github.com/ruicsh/nvim-config/blob/main/plugin/commands/jump-to-last-visited-buffer.lua) | Jump to last visited buffer (including Oil).                         |
| [LoadEnvVars](https://github.com/ruicsh/nvim-config/blob/main/plugin/commands/load-env-vars.lua)                           | Load environment variables, global, and project scoped.              |
| [OpenChangesInQuickfix](https://github.com/ruicsh/nvim-config/blob/main/plugin/commands/quickfix-lists.lua)                | Open jumplist/changelist on quickfix window                          |
| [RestoreChangedFiles](https://github.com/ruicsh/nvim-config/blob/main/plugin/commands/restore-changed-files.lua)           | On VimEnter, open all git changed files in current working directory |
| [SendBufferToWindow](https://github.com/ruicsh/nvim-config/blob/main/plugin/commands/send-buffer-to-window.lua)            | Send buffer to adjacent window                                       |
| [ToggleTerminal](https://github.com/ruicsh/nvim-config/blob/main/plugin/commands/toggle-terminal.lua)                      | Toggle terminal open/closed                                          |

### Filetypes

Custom configuration, keymaps, and features dependent on the file's type.

|                                                                                               |            |
| --------------------------------------------------------------------------------------------- | ---------- |
| [dockerfile](https://github.com/ruicsh/nvim-config/blob/main/plugin/filetypes/dockerfile.lua) | Dockerfile |
| [help](https://github.com/ruicsh/nvim-config/blob/main/plugin/filetypes/help.lua)             | help       |
| [python](https://github.com/ruicsh/nvim-config/blob/main/plugin/filetypes/python.lua)         | Python     |
| [qf](https://github.com/ruicsh/nvim-config/blob/main/plugin/filetypes/qf.lua)                 | Quickfix   |
| [rust](https://github.com/ruicsh/nvim-config/blob/main/plugin/filetypes/rust.lua)             | Rust       |
| [terminal](https://github.com/ruicsh/nvim-config/blob/main/plugin/filetypes/terminal.lua)     | Terminal   |
| [typescript](https://github.com/ruicsh/nvim-config/blob/main/plugin/filetypes/typescript.lua) | TypeScript |

### Autocmds

New features built around autocmds (events).

|                                                                                                                                |                                                                       |
| ------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------- |
| [auto-resize-splits](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/auto-resize-splits.lua)                   | Auto resize splits when window is resized                             |
| [cmdline-hit-enter](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/cmdline-hit-enter.lua)                     | Hit-enter on cmdline, auto-toggle on messages                         |
| [cleanup-cmdline](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/cleanup-cmdline.lua)                         | Cleanup command line after use                                        |
| [create-intermediate-dirs](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/create-intermediate-dirs.lua)       | Create intermediate directories                                       |
| [disable-newline-comments](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/disable-newline-comments.lua)       | Disable newline comments                                              |
| [lsp-attach](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/lsp-attach.lua)                                   | LSP diagnostics, keymaps, and custom handlers                         |
| [open-directory-oil](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/open-directory-oil.lua)                   | If neovim is opened with a directory as argument open oil             |
| [scoped-tabs](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/scoped-tabs.lua)                                 | Keep buffers in tabs scoped to the tab they were opened in            |
| [scroll-eof](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/scroll-eof.lua)                                   | Scroll past the end of file with scrolloff                            |
| [show-cursorline-only-active](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/show-cursorline-only-active.lua) | Show cursorline only on active window.                                |
| [toggle-hlsearch](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/toggle-hlsearch.lua)                         | Toggle off hlsearch when entering insert mode and the cursor is moved |
| [yank-highlight](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/yank-highlight.lua)                           | Highlight selection when yanking                                      |
| [yank-keep-cursor-position](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/yank-keep-cursor-position.lua)     | Keep cursor position on yank                                          |

### Custom

Random features added.

|                                                                                                                  |                                                 |
| ---------------------------------------------------------------------------------------------------------------- | ----------------------------------------------- |
| [bookmarks](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/bookmarks.lua)                         | Buffer global bookmarks (harpoon)               |
| [close-shortcut](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/close-shortcut.lua)               | Use the same shortcut to close different panels |
| [folds](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/folds.lua)                                 | Folding keymaps, autocmds and commands          |
| [indent-ast-nodes](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/indent-ast-nodes.lua)           | AST aware indentation                           |
| [inline-search-count](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/inline-search-count.lua)     | Search count inline indicator                   |
| [pause-folds-on-search](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/pause-folds-on-search.lua) | Pause folds on search                           |
| [yank-ring](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/yank-ring.lua)                         | Yank ring                                       |

## Keymaps

### Files explorer

- `-` open directory explorer
- `<c-s>` open in horizontal split
- `<c-v>` open in vertical split
- `<leader><leader>` fuzzy find files
- `<leader>ee` file tree explorer
- `<leader>.` last picker
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
- `<leader>,` pick opened
- `=` open alternate
- `=s` open alternate css
- `=t` open alternate test
- `=h` open alternate html
- `=c` open alternate component

### Bookmarks:

- `'{1-9}` jump to bookmark
- `m{1-9}` set bookmark
- `<leader>md` delete bookmark
- `<leader>mD` delete all bookmarks
- `<leader>'` list bookmarks
- `M{a-z}` delete mark

### Windows

- `|` switch windows
- `<c-w>[` move buffer to window on the left
- `<c-w>]` move buffer to window on the right
- `<c-]>` close window

### Navigation

- `{` jump up 6 lines
- `}` jump down 6 lines
- `/` find in document
- `?` find in document with labels
- `*` find work in document
- `<leader>/` find in workspace
- `<leader>?` find in directory
- `<leader>*` find word in workspace

### Editing

- `[<space>` add blank line above cursor
- `]<space>` add blank line below cursor
- `[e` move line/selection above
- `]e` move line/selection below
- `[p` paste to new line above
- `]p` paste to new line below
- `ycc` duplicate a line, comment out the first line.
- `U` redo
- `<leader>yf` copy relative filename
- `<leader>yd` copy relative directory

### Insert mode navigation

- `<c-a>` jump to beginning of line
- `<c-b>` jump backwards one character
- `<c-d>` delete character in front of cursor
- `<c-e>` jump to end of line
- `<c-f>` jump forward one character
- `<c-r>+` paste from clipboard
- `<c-u>` delete before the cursor in current line
- `<c-w>` delete word before
- `<m-bs>` delete backward one word
- `<m-b>` jump backward one word
- `<m-d>` delete forward one word
- `<m-f>` jump forward one word

### Text objects

- `a` function argument
- `b` brackets ({}, (), [])
- `f` function
- `g` buffer
- `h` git hunk
- `i` scope
- `q` quotes (", ', `)
- `t` html tags

### Operators

- `sa{motion}{char}` add surrounding character
- `sd{char}` delete surrounding character
- `sr{target}{replacement}` replace surrounding character
- `<leader>r{motion}` replace with last yank
- `<leader>s{motion}` sort

### Completion

- `<c-n>` complete/next entry
- `<c-p>` previous entry
- `<c-y>` confirm
- `<c-e>` abort
- `<c-u>` scroll docs up
- `<c-d>` scroll docs down

### AI chat

- `<leader>aa` open
- `<leader>am` models
- `<c-y>` accept diff
- `<c-x>` reset

### AI assistant

- `<leader>ac` commit message (ft:gitcommit)
- `<leader>ae` explain
- `<leader>af` fix
- `<leader>ai` implement
- `<leader>ao` optimize
- `<leader>ap` pull request review
- `<leader>aq` architect
- `<leader>ar` review
- `<leader>at` tests
- `<leader>aw` refactor

### AI suggestions

- `<tab>` accept
- `<c-l>` accept line
- `<c-w>` accept word
- `<c-j>` next
- `<c-k>` previous
- `<c-]>` dismiss

### Logging

- `glv` insert variable log below
- `glV` insert variable log above
- `glp` insert plain log below
- `glP` insert plain log above
- `glb` insert batch log below
- `glt` insert timestamp below
- `glT` insert timestamp below
- `<leader>glt` insert timestamp above/below

### Syntax (AST)

- `<m-h>` jump to parent node
- `<m-l>` jump to child node
- `<m-k>` jump to previous sibling node
- `<m-j>` jump to next sibling node
- `<leader>v` select current node
- `<tab>` increase selection (on node selection mode)
- `<s-tab>` decrease selection (on node selection mode)
- `<leader>V` select node with search labels
- `<m-H>` swap with lateral previous node
- `<m-L>` swap with lateral next node
- `<m-K>` swap with vertical previous node
- `<m-J>` swap with vertical next node

### LSP

- `K` display hover information for symbol
- `gO` list symbols in document
- `gd` jump to definition
- `go` jump to type definition
- `gra` code actions
- `grt` jump to type definition
- `gri` jump to implementation
- `grn` rename symbol
- `grr` list references
- `grI` toggle inlay hints
- `gD` jump to declaration
- `[r` jump to previous symbol reference
- `]r` jump to next symbol reference
- `<c-s>` display signature help
- `<leader>dd` open diagnostics for buffer
- `<cr>` jump to definition
- `<s-cr>` jump back from definition

### Debugger:

- `<f5>` continue
- `<s-f5>` stop
- `<f9>` toggle breakpoint
- `<f10>` step over
- `<f11>` step into
- `<s-f11>` step out

### Git

- `[h` previous hunk
- `]h` next hunk
- `gh` stage hunk
- `gH` reset hunk
- `<leader>hb` blame line
- `<leader>hB` blame file
- `<leader>hd` diff hunk
- `<leader>hD` diff workspace
- `<leader>hh` status
- `<leader>hl` log file/selection
- `<leader>hL` log
- `<leader>hps` push
- `<leader>hpu` push -u origin HEAD
- `<leader>hpf` push --force-with-lease
- `<leader>hxb` open blame in browser
- `<leader>hxf` open file in browser

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
- `z{0-9}` set foldlevel to {0-9}
- `[z` jump to previous fold
- `]z` jump to next fold
- `<leader><tab>` toggle one foldlevel
- `<c-Z>` reset saved folds

### Application

- `<leader>nc` show commands
- `<leader>nh` help
- `<leader>nk` keyboard shortcuts

<div style="margin-top:80px"></div>

---

<sup>&copy; 2024 Rui Costa, MIT License</sup>
