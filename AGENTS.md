# AGENTS.md

**Neovim Config – Agentic Coding Guide**

- **Environment:** Neovim 0.11+, Lua only. Entry: `init.lua` → `ruicsh/*` → `lua/core/plugins/*` (lazy loader). No build step.
- **Install Deps:** Launch nvim; plugins auto-install via lazy.nvim & mason.nvim. Ensure `PATH` includes `stdpath('data')/mason/bin`.
- **Formatting:** On save via conform.nvim (`FORMAT_ON_SAVE=true`). Use Stylua for `*.lua`, Prettier for JS/TS/CSS/HTML/JSON/MD, Black for Python, rustfmt for Rust. Use `gq` for manual conform.
- **Linting:** LSP diagnostics (eslint-lsp, pyright, harper-ls, etc). Disable servers via `LSP_DISABLED_SERVERS` env var (comma list).
- **Testing:** vim-test plugin. Run single test: `:TestNearest` (or `<leader>bn`), file: `:TestFile` (`<leader>bf`), last: `:TestLast` (`<leader>bb`), all: `:TestSuite` (`<leader>ba`).
- **Imports:** Use local module caching (`local mod = require("module")`) at top. Group: stdlib, third-party, internal. Avoid global pollution.
- **Naming:** snake_case for locals, UPPER_SNAKE for constants/env, PascalCase rare. User commands Capitalized. Avoid unnecessary abbreviations.
- **Types:** Lua is dynamically typed; use clear variable names and comments for intent.
- **Error Handling:** Prefer `pcall` for plugin APIs. Use `vim.notify` (mini.notify) for errors/warnings.
- **Env Vars:** Use `vim.fn.env_get`/`env_get_list` (not `os.getenv`). Add new vars to `.env.template`.
- **Performance:** Guard heavy ops (e.g., disable treesitter for >1MB). Cache results before polling.
- **UI:** Use border style `rounded`. Prefer `vim.ux.open_on_right_side` for panels.
- **Git:** Use mini.diff for hunks, snacks.picker for status/log. Avoid external git if possible.
- **PRs:** Small, focused commits. Do not commit secrets. Update `lazy-lock.json` only for plugin version changes.
- **AI:** Copilot suggestions disabled for some filetypes via `COPILOT_DISABLE_SUGGESTIONS`.
- **Agent commits:** Do NOT auto-commit; all changes must be reviewed by a human.
