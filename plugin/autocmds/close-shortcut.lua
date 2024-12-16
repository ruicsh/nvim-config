-- Use the same shortcut to close different panels.
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local closeShortcut = "<c-]>"
local api = vim.api
local k = vim.keymap.set

local group = api.nvim_create_augroup("ruicsh/close_shortcut", { clear = true })

-- Close buffer, close window if empty, close app if last window
local function close_buffer_or_window_or_quit()
	if vim.fn.expand("%:p") == "" then
		if #api.nvim_list_wins() == 1 then
			vim.cmd("q")
		else
			api.nvim_win_close(api.nvim_get_current_win(), true)
		end
	else
		require("snacks.bufdelete").delete()
	end
end
k("n", closeShortcut, close_buffer_or_window_or_quit)

k("x", closeShortcut, "<esc>") -- Use it to exit visual mode
k("t", closeShortcut, "<c-\\><c-n>") -- Return to normal mode in the terminal

api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = {
		"checkhealth",
		"fugitive",
		"git",
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
			k("n", closeShortcut, function()
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
		k("n", closeShortcut, "<cmd>Neotree action=close<cr>", { buffer = event.buf })
	end,
})

api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "oil" },
	callback = function(event)
		k("n", closeShortcut, "<cmd>lua require('oil.actions').close.callback()<cr>", { buffer = event.buf })
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

		k({ "i", "n" }, closeShortcut, close_telescope, { buffer = event.buf })
	end,
})

api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = {
		"DiffviewFiles",
		"DiffviewFileHistory",
	},
	callback = function(event)
		k("n", closeShortcut, "<cmd>tabclose<cr>", { buffer = event.buf })
	end,
})

api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "gitcommit" },
	callback = function(event)
		k({ "n", "i" }, closeShortcut, "<cmd>q!<cr>", { buffer = event.buf })
	end,
})
