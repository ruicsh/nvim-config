# Neovim IDE configuration

This is my configuration for [Neovim](https://neovim.io/), mostly for frontend development (typescript, css, python, rust).

- **Editor** - enhanced vim motions, extended text objects, folding
- **Code** - formatter, comments, code completion, AI powered suggestions
- **AI Assistant** - suggestions, chat, system prompts, operations, chat history
- **LSP** - Language Server Protocol client, symbols navigation, diagnostics
- **Syntax** - highlighting, syntax aware motions, text objects
- **Debugger** - Debug Adapter Protocol client, breakpoints, stack traces, locals
- **Git integration** - status, commit message editor, buffer integration
- **Search** - fuzzy find anything, file, workspace scoped search and replace
- **UI** - files and directory explorer, notifications, command palette, bookmarks

<sub>Works on Neovim v0.11 (and vscode-neovim)</sub>

## Screenshots

![screenshot](https://raw.githubusercontent.com/ruicsh/nvim-config/refs/heads/main/assets/screenshot.png)

## Theme

- **NordStone** - Custom theme based on [Nord Theme](https://www.nordtheme.com/).
- [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads)

## Plugins

<sub>34 plugins</sub>

### UI

- [gx.nvim](https://github.com/chrishrb/gx.nvim) - Open links/files
- [mini.clue](https://github.com/echasnovski/mini.clue) - Keybindings helper
- [mini.files](https://github.com/echasnovski/mini.files) - Files explorer
- [mini.notify](https://github.com/echasnovski/mini.notify) - Notifications
- [other.nvim](https://github.com/rgroli/other.nvim) - Open alternative files
- [snacks.nvim](https://github.com/folke/snacks.nvim) - Pickers, statuscolumn, indent lines

### Editing

- [flash.nvim](https://github.com/folke/flash.nvim) - Jump to single character
- [mini.ai](https://github.com/echasnovski/mini.ai) - around/inside textobjects
- [mini.align](https://github.com/echasnovski/mini.align) - align text interactively
- [mini.operators](https://github.com/echasnovski/mini.operators) - Text edit operators
- [mini.pairs](https://github.com/echasnovski/mini.pairs) - Autopairs
- [mini.surround](https://github.com/echasnovski/mini.surround) - Surround pairs
- [nvim-spider](https://github.com/chrisgrieser/nvim-spider) - Move by subwords (camelCase, ...)

### Coding

- [blink.cmp](https://github.com/saghen/blink.cmp) - Autocomplete
- [conform.nvim](https://github.com/stevearc/conform.nvim) - Formatter
- [copilot.lua](https://github.com/zbirenbaum/copilot.lua) - AI suggestions
- [CopilotChat.nvim](https://github.com/CopilotC-Nvim/CopilotChat.nvim) - AI assistant
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

- [fugitive.vim](https://github.com/tpope/vim-fugitive) - status, commit, push
- [mini.diff](https://github.com/echasnovski/mini.diff) - hunks
- [snacks.gitbrowse](https://github.com/folke/snacks.nvim/blob/main/docs/gitbrowse.md) - Open remote repo

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

|                                                                                                                  |                                                                      |
| ---------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| [LoadEnvVars](https://github.com/ruicsh/nvim-config/blob/main/plugin/commands/load-env-vars.lua)                 | Load environment variables, global, and project scoped.              |
| [RestoreChangedFiles](https://github.com/ruicsh/nvim-config/blob/main/plugin/commands/restore-changed-files.lua) | On VimEnter, open all git changed files in current working directory |
| [ToggleTerminal](https://github.com/ruicsh/nvim-config/blob/main/plugin/commands/toggle-terminal.lua)            | Toggle terminal open/closed                                          |

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
| [cmdline](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/cmdline.lua)                                         | Cleanup after use, hide hit-enter messages on blur                    |
| [create-intermediate-dirs](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/create-intermediate-dirs.lua)       | Create intermediate directories                                       |
| [disable-newline-comments](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/disable-newline-comments.lua)       | Disable newline comments                                              |
| [git-branch](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/git-branch.lua)                                   | Active git branch                                                     |
| [lsp-attach](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/lsp-attach.lua)                                   | LSP diagnostics, keymaps, and custom handlers                         |
| [scoped-tabs](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/scoped-tabs.lua)                                 | Keep buffers in tabs scoped to the tab they were opened in            |
| [scroll-eof](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/scroll-eof.lua)                                   | Scroll past the end of file with scrolloff                            |
| [show-cursorline-only-active](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/show-cursorline-only-active.lua) | Show cursorline only on active window.                                |
| [toggle-hlsearch](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/toggle-hlsearch.lua)                         | Toggle off hlsearch when entering insert mode and the cursor is moved |
| [views](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/views.lua)                                             | Save and load views for each file (marks, folds)                      |
| [yank](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/yank.lua)                                               | Highlight selection when yanking, keep cursor on yank                 |

### Custom

Random features added.

|                                                                                                          |                                                 |
| -------------------------------------------------------------------------------------------------------- | ----------------------------------------------- |
| [bookmarks](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/bookmarks.lua)                 | Buffer global bookmarks (harpoon)               |
| [close-shortcut](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/close-shortcut.lua)       | Use the same shortcut to close different panels |
| [duplicate-comment](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/duplicate-comment.lua) | Duplicate and comment                           |
| [on-search](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/on-search.lua)                 | Pause folds, show results count on search       |
| [indent-ast-nodes](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/indent-ast-nodes.lua)   | AST aware indentation                           |
| [yank-ring](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/yank-ring.lua)                 | Yank ring                                       |
| [vim-messages](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/vim-messages.lua)           | Display :messages on a separate window          |

## Keymaps

### Files explorer

- `<leader><leader>` fuzzy find files
- `-` file tree explorer
- `<leader>.` last picker
- `<leader>pp` projects

### Buffers

- `<bs>` open last
- `<c-e>` close
- `<leader>,` list
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

### Windows

- `|` switch
- `<c-e>` close window

### Navigation

- `{` jump up 6 lines
- `}` jump down 6 lines
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
- `<leader>yf` copy relative filename

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
- `c` comment
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
- `<c-e>` dismiss

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

- `<s-left>` jump to parent node
- `<s-right>` jump to child node
- `<s-up>` jump to previous sibling node
- `<s-down>` jump to next sibling node
- `<leader>v` select current node
- `<c-a>` increase selection (on node selection mode)
- `<c-x>` decrease selection (on node selection mode)
- `<m-right>` swap with lateral previous node
- `<m-left>` swap with lateral next node
- `<m-up>` swap with vertical previous node
- `<m-down>` swap with vertical next node

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
- `<leader>hb` blame
- `<leader>hd` diff hunk
- `<leader>hh` status
- `<leader>hl` log
- `<leader>hpf` push --force-with-lease
- `<leader>hps` push
- `<leader>hpu` push -u origin HEAD
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
- `'{1-9}` jump to bookmarks
- `'{a-z}'` jump to marked position

### Application

- `<leader>na` autocmds
- `<leader>nc` commands
- `<leader>nh` help
- `<leader>nH` highlights
- `<leader>nk` keymaps
- `<leader>nn` vim-messages
- `<leader>no` notifications

<div style="margin-top:80px"></div>

---

<sup>&copy; 2024 Rui Costa, MIT License</sup>
