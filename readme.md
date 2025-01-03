# Neovim IDE configuration

This is my configuration for [Neovim](https://neovim.io/), I mostly work on web frontend development.

- **Editor** - enhanced vim motions, extended text objects, folding
- **Code** - formatter, comments, code completion, AI powered suggestions
- **LSP** - Language Server Protocol client, symbols navigation, diagnostics
- **Syntax** - highlighting, syntax aware motions and text objects
- **Git integration** - status, diffview, commit message editor, buffer integration
- **Debugger** - Debug Adapter Protocol client, breakpoints, stack traces, locals
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
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) - Statusline
- [nvim-bqf](https://github.com/kevinhwang91/nvim-bqf) - Better quickfix
- [quicker.nvim](https://github.com/stevearc/quicker.nvim) - Quickfix/location list formatter
- [snacks.nvim](https://github.com/folke/snacks.nvim) - Small QoL plugins
- [which-key.nvim](https://github.com/folke/which-key.nvim) - Keybidings helper

#### Buffers, Windows and Tabs

- [Scope.nvim](https://github.com/tiagovla/scope.nvim) - Enhanced tab scoping
- [buffer_manager.nvim](https://github.com/j-morano/buffer_manager.nvim) - Easily manage buffers
- [tabby.nvim](https://github.com/nanozuki/tabby.nvim) - Tabline
- [vimade](https://github.com/tadaa/vimade) - Fade inactive buffers
- [windows.nvim](https://github.com/anuvyklack/windows.nvim) - Maximize and restore windows

#### File explorers

- [Neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) - Manage the file system as a tree
- [oil.nvim](https://github.com/stevearc/oil.nvim) - Edit filesystem like a buffer

### Editing

- [mini.ai](https://github.com/echasnovski/mini.ai) - a/i textobjects
- [mini.move](https://github.com/echasnovski/mini.move) - move lines/selection
- [mini.operators](https://github.com/echasnovski/mini.operators) - Text edit operators
- [mini.surround](https://github.com/echasnovski/mini.surround) - Surround pairs
- [nvim-spider](https://github.com/chrisgrieser/nvim-spider) - Move by subwords (camelCase, ...)
- [repeat.vim](https://github.com/tpope/vim-repeat) - Repeat plugin keymaps
- [rsi.vim](https://github.com/tpope/vim-rsi) - Insert mode navigation
- [wrapping.nvim](https://github.com/andrewferrier/wrapping.nvim) - Toggle soft/hard wrap

#### Search

- [fzf-lua](https://github.com/ibhagwan/fzf-lua) - Fuzzy finder
- [leap.nvim](https://github.com/ggandor/leap.nvim) - Navigate with search labels
- [nvim-hlslens](https://github.com/kevinhwang91/nvim-hlslens) - Search results labels

### Coding

- [colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua) - CSS Colors
- [conform.nvim](https://github.com/stevearc/conform.nvim) - Formatter
- [copilot.lua](https://github.com/zbirenbaum/copilot.lua) - GitHub Copilot
- [csvview.nvim](https://github.com/hat0uma/csvview.nvim) - CSV editing
- [mini.pairs](https://github.com/echasnovski/mini.pairs) - Autopairs (`()`, `[]`, `{}`)
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - Completions
- [timber.nvim](https://github.com/Goose97/timber.nvim) - Insert log statements

#### LSP

- [lazydev.nvim](https://github.com/folke/trouble.nvim) - Lua language server
- [nvim-lightbulb](https://github.com/kosayoda/nvim-lightbulb) - Code actions
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - Config
- [refjump](https://github.com/mawkler/refjump.nvim) - Jump to next reference of symbol

#### Syntax

- [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) - Text objects
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Treesitter syntax parsers
- [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) - Auto close/rename HTML tags
- [nvim-ts-context-commentstring](https://github.com/JoosepAlviste/nvim-ts-context-commentstring) - Language aware comments
- [treewalker.nvim](https://github.com/aaronik/treewalker.nvim) - Fast navigation around the AST tree

### Git

- [Diffview.nvim](https://github.com/sindrets/diffview.nvim) - Diffview/Log
- [fugitive.vim](https://github.com/tpope/vim-fugitive) - Git wrapper
- [git-blame.nvim](https://github.com/f-person/git-blame.nvim) - Git blame
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) - Git buffer integration

## Mappings

See [mappings](assets/mappings.md) for the complete list.

## Commands

- `CopyFilePathToClipboard` - Copy current buffer's path to clipboard.
- `ToggleFormatOnSave` - Toggle on/off formatting on save.

## Resources

#### Video series

- [Neovim (etc) screecasts](https://www.youtube.com/playlist?list=PLwJS-G75vM7kFO-yUkyNphxSIdbi_1NKX) by Greg Hurrell
- [Neovim Config Rewrite](https://www.youtube.com/playlist?list=PLep05UYkc6wRcB9dxdXkc5tYHlpQFlRUF) by TJ DeVries
- [Neovim Configuration](https://www.youtube.com/playlist?list=PLsz00TDipIffxsNXSkskknolKShdbcALR) by typecraft
- [Neovim Weekly Plugin Series](https://www.youtube.com/playlist?list=PLrgztVx4lZIova0vq7Nb_ZcmgU_MZ3NlJ) by CantuCodes
- [Neovim from Scratch](https://www.youtube.com/playlist?list=PLhoH5vyxr6Qq41NFL4GvhFp-WLd5xzIzZ) by chris@machine
- [Neovim](https://www.youtube.com/playlist?list=PLOIdWGSU_Wcp9_w8euHJaux8DEIBCvYGc) by Andrew Courter
- [Neovim](https://www.youtube.com/playlist?list=PLmcTCfaoOo_grgVqU7UbOx7_RG9kXPgEr) by DevOps Toolbox
- [Understanding Neovim](https://www.youtube.com/playlist?list=PLx2ksyallYzW4WNYHD9xOFrPRYGlntAft) by Vhyrro
- [Vim As Your Editor](https://www.youtube.com/playlist?list=PLm323Lc7iSW_wuxqmKx_xxNtJC_hJbQ7R) by ThePrimeagen
- [Vim Beginners Guide](https://www.youtube.com/watch?v=wACD8WEnImo&list=PLT98CRl2KxKHy4A5N70jMRYAROzzC2a6x&pp=iAQB) by Learn Linux TV
- [Vim Meetups](https://www.youtube.com/playlist?list=PL8tzorAO7s0jy7DQ3Q0FwF3BnXGQnDirs) by thoughbot
- [neovim](https://www.youtube.com/playlist?list=PLko9chwSoP-2RxNuglpJriLO5HHXIcP6x) by Vimjoyer
- [vimcasts.org](http://vimcasts.org/episodes/) by Drew Neil

<div style="margin-top:80px"></div>

---

<sup>&copy; 2024 Rui Costa, MIT License</sup>
