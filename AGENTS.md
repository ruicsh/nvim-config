# AGENTS.md - Neovim Configuration

This is a personal Neovim configuration (dotfiles) written in Lua, targeting Neovim
v0.11.5. It is not a traditional software project -- there is no build system, test
suite, or CI pipeline for the config itself.

## Project Overview

- **Language:** Lua (LuaJIT runtime), with minor Vimscript and Tree-sitter queries
- **Plugin manager:** lazy.nvim (folke/lazy.nvim), bootstrapped in `init.lua`
- **Custom colorscheme:** NordStone (`colors/nordstone.lua`)
- **Formatter:** stylua for Lua, prettier for web languages (via conform.nvim)

## Build / Lint / Test Commands

There are no build, lint, or test commands. There is no Makefile, justfile, or
package.json. The GitHub Actions workflow (`backup.yml`) only mirrors to Bitbucket.

To validate the config, open Neovim and check for errors:

```sh
nvim --headless "+lua print('ok')" +qa     # basic syntax check
nvim --headless "+Lazy sync" +qa            # install/update plugins
```

Lua files are formatted with **stylua** (configured as the conform.nvim formatter for
`lua` filetype). There is no `stylua.toml` in the repo -- stylua defaults apply:
- **Tab indentation** (single tab per indent level)
- **Trailing commas** after the last item in tables
- **Double quotes** for strings

## Directory Structure

```
init.lua                    Entry point: loader, colorscheme, leader, lazy bootstrap
lua/
  lib/                      Shared utility library (env, fn, git, ui, tailwindcss)
    init.lua                Barrel re-export of all lib submodules
  plugins/                  One file per plugin (lazy.nvim auto-imports this dir)
plugin/                     Auto-loaded by Neovim at startup (no require needed)
  options.lua               All vim.opt settings, organized by :options sections
  shell.lua                 Cross-platform shell configuration
  autocmds/                 Autocommand files, one concern per file
  config/                   Complex config (statusline, winbar, foldtext, formatoptions)
  custom/                   Custom behaviors (LSP keymaps, duplicate-comment, etc.)
  keymaps/                  Keymaps split by mode (normal, insert, visual, command)
  filetypes/                Filetype-specific settings
after/ftplugin/             Filetype-specific overrides (13 filetypes)
colors/                     Custom colorscheme
prompts/                    AI system prompt templates for CopilotChat (34 files)
queries/                    Custom Tree-sitter queries (astro, html, tsx)
snippets/                   VSCode-format JSON snippets
```

## Code Style Guidelines

### Indentation and Formatting

- **Tabs** for indentation in all Lua files (stylua default)
- **Double quotes** for all strings -- never single quotes
- **Trailing commas** after the last item in multi-line tables
- **No semicolons** at end of statements
- Lines generally kept under ~120 characters; break long calls into multi-line

### Imports and Requires

- The shared library is imported as `T`: `local T = require("lib")`
- Access submodules via `T.env`, `T.fn`, `T.git`, `T.ui`
- Internal lib requires use forward slashes: `require("lib/fn")`, not `require("lib.fn")`
- Plugin-specific requires are done locally, often inside callbacks to respect lazy-loading

### Module Patterns

- Library modules use the `M` table pattern:
  `local M = {} ... M.func = function(...) end ... return M`
- Functions assigned as `M.func = function(...)`, not `function M.func(...)`
- Private functions use `local function name()` syntax
- Plugin files return a lazy.nvim spec table directly: `return { "author/plugin", ... }`
- Globals are rare; when needed, use `_G.name` or `function _G.name()`

### Naming Conventions

- **Variables and functions:** `snake_case` everywhere
- **Constants:** `SCREAMING_SNAKE_CASE` for constant-like tables at file top
- **Filenames:** kebab-case for multi-word files (e.g., `auto-close-buffer-if-deleted.lua`)
- **Plugin filenames:** dotted for sub-features (e.g., `snacks.picker.lua`, `mini.ai.lua`)
- **Augroup names:** namespaced as `"ruicsh/autocmds/<name>"`, `"ruicsh/custom/<name>"`
- **Keymap helper:** conventionally named `k` -- a local wrapper around `vim.keymap.set`
- **camelCase** is not used (exception: the colorscheme file has some legacy camelCase)

### Neovim API Usage

- Direct `vim.api.nvim_*` calls -- not abstracted behind wrappers
- `vim.opt` is aliased as `o` in the options file: `local o = vim.opt`
- `vim.keymap.set` for all keymap definitions
- `vim.cmd("...")` with string arguments (not the table form)
- `vim.fn.*` for VimL functions, `vim.system()` for external commands
- `vim.lsp.protocol.Methods` stored as `local methods = vim.lsp.protocol.Methods`

### Error Handling

- `pcall` for operations that may fail:

  ```lua
  local ok, result = pcall(vim.api.nvim_win_get_var, winnr, "side_panel")
  ```

- Nil-guard early returns: `if not result then return nil, "error msg" end`
- Multiple return values for errors (Go-style): `return nil, "Could not get git diff"`
- `vim.notify(msg, vim.log.levels.WARN)` for user-facing messages
- Buffer validity checks before operations: `if not vim.api.nvim_buf_is_valid(bufnr) then`

### Comment Style

- Single-line: `-- Comment text` (always a space after `--`)
- File headers: plugin name + GitHub URL on first two lines
- Vim help references inline: `o.ignorecase = true -- Ignore case. ':h 'ignorecase''`
- Important notes: `-- NOTE: explanation`
- Fold markers for sections: `-- Section Name {{{` / `-- }}}` with modeline at EOF
- No block comments (`--[[ ]]`) and no LuaCATS/EmmyLua type annotations

### Plugin Spec Conventions

- One plugin per file in `lua/plugins/`
- Spec key ordering: plugin URL, then `opts`/`config`, then a blank line, then loading
  triggers (`event`, `cmd`, `keys`, `dependencies`):

  ```lua
  return {
      "author/plugin-name",
      opts = { ... },
      config = function(_, opts) ... end,

      event = "BufReadPost",
      dependencies = { ... },
  }
  ```

- Constants and helper functions defined above the `return` statement
- Environment-driven config via `T.env.get()`, `T.env.get_bool()`, etc.
- Conditional early return for disabled features: `if condition then return {} end`

### Environment and LSP Config

- Settings are driven by `.nvim.env` (gitignored). See `.nvim.env.template` for available
  variables: `FORMAT_ON_SAVE`, `IS_WORK`, `COPILOT_MODEL_*`, `LSP_DISABLED_SERVERS`, etc.
- `.luarc.json` declares `vim` and `Snacks` as recognized globals, LuaJIT runtime, and
  `luv` library support. When adding new global references, update this file.

### Key Patterns to Follow

- When adding a new plugin: create `lua/plugins/<name>.lua` returning a lazy.nvim spec
- When adding keymaps: add to the appropriate mode file in `plugin/keymaps/`
- When adding autocommands: create a file in `plugin/autocmds/` with a namespaced augroup
- When adding filetype settings: use `after/ftplugin/<filetype>.lua`
- When adding shared utilities: add to the appropriate module in `lua/lib/`
- Always use `local T = require("lib")` when you need shared utilities
