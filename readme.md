# Neovim IDE configuration

My configuration for [Neovim](https://neovim.io/), mostly for frontend development (typescript, css, python, rust).

- **Editor** - enhanced vim motions, extended text objects, folding
- **Code** - formatter, comments, code completion, AI powered suggestions
- **AI Assistant** - suggestions, chat, system prompts, operations, chat history
- **LSP** - Language Server Protocol client, symbols navigation, diagnostics
- **Syntax** - highlighting, syntax aware motions, text objects
- **Debugger** - Debug Adapter Protocol client, breakpoints, stack traces, locals
- **Git integration** - status, commit message editor, buffer integration
- **Search** - fuzzy find anything, file, workspace scoped search and replace
- **UI** - files and directory explorer, notifications, command palette, bookmarks

<sub>Works on Neovim v0.11.3</sub>

## Screenshots

![screenshot](https://raw.githubusercontent.com/ruicsh/nvim-config/refs/heads/main/assets/screenshot.png)

## Theme

- **NordStone** - Custom theme based on [Nord Theme](https://www.nordtheme.com/).
- [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads)

## Plugins

<sub>37 plugins</sub>

### Navigation

- [flash](https://github.com/folke/flash.nvim) - Jump with search labels
- [gx](https://github.com/chrishrb/gx.nvim) - Open links/files
- [oil](https://github.com/stevearc/oil.nvim) - Files explorer
- [other](https://github.com/rgroli/other.nvim) - Open alternative files
- [snacks.picker](https://github.com/folke/snacks.nvim/blob/main/docs/picker.md) - Pickers
- [treewalker](https://github.com/aaronik/treewalker.nvim) - AST aware navigation

### Editing

- [guess-indent](https://github.com/NMAC427/guess-indent.nvim) - Indentation style detection
- [mini.ai](https://github.com/echasnovski/mini.ai) - Around/inside textobjects
- [mini.align](https://github.com/echasnovski/mini.align) - Align text interactively
- [mini.keymap](https://github.com/echasnovski/mini.keymap) - Special key mappings
- [mini.operators](https://github.com/echasnovski/mini.operators) - Text edit operators
- [mini.pairs](https://github.com/echasnovski/mini.pairs) - Auto-pairs
- [mini.surround](https://github.com/echasnovski/mini.surround) - Surround actions

### Coding

- [blink.cmp](https://github.com/saghen/blink.cmp) - Autocomplete
- [CopilotChat](https://github.com/CopilotC-Nvim/CopilotChat.nvim) - AI assistant
- [conform](https://github.com/stevearc/conform.nvim) - Formatter
- [copilot.lua](https://github.com/zbirenbaum/copilot.lua) - AI suggestions
- [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) - Auto close/rename HTML tags
- [ts-comments](https://github.com/folke/ts-comments.nvim) - Custom comments configurations per language

### LSP/Syntax

- [lazydev](https://github.com/folke/lazydev.nvim) - Lua language server
- [mason](https://github.com/williamboman/mason.nvim) - LSP package manager
- [mini.hipatterns](https://github.com/echasnovski/mini.hipatterns) - Highlight patterns in text
- [nvim-treesitter-refactor](https://github.com/nvim-treesitter/nvim-treesitter-refactor) - AST navigation
- [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) - AST aware text objects
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Treesitter syntax parsers
- [rustaceanvim](https://github.com/mrcjkb/rustaceanvim) - Rust LSP

### Testing/Debugging

- [nvim-dap-view](https://github.com/igorlfs/nvim-dap-view) - Debugger UI
- [nvim-dap](https://github.com/mfussenegger/nvim-dap) - Debugger Adapter Protocol
- [timber](https://github.com/Goose97/timber.nvim) - Insert log statements
- [vim-test](https://github.com/vim-test/vim-test) - Test runner

### Git

- [fugitive](https://github.com/tpope/vim-fugitive) - status, commit, push
- [mini.diff](https://github.com/echasnovski/mini.diff) - hunks
- [snacks.gitbrowse](https://github.com/folke/snacks.nvim/blob/main/docs/gitbrowse.md) - Open remote repo

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
| [rust](https://github.com/ruicsh/nvim-config/blob/main/plugin/filetypes/rust.lua)             | Rust       |
| [terminal](https://github.com/ruicsh/nvim-config/blob/main/plugin/filetypes/terminal.lua)     | Terminal   |
| [typescript](https://github.com/ruicsh/nvim-config/blob/main/plugin/filetypes/typescript.lua) | TypeScript |

### Autocmds

New features built around autocmds (events).

|                                                                                                                                |                                                            |
| ------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------- |
| [auto-resize-splits](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/auto-resize-splits.lua)                   | Auto resize splits when window is resized                  |
| [clear-jumps](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/clear-jumps.lua)                                 | Clear jumplist when vim starts                             |
| [cmdline](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/cmdline.lua)                                         | Clean up after use, hide hit-enter messages on blur        |
| [disable-newline-comments](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/disable-newline-comments.lua)       | Disable newline comments                                   |
| [git-branch](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/git-branch.lua)                                   | Active git branch                                          |
| [lsp-attach](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/lsp-attach.lua)                                   | LSP diagnostics, keymaps, and custom handlers              |
| [scoped-tabs](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/scoped-tabs.lua)                                 | Keep buffers in tabs scoped to the tab they were opened in |
| [show-cursorline-only-active](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/show-cursorline-only-active.lua) | Show cursorline only on active window.                     |
| [views](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/views.lua)                                             | Save and load views for each file (marks, folds)           |
| [yank](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/yank.lua)                                               | Highlight selection when yanking, keep cursor on yank      |

### Custom

Random features added.

|                                                                                                          |                                           |
| -------------------------------------------------------------------------------------------------------- | ----------------------------------------- |
| [duplicate-comment](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/duplicate-comment.lua) | Duplicate and comment                     |
| [indent-ast-nodes](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/indent-ast-nodes.lua)   | AST aware indentation                     |
| [on-search](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/on-search.lua)                 | Pause folds, show results count on search |
| [vim-messages](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/vim-messages.lua)           | Display :messages on a separate window    |

## Keymaps

### Files explorer

- `-` open directory explorer
- `<c-w>s` open in horizontal split
- `<c-w>v` open in vertical split
- `<leader>-` workspaces
- `<leader>.` last picker
- `<leader><leader>` fuzzy find files

### Buffers

- `<bs>` open last
- `<esc>` close
- `<leader>,` list
- `==` open alternate
- `=<space>` open alternate source
- `=s` open alternate style
- `=t` open alternate test
- `=m` open alternate template
- `==<space>` open alternate source (vsplit)
- `==s` open alternate style (vsplit)
- `==t` open alternate test (vsplit)
- `==m` open alternate template (vsplit)

### Navigation

- `{` jump up 6 lines
- `}` jump down 6 lines
- `<c-f>` jump with labels
- `[; jump to previous position`
- `]; jump to next position`
- `''` jump to position before last jump
- `'.` jump to position where last change was made
- `'{a-z}'` jump to marked position
- `\` focus previous window
- `|` cycle windows
- `<c-b>` jump backwards one character (insert mode)
- `<c-f>` jump forward one character (insert mode)

### Search

- `<leader>*` find word in workspace
- `<leader>/` find in workspace
- `<leader>?` find in directory
- `<c-8>` find current word from the beginning of the file
- `'s` jump back to where search started

### Editing

- `[<space>` add blank line above cursor
- `]<space>` add blank line below cursor
- `[e` move line/selection above
- `]e` move line/selection below
- `[p` paste to new line above
- `]p` paste to new line below
- `ycc` duplicate a line, comment out the first line.
- `<leader>yf` copy relative filename

### Text objects

- `a` function argument
- `b` brackets ({}, (), [])
- `c` comment
- `f` function
- `g` entire file
- `h` git hunk
- `q` quotes (", ', `)
- `s` single word in different cases
- `t` html tags

### Operators

- `sa{motion}{char}` add surrounding character
- `sd{char}` delete surrounding character
- `sr{target}{replacement}` replace surrounding character
- `<leader>x{motion1}<leader>x{motion2}` exchange
- `<leader>p{motion}` duplicate
- `<leader>r{motion}` substitute with last yank
- `<leader>s{motion}` sort

### Completion

- `<c-n>` show/next entry
- `<c-p>` previous entry
- `<tab>` confirm
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

- `<c-]>` accept
- `<c-e>` dismiss
- `<c-j>` accept word
- `<c-k>` accept line
- `<c-h>` show previous
- `<c-l>` show next

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
- `<leader>v` select current node
- `;` increase node selection
- `,` decrease node selection

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
- `[r` jump to previous symbol usage
- `]r` jump to next symbol usage
- `<c-]>` jump to definition
- `<c-w>]` jump to definition (vsplit)
- `<leader>xx` open diagnostics (buffer)
- `<leader>xX` open diagnostics (workspace)
- `[x` jump to previous error
- `]x` jump to next error

### Debugger:

- `<f5>` continue
- `<s-f5>` stop
- `<f10>` step over
- `<f11>` step into
- `<s-f11>` step out
- `<leader>dp` toggle breakpoint
- `<leader>dd` start session with breakpoint

### Test runner:

- `<leader>bb` run last
- `<leader>bn` run nearest
- `<leader>bf` run file
- `<leader>ba` run all

### Git

- `[h` previous hunk
- `]h` next hunk
- `gh` stage hunk
- `gH` reset hunk
- `<leader>hd` diff hunk
- `<leader>hh` pick git files
- `<leader>hH` status
- `<leader>hg` log
- `<leader>hf` log file
- `<leader>hl` log line
- `<leader>hF` push --force-with-lease
- `<leader>hp` push
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
