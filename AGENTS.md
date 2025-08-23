AGENT QUICK REF (Neovim config repo)

1. Environment: Neovim 0.11+. Entry: init.lua -> ruicsh/\* then lazy plugin loader (lua/config/lazy.lua). Lua only; no build step.
2. Install deps: Launch nvim; lazy & mason auto-install. Ensure PATH prepends stdpath('data')/mason/bin.
3. Formatting: conform.nvim on save (env FORMAT_ON_SAVE=true). Stylua for \*.lua; Prettier/Prettierd (js/ts/css/html/json/md), Black (python), rustfmt (rust). Use gq for conform.
4. Linting: LSP diagnostics + eslint-lsp, pyright, harper-ls (avoid feeding harper_ls diagnostics into AI context per TODO), others per lsp/\*. Each server loaded if not disabled via env LSP_DISABLED_SERVERS (comma list).
5. Tests: vim-test plugin. Keys: <leader>bn nearest, <leader>bf file, <leader>bb last, <leader>ba suite. Programmatically: :TestNearest / :TestFile / :TestLast / :TestSuite. Custom strategy opens vertical terminal.
6. Single test workflow (JS/TS etc): open file at test, cursor inside test -> :TestNearest (or <leader>bn). For Python similar; relies on project test runner discovery.
7. Alternate files: other.nvim mappings (==, =s, =t...) for source/style/test/story/template navigation; keep patterns consistent when adding new languages.
8. Filetypes: custom additions in filetype.lua (conf/env->config, \*.snap->jsonc). Respect when generating/formatting files.
9. Imports & requires: Use local module caching (local mod = require("module")) at top; group: stdlib, third-party plugins, internal ("config/...", "ruicsh/..."), blank lines optional. Avoid global pollution (only attach helpers to vim.fn when intentional as in ruicsh/fn.lua).
10. Naming: snake_case for local vars/functions; UPPER_SNAKE for constants/env keys; PascalCase rare. User-facing command names Capitalized (e.g., LoadEnvVars). Avoid abbreviations except common (buf, win, ft, hl).
11. Error handling: Prefer pcall around plugin APIs that may fail (see treesitter size check). Use vim.notify (mini.notify) with short-lived messages; log level WARN/ERROR appropriately.
12. Environment helpers: Use vim.fn.env_get / env_get_list (loads .env once) instead of raw os.getenv. Add new vars to .env.template.
13. Performance: Guard heavy ops (e.g., treesitter highlight disable for >1MB). Cache results (statusline git, highlight cache) before adding new polling logic.
14. UI: Border style "rounded". Open side panels with vim.ux.open_on_right_side or vim.ux.open_side_panel for contextual views instead of generic vsplit when possible.
15. Keys generation: Use vim.fn.get_lazy_keys_conf for plugin key specs; supply desc to assist mini.clue and which-key-like UIs.
16. Git ops: mini.diff for hunks; snacks.picker for status/log. Avoid spawning external git unless necessary; reuse vim.git if present.
17. Adding LSP/tool: Place config in lsp/\*.lua returning table {cmd,filetypes,root_markers,...}; Respect env disables & root guards (see eslint.lua flat config logic).
18. Logging helper: timber.nvim templates; keep print_tag uniqueness logic (counter) if extending. For cross-lang logs follow existing style (warn/time/plain).
19. AI tooling: Copilot suggestions disabled for certain filetypes; adjust via env COPILOT_DISABLE_SUGGESTIONS. Assistant plugin token env COPILOT_MODELS_TOKEN.
20. PR etiquette: Small, focused commits; update lazy-lock.json only when plugin versions change; do not commit secrets (.env is gitignored).
21. When making changes to the code, AI Assistants SHOULD NOT commit the changes immediately. All changes need to be reviewed and approved by human eyes.
