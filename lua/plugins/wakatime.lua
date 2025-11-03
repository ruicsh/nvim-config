-- Time tracking
-- https://github.com/wakatime/vim-wakatime

return {
  "wakatime/vim-wakatime",
  enabled = vim.fn.getenv("TIME_TRACKING_ENABLED") == "true",

  lazy = false,
}
