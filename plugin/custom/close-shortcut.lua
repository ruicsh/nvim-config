-- Use the same shortcut to close different panels.
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local closeShortcut = "<c-]>"
local api = vim.api
local k = vim.keymap.set

local augroup = api.nvim_create_augroup("ruicsh/custom/close_shortcut", { clear = true })

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

k("v", closeShortcut, "<esc>") -- Use it to exit visual mode
k("t", closeShortcut, "<c-\\><c-n>") -- Return to normal mode in the terminal

api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = {
		"checkhealth",
		"git",
		"lspinfo",
		"man",
		"qf",
		"query",
		"scratch",
		"startuptime",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.schedule(function()
			k({ "n", "i" }, closeShortcut, function()
				vim.cmd("close")
				pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
			end, {
				buffer = event.buf,
			})
		end)
	end,
})

api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "oil",
	callback = function(event)
		k("n", closeShortcut, ":lua require('oil.actions').close.callback()<cr>", { buffer = event.buf })
	end,
})

-- Close panels that open in a maximized current window
api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = {
		"copilot-chat",
		"fugitive",
		"help",
	},
	callback = function(event)
		k("n", closeShortcut, ":close | WindowToggleMaximize<cr>", { buffer = event.buf })
	end,
})

api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "gitcommit",
	callback = function(event)
		k({ "n", "i" }, closeShortcut, ":q!<cr>", { buffer = event.buf })
	end,
})

api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = {
		"DiffviewFiles",
		"DiffviewFileHistory",
	},
	callback = function(event)
		local function close_diffview()
			_G.diffview_blame = nil -- reset any blame info
			vim.cmd("tabclose")
		end

		k("n", closeShortcut, close_diffview, { buffer = event.buf })
	end,
})
