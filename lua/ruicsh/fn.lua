-- Finds the root dir for the current git repo
vim.fn.getgitroot = function()
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

-- Takes a table of keys, returns a keymaps lazy config
vim.fn.getlazykeysconf = function(mappings, desc_prefix, opts)
	local mode = opts and opts.mode or "n"
	return vim.tbl_map(function(mapping)
		local lhs = mapping[1]
		local rhs = mapping[2]
		local desc = desc_prefix .. ": " .. mapping[3]
		return { lhs, rhs, silent = true, mode = mode, noremap = true, unique = true, desc = desc }
	end, mappings)
end
