local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/vim-enter", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup,
  callback = function()
    -- Load env vars from config
    vim.cmd("LoadEnvVars")

    -- Skip LSP setup during git diffs
    if os.getenv("NVIM_GIT_DIFF") then
      return
    end

    -- Check if Lazy is open
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
      if filetype == "lazy" then
        return -- Exit the callback if Lazy is open
      end
    end

    -- Enable LSP servers via custom command (respects disabled env)
    vim.cmd("LspEnable")
  end,
})
