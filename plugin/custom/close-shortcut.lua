-- Use the same shortcut to close different panels.
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local closeShortcut = "<c-]>"
local api = vim.api
local k = vim.keymap.set

local augroup = api.nvim_create_augroup("ruicsh/custom/close-shortcut", { clear = true })

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

-- Custom buffers
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

-- Vertical splits
api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = {
		"fugitive",
		"help",
	},
	callback = function(event)
		k("n", closeShortcut, ":close | :vsplit | :blast<cr>", { buffer = event.buf, silent = true })
	end,
})

-- Oil
api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "oil",
	callback = function(event)
		k("n", closeShortcut, ":lua require('oil.actions').close.callback()<cr>", { buffer = event.buf })
	end,
})

-- neo-tree
api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "neo-tree",
	callback = function(event)
		k("n", closeShortcut, ":Neotree action=close<cr>", { buffer = event.buf })
	end,
})

-- Diffview
api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = {
		"DiffviewFiles",
		"DiffviewFileHistory",
	},
	callback = function(event)
		local function close_diffview()
			_G.diffview_blame = nil -- reset any blame info
			vim.cmd.tabclose()
		end

		k("n", closeShortcut, close_diffview, { buffer = event.buf })
	end,
})
