-- Use the same shortcut to close different panels

local closeShortcut = "<c-]>"
local api = vim.api

local group = api.nvim_create_augroup("ruicsh/close_shortcut", { clear = true })

vim.keymap.set("n", closeShortcut, "<c-w>q", { desc = "Close split" })

api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = {
		"git",
		"help",
		"man",
		"qf",
		"query",
		"scratch",
	},
	callback = function(args)
		vim.keymap.set("n", closeShortcut, "<cmd>close<cr>", { buffer = args.buf })
	end,
})

api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "neo-tree" },
	callback = function(args)
		vim.keymap.set("n", closeShortcut, "<cmd>Neotree action=close<cr>", { buffer = args.buf })
	end,
})

api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "oil" },
	callback = function(args)
		vim.keymap.set(
			"n",
			closeShortcut,
			"<cmd>lua require('oil.actions').close.callback()<cr>",
			{ buffer = args.buf }
		)
	end,
})

api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "TelescopePrompt" },
	callback = function(args)
		local function close_telescope()
			local bufnr = api.nvim_get_current_buf()
			local actions = require("telescope.actions")
			actions.close(bufnr)
		end

		vim.keymap.set({ "i", "n" }, closeShortcut, close_telescope, { buffer = args.buf })
	end,
})

api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "DiffviewFiles" },
	callback = function(args)
		vim.keymap.set("n", closeShortcut, "<cmd>DiffviewClose<cr>", { buffer = args.buf })
	end,
})

api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "DiffviewFileHistory" },
	callback = function(args)
		vim.keymap.set("n", closeShortcut, "<cmd>tabclose<cr>", { buffer = args.buf })
	end,
})

api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "fugitive" },
	callback = function(args)
		vim.keymap.set("n", closeShortcut, "<plug>fugitive:gq", { noremap = true, buffer = args.buf })
	end,
})

api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "gitcommit" },
	callback = function(args)
		vim.keymap.set({ "n", "i" }, closeShortcut, "<cmd>q!<cr>", { noremap = true, buffer = args.buf })
	end,
})

api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "spectre_panel" },
	callback = function(args)
		vim.keymap.set(
			{ "n", "i" },
			closeShortcut,
			"<esc><cmd>lua require('spectre').toggle()<cr>",
			{ noremap = true, buffer = args.buf }
		)
	end,
})
