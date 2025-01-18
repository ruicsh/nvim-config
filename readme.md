# Neovim IDE configuration

This is my configuration for [Neovim](https://neovim.io/), I mostly work on web frontend development.

- **Editor** - enhanced vim motions, extended text objects, folding
- **Code** - formatter, comments, code completion, AI powered suggestions
- **LSP** - Language Server Protocol client, symbols navigation, diagnostics
- **Syntax** - highlighting, syntax aware motions and text objects
- **Git integration** - status, diffview, commit message editor, buffer integration
- **Search** - fuzzy find anything, file and workspace scoped search and replace
- **Application** - files and directory explorer, notifications, command palette

<sub>Works on Neovim v0.10.3</sub>

## Screenshots

![screenshot](https://raw.githubusercontent.com/ruicsh/nvim-config/refs/heads/main/assets/screenshot.png)

## Theme

- **NordStone** - Custom theme based on [Nord Theme](https://www.nordtheme.com/).
- [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads)

## Plugins

### UI

- [Fidget](https://github.com/j-hui/fidget.nvim) - Notifications
- [fzf-lua](https://github.com/ibhagwan/fzf-lua) - Fuzzy finder
- [nvim-bqf](https://github.com/kevinhwang91/nvim-bqf) - Better quickfix
- [quicker.nvim](https://github.com/stevearc/quicker.nvim) - Quickfix/location list formatter
- [snacks.nvim](https://github.com/folke/snacks.nvim) - Small QoL plugins
- [which-key.nvim](https://github.com/folke/which-key.nvim) - Keybidings helper

#### Buffers, Windows and Tabs

- [Scope.nvim](https://github.com/tiagovla/scope.nvim) - Enhanced tab scoping
- [buffer_manager.nvim](https://github.com/j-morano/buffer_manager.nvim) - Easily manage buffers

#### File explorers

- [Neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) - Manage the file system as a tree
- [oil.nvim](https://github.com/stevearc/oil.nvim) - Edit filesystem like a buffer

### Editing

- [csvview.nvim](https://github.com/hat0uma/csvview.nvim) - CSV editing
- [flash.nvim](https://github.com/folke/flash.nvim) - Navigate with labels
- [mini.ai](https://github.com/echasnovski/mini.ai) - a/i textobjects
- [mini.move](https://github.com/echasnovski/mini.move) - move lines/selection
- [mini.operators](https://github.com/echasnovski/mini.operators) - Text edit operators
- [mini.surround](https://github.com/echasnovski/mini.surround) - Surround pairs
- [nvim-spider](https://github.com/chrisgrieser/nvim-spider) - Move by subwords (camelCase, ...)
- [repeat.vim](https://github.com/tpope/vim-repeat) - Repeat plugin keymaps
- [rsi.vim](https://github.com/tpope/vim-rsi) - Insert mode navigation

### Coding

- [colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua) - CSS Colors
- [conform.nvim](https://github.com/stevearc/conform.nvim) - Formatter
- [copilot.lua](https://github.com/zbirenbaum/copilot.lua) - GitHub Copilot
- [mini.pairs](https://github.com/echasnovski/mini.pairs) - Autopairs
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - Completions
- [nvim-snippets](https://github.com/garymjr/nvim-snippets) - Snippets
- [timber.nvim](https://github.com/Goose97/timber.nvim) - Insert log statements

#### LSP

- [lazydev.nvim](https://github.com/folke/trouble.nvim) - Lua language server
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - Config

#### Syntax

- [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) - Text objects
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Treesitter syntax parsers
- [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) - Auto close/rename HTML tags
- [treewalker.nvim](https://github.com/aaronik/treewalker.nvim) - Fast navigation around the AST tree
- [ts-comments.nvim](https://github.com/folke/ts-comments.nvim) - Custom comments configurations per language

### Git

- [Diffview.nvim](https://github.com/sindrets/diffview.nvim) - Diffview/Log
- [fugitive.vim](https://github.com/tpope/vim-fugitive) - Git wrapper
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) - Git buffer integration

## Mappings

See [mappings](assets/mappings.md) for the complete list.

## Commands

- `CopyFilePathToClipboard` - Copy current buffer's path to clipboard.
- `ToggleFormatOnSave` - Toggle on/off formatting on save.

## Autocmds

|                                                                                                                                                 |                                                                       |
| ----------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| [auto-resize-splits](https://raw.githubusercontent.com/ruicsh/nvim-config/refs/heads/main/plugin/autocmds/auto-resize-splits.lua)               | Auto resize splits when window is resized                             |
| [close-shortcut](https://raw.githubusercontent.com/ruicsh/nvim-config/refs/heads/main/plugin/autocmds/close-shortcut.lua)                       | Use the same shortcut to close different panels                       |
| [create-intermediate-dirs](https://raw.githubusercontent.com/ruicsh/nvim-config/refs/heads/main/plugin/autocmds/create-intermediate-dirs.lua)   | Create intermediate directories                                       |
| [custom-fold-text](https://raw.githubusercontent.com/ruicsh/nvim-config/refs/heads/main/plugin/autocmds/custom-fold-text.lua)                   | Custom fold text                                                      |
| [dim-inactive-windows](https://raw.githubusercontent.com/ruicsh/nvim-config/refs/heads/main/plugin/autocmds/dim-inactive-windows.lua)           | Dim inactive windows                                                  |
| [disable-new-line-comments](https://raw.githubusercontent.com/ruicsh/nvim-config/refs/heads/main/plugin/autocmds/disable-new-line-comments.lua) | Disable new line comments                                             |
| [last-location](https://raw.githubusercontent.com/ruicsh/nvim-config/refs/heads/main/plugin/autocmds/last-location.lua)                         | Jump to last location when opening a file                             |
| [open-directory-oil](https://raw.githubusercontent.com/ruicsh/nvim-config/refs/heads/main/plugin/autocmds/open-directory-oil.lua)               | If neovim is opened with a directory as argument open oil-filemanager |
| [restore-changed-files](https://raw.githubusercontent.com/ruicsh/nvim-config/refs/heads/main/plugin/autocmds/restore-changed-files.lua)         | On VimEnter, open all git changed files in current working directory  |
| [terminal](https://raw.githubusercontent.com/ruicsh/nvim-config/refs/heads/main/plugin/autocmds/terminal.lua)                                   | Terminal windows                                                      |
| [toggle-hlsearch](https://raw.githubusercontent.com/ruicsh/nvim-config/refs/heads/main/plugin/autocmds/toggle-hlsearch.lua)                     | Toogle off hlsearch when entering insert mode and the cursor is moved |
| [yank-highlight](https://raw.githubusercontent.com/ruicsh/nvim-config/refs/heads/main/plugin/autocmds/yank-highlight.lua)                       | Highlight selection when yanking                                      |
| [yank-deep-cursor-position](https://raw.githubusercontent.com/ruicsh/nvim-config/refs/heads/main/plugin/autocmds/yank-deep-cursor-position.lua) | Keep cursor position on yank                                          |

<div style="margin-top:80px"></div>

---

<sup>&copy; 2024 Rui Costa, MIT License</sup>
