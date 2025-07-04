vim.git = {}

vim.git.get_root_dir = function()
	local git_toplevel = vim.fn.system("git rev-parse --show-toplevel")
	if vim.v.shell_error == 0 then
		return vim.trim(git_toplevel)
	else
		return nil
	end
end

-- Get blame info for a file/line
vim.git.blame = function(o)
	local opts = o or {}
	local cmd_parts = {}
	table.insert(cmd_parts, "git blame --porcelain")

	local line = opts.line or vim.fn.line(".")
	if line then
		table.insert(cmd_parts, "-L " .. line .. "," .. line)
	end

	local filename = opts.filename or vim.fn.expand("%")
	if filename then
		table.insert(cmd_parts, filename)
	end

	-- git blame --porcelain -L 10,10 src/file.lua
	local cmd = table.concat(cmd_parts, " ")
	local output = vim.fn.systemlist(cmd)

	local info = {}

	info.commit = output[1]:match("%w+")

	local url_cmd = "git config --get remote.origin.url"
	local handle = io.popen(url_cmd)
	if handle then
		local repo_url = handle:read("*a"):gsub("\n", "")
		handle:close()
		info.repo_url = repo_url:gsub("git@([^:]+):", "https://%1/"):gsub("%.git$", "")
	end

	for _, line in ipairs(output) do
		if line:match("^author ") then
			local author = line:gsub("^author ", "")
			info.author = author
		elseif line:match("^author%-time ") then
			local text = line:gsub("^author%-time ", "")
			info.date = tonumber(text) or os.time()
		elseif line:match("^committer ") then
			local committer = line:gsub("^committer ", "")
			info.committer = committer
		elseif line:match("^committer%-time ") then
			local text = line:gsub("^committer%-time ", "")
			info.committer_date = tonumber(text) or os.time()
		elseif line:match("^summary ") then
			local text = line:gsub("^summary ", "")
			info.summary = text
		end
	end

	return info
end

vim.git.default_branch = function()
	-- Use `git symbolic-ref` to directly get the default branch name
	local result = vim.system({ "git", "symbolic-ref", "refs/remotes/origin/HEAD", "--short" }):wait()
	if not result or not result.stdout then
		return nil, "Could not find HEAD branch"
	end

	-- Remove 'origin/' prefix from the branch name and remove the trailing newline
	return result.stdout:gsub("^origin/", ""):gsub("%s+$", "")
end

vim.git.list_remote_branches = function()
	-- Make sure we have the latest branches
	vim.system({ "git", "fetch", "--prune", "--all" }):wait()

	-- Get all branches and their last commit dates
	local cmd = "git for-each-ref "
		.. "refs/remotes/ "
		.. "--sort=-committerdate "
		.. "--format='%(refname:short),%(committerdate:iso8601)' "

	local handle = io.popen(cmd)
	if not handle then
		return {}
	end

	-- Calculate date 30 days ago in seconds since epoch
	local a_month_ago = os.time() - (30 * 24 * 60 * 60)

	local branches = {}
	for line in handle:lines() do
		local branch_name, date = line:match("'?([^,]+),([^']*)")
		local branch_time = os.time({
			year = tonumber(date:sub(1, 4)) or 0,
			month = tonumber(date:sub(6, 7)) or 0,
			day = tonumber(date:sub(9, 10)) or 0,
			hour = tonumber(date:sub(12, 13)),
			min = tonumber(date:sub(15, 16)),
			sec = tonumber(date:sub(18, 19)),
		})

		-- Stop reading when we hit branches older than 30 days
		if branch_time < a_month_ago then
			break
		end

		table.insert(branches, {
			name = branch_name:gsub("^origin/", ""),
			time = branch_time,
		})
	end

	handle:close()
	return branches
end

vim.git.diff_branch = function(branch_name, callback)
	if not branch_name or not callback then
		return
	end

	local job = require("plenary.job")
	local base = vim.git.default_branch()
	if not base then
		return
	end

	local ref = string.format("origin/%s...origin/%s", base, branch_name)

	-- Create jobs upfront to avoid nested declarations
	local diff_lines = {}
	local commit_lines = {}

	-- Create log job
	local log_job = job:new({
		command = "git",
		args = { "log", ref },
		on_start = function()
			print(string.format("Listing commit messages on %s ...", branch_name))
		end,
		on_stdout = vim.schedule_wrap(function(_, line)
			if line then
				table.insert(commit_lines, line)
			end
		end),
		on_exit = vim.schedule_wrap(function()
			-- return back the results
			callback({
				diff_lines = diff_lines,
				commit_lines = commit_lines,
			})
		end),
	})

	-- Execute diff job
	-- to ignore files (ex. package-lock.json) add 'package-lock.json -diff' to .gitattributes
	job:new({
		command = "git",
		args = { "diff", ref },
		on_start = function()
			print(string.format("Generating diff: %s", ref))
		end,
		on_stdout = function(_, data)
			if data then
				table.insert(diff_lines, data)
			end
		end,
		on_exit = function(_, exit_code)
			if exit_code == 0 then
				log_job:start()
			end
		end,
	}):start()
end
