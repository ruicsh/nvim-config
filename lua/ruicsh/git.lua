vim.git = {}

-- Finds the root dir for the current git repo
vim.git.root = function()
	-- git submodules have a file named .git, not a dir named .git
	local dot_git_file = vim.fn.findfile(".git", ".;")
	local dot_git_filedir = string.len(dot_git_file) ~= 0 and vim.fn.fnamemodify(dot_git_file, ":h") or false

	-- cwd is the root of a submodule
	if dot_git_filedir == "." then
		return dot_git_filedir
	end

	local dot_git_dir = vim.fn.finddir(".git", ".;")
	dot_git_dir = vim.fn.fnamemodify(dot_git_dir, ":h")

	-- it's not a submodule, we found the git dir, this is the one
	if not dot_git_filedir then
		return dot_git_dir
	end

	-- if the submodule dir is longer, means it's deeper down the tree, use that
	if string.len(dot_git_filedir) > string.len(dot_git_dir) then
		return dot_git_filedir
	end

	return dot_git_dir
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
