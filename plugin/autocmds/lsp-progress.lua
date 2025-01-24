-- LSP installation progress
-- https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md#-examples

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/lsp_progress", { clear = true })

vim.api.nvim_create_autocmd("LspProgress", {
	group = augroup,
	callback = function(ev)
		local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
		vim.notify(vim.lsp.status(), "info", {
			id = "lsp_progress",
			title = "LSP Progress",
			opts = function(notif)
				notif.icon = ev.data.params.value.kind == "end" and " "
					or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
			end,
		})
	end,
})
