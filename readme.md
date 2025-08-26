# Neovim IDE configuration

My configuration for [Neovim](https://neovim.io/), mostly for frontend development (typescript, css, python, rust).

- **Editor** - enhanced vim motions, extended text objects, folding
- **Code** - formatter, comments, code completion, AI powered suggestions
- **AI Assistant** - suggestions, chat, system prompts, operations, chat history
- **LSP** - Language Server Protocol client, symbols navigation, diagnostics
- **Syntax** - highlighting, syntax aware motions, text objects
- **Git integration** - status, commit message editor, buffer integration
- **Search** - fuzzy find anything, files, git changed, last buffers
- **UI** - files and directory explorer, notifications, command palette

<sub>Works on Neovim v0.11.3</sub>

## Screenshots

![screenshot](https://raw.githubusercontent.com/ruicsh/nvim-config/refs/heads/main/.assets/screenshot.png)

## Theme

- **NordStone** - Custom theme based on [Nord Theme](https://www.nordtheme.com/).
- [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads)

## Plugins

<sub>30 plugins</sub>

### Navigation

- [flash](https://github.com/folke/flash.nvim) - Jump with search labels
- [grapple](https://github.com/cbochs/grapple.nvim) - File bookmarks
- [gx](https://github.com/chrishrb/gx.nvim) - Open links/files
- [oil](https://github.com/stevearc/oil.nvim) - Files explorer
- [other](https://github.com/rgroli/other.nvim) - Open alternative files
- [snacks.picker](https://github.com/folke/snacks.nvim/blob/main/docs/picker.md) - Pickers
- [treewalker](https://github.com/aaronik/treewalker.nvim) - AST aware navigation

### Editing

- [blink.cmp](https://github.com/saghen/blink.cmp) - Autocomplete
- [conform](https://github.com/stevearc/conform.nvim) - Formatter
- [mini.ai](https://github.com/echasnovski/mini.ai) - Around/inside textobjects
- [mini.align](https://github.com/echasnovski/mini.align) - Align text interactively
- [mini.operators](https://github.com/echasnovski/mini.operators) - Text edit operators
- [mini.surround](https://github.com/echasnovski/mini.surround) - Surround actions

### LSP/Syntax

- [mason](https://github.com/williamboman/mason.nvim) - LSP package manager
- [mini.hipatterns](https://github.com/echasnovski/mini.hipatterns) - Highlight patterns in text
- [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) - AST aware text objects
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Treesitter syntax parsers
- [rustaceanvim](https://github.com/mrcjkb/rustaceanvim) - Rust LSP

### AI

- [CopilotChat](https://github.com/CopilotC-Nvim/CopilotChat.nvim) - AI chat
- [copilot.lua](https://github.com/zbirenbaum/copilot.lua) - AI suggestions
- [opencode](https://github.com/NickvanDyke/opencode.nvim) - AI agent

### Testing/Debugging

- [timber](https://github.com/Goose97/timber.nvim) - Insert log statements
- [vim-test](https://github.com/vim-test/vim-test) - Test runner

### Git

- [fugitive](https://github.com/tpope/vim-fugitive) - status, commit, push
- [mini.diff](https://github.com/echasnovski/mini.diff) - hunks

### UI

- [mini.clue](https://github.com/echasnovski/mini.clue) - Keybindings helper
- [mini.notify](https://github.com/echasnovski/mini.notify) - Notifications

## Config

### Config

Complex configuration options.

|                                                                                                        |                                                           |
| ------------------------------------------------------------------------------------------------------ | --------------------------------------------------------- |
| [foldtext](https://github.com/ruicsh/nvim-config/blob/main/plugin/config/foldtext.lua)                 | Text displayed for a closed fold                          |
| [native-plugins](https://github.com/ruicsh/nvim-config/blob/main/plugin/config/native-plugins.lua)     | Disable unused native plugins                             |
| [quickfixtextfunc](https://github.com/ruicsh/nvim-config/blob/main/plugin/config/quickfixtextfunc.lua) | Text to display in the quickfix and location list windows |
| [statusline](https://github.com/ruicsh/nvim-config/blob/main/plugin/config/statusline.lua)             | Content of the status line                                |

### Commands

Custom built commands to be invoked on the `cmdline` or with keymaps.

|                                                                                                                  |                                                                      |
| ---------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| [LspEnable/LspRestart](https://github.com/ruicsh/nvim-config/blob/main/plugin/commands/lsp.lua)                  | Enable and restart LSP                                               |
| [LoadEnvVars](https://github.com/ruicsh/nvim-config/blob/main/plugin/commands/load-env-vars.lua)                 | Load environment variables, global, and project scoped.              |
| [RestoreChangedFiles](https://github.com/ruicsh/nvim-config/blob/main/plugin/commands/restore-changed-files.lua) | On VimEnter, open all git changed files in current working directory |
| [ToggleTerminal](https://github.com/ruicsh/nvim-config/blob/main/plugin/commands/toggle-terminal.lua)            | Toggle terminal open/closed                                          |

### Filetypes

Custom configuration, keymaps, and features dependent on the file's type.

|                                                                                               |            |
| --------------------------------------------------------------------------------------------- | ---------- |
| [dockerfile](https://github.com/ruicsh/nvim-config/blob/main/plugin/filetypes/dockerfile.lua) | Dockerfile |
| [help](https://github.com/ruicsh/nvim-config/blob/main/plugin/filetypes/help.lua)             | help       |
| [oil](https://github.com/ruicsh/nvim-config/blob/main/plugin/filetypes/oil.lua)               | Oil        |
| [python](https://github.com/ruicsh/nvim-config/blob/main/plugin/filetypes/python.lua)         | Python     |
| [terminal](https://github.com/ruicsh/nvim-config/blob/main/plugin/filetypes/terminal.lua)     | Terminal   |

### Autocmds

New features built around autocmds (events).

|                                                                                                                                |                                                       |
| ------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------- |
| [auto-resize-splits](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/auto-resize-splits.lua)                   | Auto resize splits when window is resized             |
| [clear-jumps](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/clear-jumps.lua)                                 | Clear jumplist when vim starts                        |
| [cmdline](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/cmdline.lua)                                         | Clean up after use, hide hit-enter messages on blur   |
| [disable-newline-comments](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/disable-newline-comments.lua)       | Disable newline comments                              |
| [git-branch](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/git-branch.lua)                                   | Active git branch                                     |
| [lsp-attach](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/lsp-attach.lua)                                   | LSP diagnostics, keymaps, and custom handlers         |
| [show-cursorline-only-active](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/show-cursorline-only-active.lua) | Show cursorline only on active window.                |
| [views](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/views.lua)                                             | Save and load views for each file (marks, folds)      |
| [yank](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/yank.lua)                                               | Highlight selection when yanking, keep cursor on yank |

### Custom

Random features added.

|                                                                                                          |                                           |
| -------------------------------------------------------------------------------------------------------- | ----------------------------------------- |
| [duplicate-comment](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/duplicate-comment.lua) | Duplicate and comment                     |
| [indent-ast-nodes](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/indent-ast-nodes.lua)   | AST aware indentation                     |
| [on-search](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/on-search.lua)                 | Pause folds, show results count on search |
| [opencode](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/opencode.lua)                   | Toggle OpenCode tab                       |
| [vim-messages](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/vim-messages.lua)           | Display :messages on a separate window    |

## Keymaps

### Files explorer

- `-` open directory explorer
- `<c-w>s` open in horizontal split
- `<c-w>v` open in vertical split
- `<leader>.` last picker
- `<leader><leader>` fuzzy find files

### Buffers

- `<bs>` open last
- `<c-e>` close
- `<c-n>` open next
- `<c-p>` open previous
- `<esc>` close
- `<leader>;` list

### Bookmark buffer

- `,{a,s,d,f}` jump to
- `,{A,S,D,F}` save to
- `<leader>,` list
- `,l` toggle
- `[,` jump to previous
- `],` jump to next

### Alternate buffer

- `==` switch to
- `=<space>` switch to source
- `=m` switch to template
- `=s` switch to style
- `=t` switch to test
- `==<space>` switch to source (vsplit)
- `==m` switch to template (vsplit)
- `==s` switch to style (vsplit)
- `==t` switch to test (vsplit)

### Navigation

- `H` jump to start of line
- `L` jump to end of line
- `{` jump up 6 lines
- `}` jump down 6 lines
- `s` jump with labels
- `''` jump to position before last jump
- `'.` jump to position where last change was made
- `'{a-z}'` jump to marked position
- `mm` jump to matching pair

### Windows

- `q` close window
- `<c-q>` quit
- `\` focus previous window
- `|` cycle windows
- `<c-w>t` move file to new tab

### Search

- `<leader>/` search in workspace
- `<leader>?` search in directory
- `<leader>g/` search current word in workspace
- `g/` search current word
- `[/` search first occurrence
- `<c-w>/` search first occurence in new window
- `'s` jump back to where search started
- `g?` web search

### Editing

- `[<space>` add blank line above cursor
- `]<space>` add blank line below cursor
- `[p` paste to new line above
- `]p` paste to new line below
- `ycc` duplicate a line, comment out the first line.
- `<a-up>` move selection up
- `<a-down>` move selection down

### Insert mode

- `<c-h>` jump character backward
- `<c-l>` jump character forward
- `<c-b>` jump word backward
- `<c-w>` jump word forward
- `<c-H>` jump to line start
- `<c-L>` jump to line end
- `<a-h>` delete character backward
- `<a-l>` delete haracter forward
- `<a-b>` delete word backward
- `<a-w>` delete word forward
- `<a-H>` delete line backward
- `<a-L>` delete line forward
- `<a-d><a-d>` delete whole line
- `<a-up>` move current line up
- `<a-down>` move current line down

### Text objects

- `a` function argument
- `b` brackets ({}, (), [])
- `c` comment
- `e` entire file
- `f` function
- `h` git hunk
- `m` matching pair
- `q` quotes (", ', `)
- `s` single word in different cases
- `t` html tags

### Operators

- `ys{motion}{char}` add surrounding character
- `ds{char}` delete surrounding character
- `cs{target}{replacement}` replace surrounding character
- `<leader>x{motion1}<leader>x{motion2}` exchange
- `<leader>m{motion}` multiply
- `<leader>r{motion}` replace
- `<leader>s{motion}` sort

### Completion

- `<c-n>` show/next entry
- `<c-p>` previous entry
- `<cr>` confirm
- `<c-e>` show/abort
- `<c-u>` scroll docs up
- `<c-d>` scroll docs down

### Snippets

- `<tab>` expand
- `<tab>` jump to next tabstop
- `<s-tab>` jump to previous tabstop
- `<c-c>` cancel

### AI chat

- `<leader>aa` open
- `<leader>am` models
- `<c-]>` accept
- `<c-x>` reset

### AI suggestions

- `<c-]>` accept
- `<a-e>` dismiss
- `<a-]>` accept word
- `<a-[>` accept line
- `<a-n>` show next
- `<a-p>` show previous

### AI chat

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

### AI agent

- `<a-a>a` new session
- `<a-a>\` toggle
- `<a-a>A` ask about buffer
- `<a-a>a` ask about selection
- `<a-a>p` select prompt
- `<a-a>c` copy message
- `<c-U>` scroll up
- `<c-D>` scroll down

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

- `<c-h>` jump to parent node
- `<c-j>` jump to next sibling node
- `<c-k>` jump to previous sibling node
- `<c-l>` jump to child node
- `<a-h>` swap with left node
- `<a-j>` swap with down node
- `<a-k>` swap with up node
- `<a-l>` swap with right node
- `<leader>v` select node with labels
- `<c-a>` increase node selection
- `<c-x>` decrease node selection

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
- `<c-]>` jump to definition
- `<c-w>]` jump to definition (vsplit)
- `<leader>dd` open diagnostics (buffer)
- `<leader>dD` open diagnostics (workspace)
- `[r` jump to previous symbol reference
- `]r` jump to next symbol reference
- `[x` jump to previous error
- `]x` jump to next error

### Test runner:

- `<leader>bb` run last
- `<leader>bn` run nearest
- `<leader>be` run file
- `<leader>ba` run all

### Git

- `[c` previous change
- `]c` next change
- `gh` stage hunk
- `gH` reset hunk
- `<leader>hd` diff hunk
- `<leader>hh` pick git files
- `<leader>hH` status
- `<leader>hl` log
- `<leader>he` log file
- `<leader>h.` log line
- `<leader>hp` push
- `<leader>hP` push --force-with-lease
- `<leader>hu` push -set-upstream origin HEAD
- `<leader>hxb` open blame in browser
- `<leader>hxf` open file in browser

### Application

- `<leader>na` autocmds
- `<leader>nc` commands
- `<leader>nh` help
- `<leader>nH` highlights
- `<leader>nk` keymaps
- `<leader>nn` vim-messages

<div style="margin-top:80px"></div>

---

<sup>&copy; 2024 Rui Costa, MIT License</sup>
