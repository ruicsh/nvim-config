-- Use the same shortcut to close different panels.
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local closeShortcut = "<c-]>"
local api = vim.api

local group = api.nvim_create_augroup("ruicsh/close_shortcut", { clear = true })

vim.keymap.set("n", closeShortcut, "<c-w>q", { desc = "Close split" })

api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = {
		"checkhealth",
		"fugitive",
		"git",
		"gitcommit",
		"help",
		"lspinfo",
		"man",
		"qf",
		"query",
		"scratch",
		"spectre_panel",
		"startuptime",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.schedule(function()
			vim.keymap.set({ "i", "n", "x" }, closeShortcut, function()
				vim.cmd("close")
				pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
			end, {
				buffer = event.buf,
				silent = true,
			})
		end)
	end,
})

api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "neo-tree" },
	callback = function(event)
		vim.keymap.set("n", closeShortcut, "<cmd>Neotree action=close<cr>", { buffer = event.buf })
	end,
})

api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "oil" },
	callback = function(event)
		vim.keymap.set(
			"n",
			closeShortcut,
			"<cmd>lua require('oil.actions').close.callback()<cr>",
			{ buffer = event.buf }
		)
	end,
})

api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "TelescopePrompt" },
	callback = function(event)
		local function close_telescope()
			local actions = require("telescope.actions")
			actions.close(event.buf)
		end

		vim.keymap.set({ "i", "n" }, closeShortcut, close_telescope, { buffer = event.buf })
	end,
})

api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = {
		"DiffviewFiles",
		"DiffviewFileHistory",
	},
	callback = function(event)
		vim.keymap.set("n", closeShortcut, "<cmd>tabclose<cr>", { buffer = event.buf })
	end,
})
