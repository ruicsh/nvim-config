vim.git = {}

vim.git.is_git = function()
	local output = vim.fn.system("git rev-parse --is-inside-work-tree")
	return output:match("^true")
end

-- Finds the root dir for the current git repo
vim.git.root = function()
	local git_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
	if vim.v.shell_error ~= 0 then
		return
	end

	return git_root
end

-- Get blame info for a file/line
vim.git.blame = function(opts)
	local cmd_parts = {}
	table.insert(cmd_parts, "git blame --porcelain")
	if opts.line then
		table.insert(cmd_parts, "-L " .. opts.line .. "," .. opts.line)
	end
	if opts.filename then
		table.insert(cmd_parts, opts.filename)
	end
	-- git blame --porcelain -L 10,10 src/file.lua
	local cmd = table.concat(cmd_parts, " ")
	local output = vim.fn.systemlist(cmd)

	local info = {}
	info.hash = output[1]:match("%w+")

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

vim.git.get_repo_url = function()
	local result = vim.fn.exec("git config --get remote.origin.url")
	if not result then
		return nil, "Error with remote.origin.url"
	end

	result = result:gsub("^%s*(.-)%s*$", "%1")
	if result == "" then
		return nil, "No remote URL found"
	end

	result = result:gsub("%.git$", "")

	return result
end

vim.git.get_default_branch = function()
	-- Use `git symbolic-ref` to directly get the default branch name
	local result = vim.fn.exec("git symbolic-ref refs/remotes/origin/HEAD --short")
	if not result then
		return nil, "Failed to execute git command"
	end

	if result then
		-- Remove 'origin/' prefix from the branch name and remove the trailing newline
		return result:gsub("^origin/", ""):gsub("%s+$", "")
	end

	return nil, "Could not find HEAD branch"
end

vim.git.list_branches = function()
	local default_branch = vim.git.get_default_branch()
	if not default_branch then
		return {}
	end

	-- Calculate date 30 days ago in seconds since epoch
	local a_month_ago = os.time() - (30 * 24 * 60 * 60)

	-- Get all branches and their last commit dates
	local cmd = "git for-each-ref "
		.. "refs/remotes/ "
		.. "--sort=-committerdate "
		.. "--format='%(refname:short),%(committerdate:iso8601)' "
		.. string.format("--no-contains=refs/remotes/origin/%s ", default_branch)

	local branches = {}
	local handle = io.popen(cmd)
	if not handle then
		return {}
	end

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

vim.git.gen_diff_between_branches = function(opts, callback)
	local job = require("plenary.job")

	local repo_dir = opts.repo_dir
	local base = opts.base
	local head = opts.head
	local ref = string.format("origin/%s...origin/%s", base, head)

	local diff_lines = {}

	job:new({
		command = "git",
		args = { "-C", repo_dir, "fetch", "origin" },
		on_start = function()
			print("Fetching branches ...")
		end,
		on_exit = function(_, exit_code)
			if exit_code ~= 0 then
				return
			end

			-- Diff base..head
			job:new({
				command = "git",
				args = { "-C", repo_dir, "diff", ref },
				on_start = function()
					print("Generating diff: " .. ref)
				end,
				on_stdout = function(_, data)
					if data then
						table.insert(diff_lines, data)
					end
				end,
				on_exit = function(_, exit_code2)
					if exit_code2 ~= 0 then
						return
					end

					local commit_lines = {}

					-- Commit messages
					job:new({
						command = "git",
						args = { "-C", repo_dir, "log", ref },
						on_start = function()
							print("Listing commit messages on " .. head .. " ...")
						end,
						on_stdout = vim.schedule_wrap(function(_, line)
							if line then
								table.insert(commit_lines, line)
								return
							end

							-- Clean up
							if repo_dir and repo_dir ~= "" then
								job:new({
									command = "rm",
									args = { "-rf", repo_dir },
								}):start()
							end

							callback({
								diff_lines = diff_lines,
								commit_lines = commit_lines,
							})
						end),
					}):start()
				end,
			}):start()
		end,
	}):start()
end

vim.git.get_branch_diff = function(branch_name, callback)
	local job = require("plenary.job")

	local temp_dir = vim.fn.tempname()
	local repo_url = vim.git.get_repo_url()

	job:new({
		command = "git",
		args = { "clone", "--no-checkout", "--filter=blob:none", repo_url, temp_dir },
		on_start = function()
			print("Cloning repository: " .. repo_url .. " ...")
		end,
		on_exit = function(_, exit_code)
			if exit_code ~= 0 then
				return
			end

			local default_branch = vim.git.get_default_branch()
			if not default_branch then
				return
			end
			local head_branch = branch_name

			vim.git.gen_diff_between_branches({
				repo_dir = temp_dir,
				base = default_branch,
				head = head_branch,
			}, callback)
		end,
	}):start()
end
