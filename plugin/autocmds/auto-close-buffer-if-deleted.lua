-- Auto-close buffer if file deleted (e.g., by Oil)

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/auto-delete-buffer-if-deleted", { clear = true })

local IGNORE_FILETYPES = {
	"git",
	"fugitive",
	"help",
	"lazy",
	"mason",
	"oil",
}
local IGNORE_BUFTYPES = {
	"nofile",
	"nowrite",
	"prompt",
	"quickfix",
	"terminal",
}

vim.api.nvim_create_autocmd("FileChangedShell", {
	group = augroup,
	callback = function(args)
		local buf = args.buf
		if not vim.api.nvim_buf_is_valid(buf) then
			return
		end

		local name = vim.api.nvim_buf_get_name(buf)
		local buftype = vim.bo[buf].buftype
		local ft = vim.bo[buf].filetype

		if
			name == ""
			or vim.tbl_contains(IGNORE_BUFTYPES, buftype)
			or ft == ""
			or vim.tbl_contains(IGNORE_FILETYPES, ft)
		then
			return
		end

		-- Check if buffer is visible in a diff window
		for _, win_id in ipairs(vim.api.nvim_list_wins()) do
			if vim.api.nvim_win_get_buf(win_id) == buf and vim.wo[win_id].diff then
				return
			end
		end

		if vim.fn.filereadable(name) == 0 then
			vim.schedule(function()
				if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
					vim.api.nvim_buf_delete(buf, { force = true })
				end
			end)
		end
	end,
	desc = "Auto-close buffer if file deleted (e.g., by Oil)",
})
