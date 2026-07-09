local M = {}

M.default_branch = function()
	-- Use `git symbolic-ref` to directly get the default branch name
	local args = { "git", "symbolic-ref", "refs/remotes/origin/HEAD" }

	local result = vim.system(args):wait(5000)
	if not result or not result.stdout then
		return nil, "Could not find HEAD branch"
	end

	-- Remove trailing newline
	return result.stdout:gsub("%s+$", "")
end

M.diff = function(ref)
	-- To ignore files (ex. package-lock.json) add 'package-lock.json -diff' to .gitattributes
	local args = { "git", "diff", "--no-color", ref }

	local result = vim.system(args):wait(10000)
	if not result or not result.stdout then
		return nil, "Could not get git diff"
	end

	return result.stdout
end

M.blame_line = function()
	local linenr = vim.fn.line(".")
	local file = vim.fn.expand("%")
	local args = { "git", "blame", "-L", linenr .. ",+1", file }

	local result = vim.system(args):wait(5000)
	if not result or not result.stdout then
		return nil, "Could not get blame info"
	end

	return result.stdout
end

M.repo_status = function(callback, cwd)
	cwd = cwd or vim.fn.getcwd()

	vim.system({ "git", "status", "--porcelain" }, { cwd = cwd }, function(result)
		if result.code ~= 0 or not result.stdout then
			callback("")
			return
		end

		local added, modified, deleted, untracked = 0, 0, 0, 0
		local code_map = { A = "added", C = "added", M = "modified", D = "deleted", R = "modified" }

		for line in vim.gsplit(result.stdout, "\n", { trimempty = true }) do
			if line:sub(1, 2) == "??" then
				untracked = untracked + 1
			elseif line:sub(1, 2) ~= "!!" then
				for _, ch in ipairs({ line:sub(1, 1), line:sub(2, 2) }) do
					local cat = code_map[ch]
					if cat == "added" then
						added = added + 1
					elseif cat == "modified" then
						modified = modified + 1
					elseif cat == "deleted" then
						deleted = deleted + 1
					end
				end
			end
		end

		local parts = {}
		if added > 0 then
			table.insert(parts, string.format("+%d", added))
		end
		if modified > 0 then
			table.insert(parts, string.format("~%d", modified))
		end
		if deleted > 0 then
			table.insert(parts, string.format("-%d", deleted))
		end
		if untracked > 0 then
			table.insert(parts, string.format("?%d", untracked))
		end

		callback(table.concat(parts, " "))
	end)
end

M.remote_status = function(callback, cwd)
	cwd = cwd or vim.fn.getcwd()

	vim.system({ "git", "rev-parse", "--abbrev-ref", "@{upstream}" }, { cwd = cwd }, function(u_result)
		if u_result.code ~= 0 then
			callback("")
			return
		end

		local upstream = u_result.stdout:gsub("%s+$", "")
		if upstream == "" then
			callback("")
			return
		end

		vim.system(
			{ "git", "rev-list", "--left-right", "--count", "@{upstream}...HEAD" },
			{ cwd = cwd },
			function(c_result)
				if c_result.code ~= 0 then
					callback("")
					return
				end

				local behind, ahead = c_result.stdout:match("^(%d+)%s+(%d+)")
				ahead = tonumber(ahead) or 0
				behind = tonumber(behind) or 0

				if ahead == 0 and behind == 0 then
					callback("")
					return
				end

				local parts = {}
				if ahead > 0 then
					table.insert(parts, string.format("↑%d", ahead))
				end
				if behind > 0 then
					table.insert(parts, string.format("↓%d", behind))
				end

				callback(table.concat(parts))
			end
		)
	end)
end

return M
