# Neovim IDE configuration

This is my configuration for [Neovim](https://neovim.io/), I mostly work on web frontend development.

- **Editor** - enhanced vim motions, extended text objects, mouseless development
- **Code** - formatter, comments, code completion, AI powered suggestions
- **LSP** - Language Server Protocol client, symbols navigation, diagnostics
- **Syntax** - highlighting, syntax aware motions and text objects
- **Debugger** - Debug Adapter Protocol client, breakpoints, stack traces, locals
- **Git integration** - status, diffview, commit message editor, buffer integration
- **Search** - fuzzy find anything, file and workspace scoped search and replace
- **Application** - files and directory explorer, workspaces, notifications, command palette

<sub>Works on Neovim v0.10.2</sub>

## Screenshots

![screenshot](https://raw.githubusercontent.com/ruicsh/nvim-config/refs/heads/main/assets/screenshot.png)

## Theme

- **NordStone** - Custom theme based on [Nord Theme](https://www.nordtheme.com/).
- [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads)

## Plugins

### UI

- [Fidget](https://github.com/j-hui/fidget.nvim) - Notifications
- [Indent Blankline](https://github.com/nvim-lualine/lualine.nvim) - Indent guides
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) - Statusline
- [nvim-bqf](https://github.com/kevinhwang91/nvim-bqf) - Better quickfix
- [quicker.nvim](https://github.com/stevearc/quicker.nvim) - Quickfix/location list formatter
- [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) - Manage multiple terminal windows
- [which-key.nvim](https://github.com/folke/which-key.nvim) - Keybidings helper
- [workspaces.nvim](https://github.com/natecraddock/workspaces.nvim) - Manage workspace directories

#### Buffers, Splits and Tabs

- [Bbye (Buffer Bye)](https://github.com/moll/vim-bbye) - Delete buffers and close files without closing your windows or messing up your layout
- [Scope.nvim](https://github.com/tiagovla/scope.nvim) - Enhanced tab scoping
- [buffer_manager.nvim](https://github.com/j-morano/buffer_manager.nvim) - Easily manage buffers
- [tabby.nvim](https://github.com/nanozuki/tabby.nvim) - Tabline
- [vimade](https://github.com/tadaa/vimade) - Fade inactive buffers
- [windows.nvim](https://github.com/anuvyklack/windows.nvim) - Maximize and restore windows

#### File explorers

- [Neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) - Manage the file system as a tree
- [oil.nvim](https://github.com/stevearc/oil.nvim) - Edit filesystem like a buffer

### Editing

- [leap.nvim](https://github.com/ggandor/leap.nvim) - Navigate with search labels
- [mini.move](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-move.md) - Move lines/selection
- [nvim-spider](https://github.com/chrisgrieser/nvim-spider) - Move by subwords (camelCase, ...)
- [nvim-surround](https://github.com/kylechui/nvim-surround) - Delimiter pairs
- [nvim-various-textobjs](https://github.com/chrisgrieser/nvim-various-textobjs) - Bundle of text objects
- [repeat.vim](https://github.com/tpope/vim-repeat) - Repeat plugin keymaps
- [rsi.vim](https://github.com/tpope/vim-rsi) - Insert mode navigation
- [sort.nvim](https://github.com/sQVe/sort.nvim) - Sort selection

#### Search

- [nvim-hlslens](https://github.com/kevinhwang91/nvim-hlslens) - Search results labels
- [nvim-spectre](https://github.com/nvim-pack/nvim-spectre) - Find and replace
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - Find, filter, preview and pick

### Coding

- [colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua) - CSS Colors
- [conform.nvim](https://github.com/stevearc/conform.nvim) - Formatter
- [copilot.lua](https://github.com/zbirenbaum/copilot.lua) - GitHub Copilot
- [debugprint.nvim](https://github.com/andrewferrier/debugprint.nvim) - Debug statements
- [nvim-autopairs](https://github.com/windwp/nvim-autopairs) - Autopairs (`()`, `[]`, `{}`)
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - Completions
- [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context) - Display code context

#### LSP

- [Refjump](https://github.com/mawkler/refjump.nvim) - Jump to next/prev reference of symbol
- [lazydev.nvim](https://github.com/folke/trouble.nvim) - Lua language server
- [nvim-lightbulb](https://github.com/kosayoda/nvim-lightbulb) - Code actions
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - Config
- [outline.nvim](https://github.com/hedyhli/outline.nvim) - Symbols outline

#### Syntax

- [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) - Text objects
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Treesitter syntax parsers
- [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) - Auto close/rename HTML tags
- [nvim-ts-context-commentstring](https://github.com/JoosepAlviste/nvim-ts-context-commentstring) - Language aware comments
- [tree-climber.nvim](https://github.com/drybalka/tree-climber.nvim) - Nodes navigation

### Git

- [Diffview.nvim](https://github.com/sindrets/diffview.nvim) - Diffview/Log
- [fugitive.vim](https://github.com/tpope/vim-fugitive) - Git wrapper
- [git-blame.nvim](https://github.com/f-person/git-blame.nvim) - Git blame
- [git-conflict.nvim](https://github.com/akinsho/git-conflict.nvim) - Merge conflicts
- [gitlinker.nvim](https://github.com/ruifm/gitlinker.nvim) - Shareable file links
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) - Git buffer integration

## Mappings

There is a global keymap to close the different panels, windows and features -
`<c-]>`. This keymap is used to close Telescope, Fugitive's git status panel or
a vertical split, for example.

See [mappings](assets/mappings.md) for the complete list.

## Commands

- `CopyFilePathToClipboard` - Copy current buffer's path to clipboard.
- `Scratch` - Create a scratch buffer.
- `SmartVertSplit` - Open or re-use vertical split.
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
