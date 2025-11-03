-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/harper_ls.lua

return {
  cmd = {
    "harper-ls",
    "--stdio",
  },
  filetypes = {
    'asciidoc',
    'c',
    'cpp',
    'cs',
    'gitcommit',
    'go',
    'html',
    'java',
    'javascript',
    'lua',
    'markdown',
    'nix',
    'python',
    'ruby',
    'rust',
    'swift',
    'toml',
    'typescript',
    'typescriptreact',
    'haskell',
    'cmake',
    'typst',
    'php',
    'dart',
    'clojure',
    'sh',
  },
  root_markers = {
    ".git",
  },
  -- https://writewithharper.com/docs/integrations/language-server#Configuration
  settings = {
    ["harper-ls"] = {
      diagnosticSeverity = "hint",
      userDictPath = vim.o.spellfile,
      markdown = {
        IgnoreLinkTitle = true,
      },
      linters = {
        sentenceCapitalization = true,
      },
      isolateEnglish = true,
      dialect = "British",
    },
  },

  single_file_support = true,
}
