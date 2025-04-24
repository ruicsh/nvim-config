-- Keep the current git branch name in a buffer-local variable

-- Run this on VimEnter and whenever switching buffers
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
	callback = function()
		-- Skip if we're not in a valid buffer
		if vim.fn.expand("%") == "" or vim.bo.buftype ~= "" then
			return
		end

		-- Cache the git branch per directory to avoid excessive git calls
		local dir = vim.fn.expand("%:p:h")
		local cached_branch = vim.g.git_branch_cache and vim.g.git_branch_cache[dir]
		local cache_time = vim.g.git_branch_cache_time and vim.g.git_branch_cache_time[dir] or 0

		-- Use cached value if less than 30 seconds old
		if cached_branch and (vim.loop.now() - cache_time < 30000) then
			vim.b.git_branch_name = cached_branch
			return
		end

		-- Initialize caches if needed
		vim.g.git_branch_cache = vim.g.git_branch_cache or {}
		vim.g.git_branch_cache_time = vim.g.git_branch_cache_time or {}

		-- Run git asynchronously
		vim.fn.jobstart("git -C " .. vim.fn.shellescape(dir) .. " rev-parse --abbrev-ref HEAD", {
			on_stdout = function(_, data)
				if data and data[1] and data[1] ~= "" then
					local branch = data[1]:gsub("\n", "")
					vim.b.git_branch_name = branch
					vim.g.git_branch_cache[dir] = branch
					vim.g.git_branch_cache_time[dir] = vim.loop.now()
				end
			end,
			stdout_buffered = true,
		})
	end,
})
