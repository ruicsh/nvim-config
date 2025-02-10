-- Keep the current git branch name in a buffer-local variable

-- Run this on VimEnter and whenever switching buffers
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
	callback = function()
		local stdout = vim.loop.new_pipe(false)
		local handle

		handle = vim.loop.spawn("git", {
			args = { "rev-parse", "--abbrev-ref", "HEAD" },
			stdio = { nil, stdout, nil },
		}, function()
			stdout:close()
			if handle then
				handle:close()
			end
		end)

		if handle then
			vim.loop.read_start(stdout, function(err, data)
				if err or not data then
					return
				end
				vim.b.git_branch_name = data:gsub("\n", "")
			end)
		end
	end,
})
