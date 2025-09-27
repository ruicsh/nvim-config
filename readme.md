# Neovim IDE configuration

My configuration for [Neovim](https://neovim.io/), mostly for frontend development (typescript, css, python, rust).

- **Editor** - enhanced vim motions, extended text objects, folding
- **Code** - formatter, comments, code completion, AI powered suggestions
- **AI Assistant** - suggestions, chat, system prompts, operations, chat history
- **LSP** - Language Server Protocol client, symbols navigation, diagnostics
- **Syntax** - highlighting, syntax aware motions, text objects
- **Git integration** - status, diffview, commit message editor, buffer integration
- **Search** - fuzzy find anything, files, git changed, last buffers
- **UI** - files and directory explorer, notifications, command palette

<sub>Works on Neovim v0.11.4</sub>

## Screenshots

![screenshot](https://raw.githubusercontent.com/ruicsh/nvim-config/refs/heads/main/.assets/screenshot.png)

## Theme

- **NordStone** - Custom theme based on [Nord Theme](https://www.nordtheme.com/).
- [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads)

## Plugins

<sub>34 plugins</sub>

### Navigation

- [grapple](https://github.com/cbochs/grapple.nvim) - File bookmarks
- [gx](https://github.com/chrishrb/gx.nvim) - Open links/files
- [mini.jump](https://github.com/nvim-mini/mini.jump) - Character navigation
- [oil](https://github.com/stevearc/oil.nvim) - Files explorer
- [other](https://github.com/rgroli/other.nvim) - Open alternative files
- [snacks.picker](https://github.com/folke/snacks.nvim/blob/main/docs/picker.md) - Pickers
- [treewalker](https://github.com/aaronik/treewalker.nvim) - AST aware navigation

### Editing

- [autotag](https://github.com/windwp/nvim-ts-autotag) - Auto close/rename tags
- [blink.cmp](https://github.com/saghen/blink.cmp) - Autocomplete
- [conform](https://github.com/stevearc/conform.nvim) - Formatter
- [match-up](https://github.com/andymass/vim-matchup) - Matching pairs/words
- [mini.ai](https://github.com/nvim-mini/mini.ai) - Around/inside textobjects
- [mini.align](https://github.com/nvim-mini/mini.align) - Align text interactively
- [mini.pairs](https://github.com/nvim-mini/mini.pairs) - Auto-pairs
- [mini.surround](https://github.com/nvim-mini/mini.surround) - Surround action
- [sort](https://github.com/sQVe/sort.nvim) - Sort action
- [substitute](https://github.com/gbprod/substitute.nvim) - Substitute action

### LSP/Syntax

- [mason](https://github.com/williamboman/mason.nvim) - LSP package manager
- [mini.hipatterns](https://github.com/nvim-mini/mini.hipatterns) - Highlight patterns in text
- [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) - AST aware text objects
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Treesitter syntax parsers
- [rustaceanvim](https://github.com/mrcjkb/rustaceanvim) - Rust LSP
- [timber](https://github.com/Goose97/timber.nvim) - Insert log statements

### AI

- [CopilotChat](https://github.com/CopilotC-Nvim/CopilotChat.nvim) - AI chat
- [copilot.lua](https://github.com/zbirenbaum/copilot.lua) - AI suggestions

### Git

- [diffview.nvim](https://github.com/sindrets/diffview.nvim) - diffview
- [fugitive](https://github.com/tpope/vim-fugitive) - status, commit, push
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) - hunks, blame

### UI

- [incline.nvim](https://github.com/b0o/incline.nvim) - Floating statusline
- [mini.clue](https://github.com/nvim-mini/mini.clue) - Keybindings helper
- [mini.notify](https://github.com/nvim-mini/mini.notify) - Notifications

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
| [formatoptions](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/formatoptions.lua)                             | Format options                                        |
| [lsp-attach](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/lsp-attach.lua)                                   | LSP diagnostics, keymaps, and custom handlers         |
| [show-cursorline-only-active](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/show-cursorline-only-active.lua) | Show cursorline only on active window.                |
| [views](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/views.lua)                                             | Save and load views for each file (marks, folds)      |
| [yank](https://github.com/ruicsh/nvim-config/blob/main/plugin/autocmds/yank.lua)                                               | Highlight selection when yanking, keep cursor on yank |

### Custom

Random features added.

|                                                                                                          |                                          |
| -------------------------------------------------------------------------------------------------------- | ---------------------------------------- |
| [auto-hlsearch](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/auto-hlsearch.lua)         | Disable search highlight after searching |
| [duplicate-comment](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/duplicate-comment.lua) | Duplicate and comment                    |
| [indent-ast-nodes](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/indent-ast-nodes.lua)   | AST aware indentation                    |
| [vim-messages](https://github.com/ruicsh/nvim-config/blob/main/plugin/custom/vim-messages.lua)           | Display :messages on a separate window   |

## Keymaps

### Files explorer

- `<leader>f` open directory explorer
- `<leader>F` open current working directory
- `<c-p>` preview file
- `<c-w>s` open in horizontal split
- `<c-w>t` open in new tab
- `<c-w>v` open in vertical split
- `<leader>.` last picker
- `<leader><leader>` fuzzy find files

### Buffers

- `<bs>` switch to last
- `q` close
- `<leader>;;` list

### Bookmark buffer

- `,{a,s,d,f,g}` jump to
- `,,{a,s,d,f,g}` save to
- `<leader>,,` list

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

- `{` jump up 6 lines
- `}` jump down 6 lines
- `''` jump to position before last jump
- `'.` jump to position where last change was made
- `'{a-z}'` jump to marked position
- `mm` jump to matching pair
- `<leader>[` jump to earlier position
- `<leader>]` jump to later position

### Windows

- `|` switch
- `q` close
- `<c-q>` quit
- `<c-w>t` move file to new tab

### Search

- `<leader>/` search in workspace
- `<leader>?` search in directory
- `<leader>g/` search current word in workspace
- `g/` search current word / selection
- `G/` search current word (no jumps)
- `[/` search first occurrence
- `gr/` replace current word / selection
- `gb/` web search current word
- `g./` repeat last search
- `<c-w>/` search first occurence in new window
- `<c-r>/` repeat last search
- `'s` jump back to where search started

### Editing

- `[<space>` add blank line above cursor
- `]<space>` add blank line below cursor
- `[p` paste to new line above
- `]p` paste to new line below
- `ycc` duplicate a line, comment out the first line.
- `<a-up>` move selection up
- `<a-down>` move selection down
- `<tab>` toggle fold
- `<s-tab>` toggle all folds

### Insert/Command mode

- `<c-b>` jump character backward
- `<c-f>` jump character forward
- `<a-b>` jump word backward
- `<a-f>` jump word forward
- `<c-a>` jump to line start
- `<c-e>` jump to line end
- `<bs>` delete character backward
- `<c-d>` delete character forward
- `<c-w>` delete word backward
- `<a-d>` delete word forward
- `<c-k>` delete line backward
- `<c-u>` delete line forward
- `<a-d><a-d>` delete whole line
- `<a-up>` move current line up
- `<a-down>` move current line down

### Text objects

- `a` function argument
- `b` brackets ({}, (), [])
- `c` comment
- `%` entire file
- `f` function
- `h` git hunk
- `m` matching pair
- `q` quotes (", ', `)
- `s` single word in different cases
- `t` html tags

### Operators

- `sa{motion}{char}` add surrounding character
- `sd{char}` delete surrounding character
- `sr{target}{replacement}` replace surrounding character
- `s{char}` add surroundint character to selection
- `<leader>x{motion1}<leader>x{motion2}` exchange
- `<leader>r{motion}` replace
- `<leader>s{motion}` sort

### Completion

- `<c-n>` show/next entry
- `<c-p>` previous entry
- `<cr>` confirm
- `<c-q>` hide
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
- `gla` add to batch log
- `glk` insert breakpoint below
- `glK` insert breakpoint above
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
- `]a` jump to next parameter start (`[a` previous)
- `]f` jump to next function start (`[f` previous)
- `]A` jump to next parameter end (`[A` previous)
- `]F` jump to next function end (`[F` previous)

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

### Git

- `[c` previous change
- `]c` next change
- `<leader>hD` diff {git-rev}
- `<leader>hP` push --force-with-lease
- `<leader>hd` diff HEAD
- `<leader>he` log file
- `<leader>hh` status
- `<leader>hl` log
- `<leader>hp` push
- `<leader>hr` reset hunk
- `<leader>hs` stage/unstage hunk
- `<leader>hu` push --set-upstream origin HEAD
- `<leader>hxb` open blame in browser
- `<leader>hxe` open file in browser

### Git merge conflicts

- `[x` previous conflict
- `]x` next conflict
- `c0` choose none
- `cb` choose both
- `co` choose ours
- `ct` choose theirs

### Application

- `<leader>na` autocmds
- `<leader>nh` help
- `<leader>nH` highlights
- `<leader>nk` keymaps
- `<leader>nn` vim-messages

<div style="margin-top:80px"></div>

---

<sup>&copy; 2024 Rui Costa, MIT License</sup>
