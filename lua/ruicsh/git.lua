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
	local handle = io.popen("git config --get remote.origin.url")
	if not handle then
		return nil, "Could not execute git command"
	end

	local result = handle:read("*a")
	handle:close()

	result = result:gsub("^%s*(.-)%s*$", "%1")
	if result == "" then
		return nil, "No remote URL found"
	end

	if result:match("^git@") then
		result = result:gsub("^git@([^:]+):", "https://%1/")
	end

	result = result:gsub("%.git$", "")

	return result
end

vim.git.get_base_branch = function()
	local handle = io.popen("git remote show origin | grep 'HEAD branch' | cut -d' ' -f5")
	if not handle then
		return "main"
	end

	local result = handle:read("*a"):gsub("%s+$", "")
	handle:close()

	return #result > 0 and result or "main"
end

vim.git.gen_diff_between_branches = function(opts, callback)
	local job = require("plenary.job")

	local dest_dir = opts.dest_dir
	local base = opts.base
	local head = opts.head
	local ref = string.format("origin/%s...origin/%s", base, head)

	local diff_lines = {}

	job:new({
		command = "git",
		args = { "-C", dest_dir, "fetch", "origin" },
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
				args = { "-C", dest_dir, "diff", ref },
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
						args = { "-C", dest_dir, "log", ref },
						on_start = function()
							print("Listing commit messages on " .. head .. " ...")
						end,
						on_stdout = vim.schedule_wrap(function(_, line)
							if line then
								table.insert(commit_lines, line)
								return
							end

							-- Clean up
							job:new({
								command = "rm",
								args = { "-rf", dest_dir },
							}):start()

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

vim.git.get_branch_diff = function(callback)
	local snacks = require("snacks")

	snacks.input({
		prompt = "Enter branch name to review:",
	}, function(branch)
		local job = require("plenary.job")

		local temp_dir = vim.fn.tempname()
		local repo_url = vim.git.get_repo_url()
		local head = branch
		local base = vim.git.get_base_branch()

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

				vim.git.gen_diff_between_branches({
					dest_dir = temp_dir,
					base = base,
					head = head,
				}, callback)
			end,
		}):start()
	end)
end
