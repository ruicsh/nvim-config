local T = require("lib")

vim.loader.enable()

vim.cmd("colorscheme nordstone")

-- Leader key
-- needs to be set before lazy.nvim
vim.g.mapleader = vim.keycode("<space>")
vim.g.maplocalleader = vim.keycode(",")

-- Bootstrap packard.nvim (use local copy for debugging)
local packpath = vim.fn.stdpath("data") .. "/site/pack/packard/start/packard.nvim"
if vim.fn.isdirectory(packpath) == 0 then
	vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/ruicsh/packard.nvim.git", packpath })
end
vim.opt.rtp:prepend(packpath)

require("packard").setup({
	specs_dir = "lua/plugins",
	plugins = {
		"ruicsh/packard.nvim",
	},
	ai_review = {
		provider = "openai", -- "openai", "anthropic", "ollama", or "custom"
		model = "deepseek-v4-flash",
		url = "https://opencode.ai/zen/go/v1/chat/completions",
		headers = {
			["Authorization"] = "Bearer " .. (T.env.get("OPENCODE_API_KEY") or ""),
		},
	},
	-- notifications = true,
	-- debug = true,
})
