local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/views", { clear = true })

local IGNORE_FILETYPES = {
	["copilot-chat"] = true,
	["lazy_backdrop"] = true,
	["snacks_layout_box"] = true,
	["snacks_picker_input"] = true,
	["snacks_picker_list"] = true,
	["snacks_picker_preview"] = true,
	["snacks_win_backdrop"] = true,
	["vim-messages"] = true,
	checkhealth = true,
	fugitive = true,
	git = true,
	gitcommit = true,
	help = true,
	lazy = true,
	lspinfo = true,
	mason = true,
	mininotify = true,
	terminal = true,
	vim = true,
}

-- Save view when leaving a buffer
vim.api.nvim_create_autocmd("BufWinLeave", {
	group = augroup,
	callback = function(ev)
		local ft = vim.bo[ev.buf].filetype
		if ft == "" or IGNORE_FILETYPES[ft] then
			return
		end

		vim.cmd.mkview({ mods = { emsg_silent = true } })
	end,
})

-- Load view when entering a buffer
vim.api.nvim_create_autocmd("BufWinEnter", {
	group = augroup,
	callback = function(ev)
		local ft = vim.bo[ev.buf].filetype
		if ft == "" or IGNORE_FILETYPES[ft] then
			return
		end

		vim.cmd.loadview({ mods = { emsg_silent = true } })
	end,
})
