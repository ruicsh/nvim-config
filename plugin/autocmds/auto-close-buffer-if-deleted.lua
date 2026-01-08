-- Auto-close buffer if file deleted (e.g., by Oil)

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/auto-delete-buffer-if-deleted", { clear = true })

local IGNORE_FILETYPES = {
	"copilot-chat",
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

vim.api.nvim_create_autocmd("BufEnter", {
	group = augroup,
	callback = function(args)
		local buf = args.buf
		local name = vim.api.nvim_buf_get_name(buf)
		local buftype = vim.bo.buftype
		local ft = vim.bo[buf].filetype

		if
			name == ""
			or buftype == ""
			or vim.tbl_contains(IGNORE_BUFTYPES, buftype)
			or vim.wo.diff
			or ft == ""
			or vim.tbl_contains(IGNORE_FILETYPES, ft)
		then
			return
		end

		if vim.fn.filereadable(name) == 0 then
			vim.schedule(function()
				if vim.api.nvim_buf_is_loaded(buf) then
					vim.api.nvim_buf_delete(buf, { force = true })
				end
			end)
		end
	end,
	desc = "Auto-close buffer if file deleted (e.g., by Oil)",
})
