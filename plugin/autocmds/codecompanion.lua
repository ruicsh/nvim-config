-- CodeCompanion hooks

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/codecompanion", { clear = true })

vim.api.nvim_create_autocmd("User", {
	group = augroup,
	pattern = "CodeCompanionRequest*",
	callback = function(request)
		-- Shows spinneer wheel on statusline
		if request.match == "CodeCompanionRequestStarted" then
			_G.codecompanion.is_processing = true
		elseif request.match == "CodeCompanionRequestFinished" then
			_G.codecompanion.is_processing = false
		end
	end,
})
