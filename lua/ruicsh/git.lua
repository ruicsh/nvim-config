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
