-- Auto-close buffer if file deleted (e.g., by Oil)

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/auto-delete-buffer-if-deleted", { clear = true })

local IGNORE_FILETYPES = {
	"copilot-chat",
	"help",
	"fugitive",
	"lazy",
	"mason",
	"oil",
}

vim.api.nvim_create_autocmd("BufEnter", {
	group = augroup,
	callback = function(args)
		local buf = args.buf
		local name = vim.api.nvim_buf_get_name(buf)
		local buftype = vim.api.nvim_buf_get_option(buf, "buftype")

		if buftype == "" or name == "" then
			return
		end

		for _, ft in ipairs(IGNORE_FILETYPES) do
			if vim.bo[buf].filetype == ft then
				return
			end
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
