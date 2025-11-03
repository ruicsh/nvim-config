-- Load environment variables from .nvim.env files

vim.api.nvim_create_user_command("LoadEnvVars", function()
  local dirs = {
    vim.fn.stdpath("config"),           -- Neovim configuration directory
    vim.fn.getcwd(),                    -- Current working directory
    vim.fs.root(vim.fn.getcwd(), ".git"), -- Git root directory
  }

  local dir_sep = vim.fn.is_windows() and "\\" or "/"

  for _, dir in ipairs(dirs) do
    if vim.fn.isdirectory(dir) == 1 then
      local file = dir .. dir_sep .. ".nvim.env"
      if vim.fn.filereadable(file) == 1 then
        vim.fn.load_env_file(dir)
      end
    end
  end
end, {})
