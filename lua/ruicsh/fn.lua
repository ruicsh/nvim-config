-- Finds the root dir for the current git repo
vim.fn.get_git_root = function()
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
vim.fn.get_lazy_keys_conf = function(mappings, desc_prefix)
	return vim.tbl_map(function(mapping)
		local lhs = mapping[1]
		local rhs = mapping[2]
		local desc = desc_prefix and desc_prefix .. ": " .. mapping[3] or mapping[3]
		local opts = mapping[4]
		local mode = opts and opts.mode or "n"

		return { lhs, rhs, silent = true, mode = mode, noremap = true, unique = true, desc = desc }
	end, mappings)
end

-- Check if a keymap is set
vim.fn.is_keymap_set = function(mode, lhs)
	local keymaps = vim.api.nvim_get_keymap(mode)
	for _, keymap in ipairs(keymaps) do
		if keymap.lhs == lhs then
			return true
		end
	end
	return false
end

-- Check if a diff window is open
vim.fn.is_diff_open = function()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_get_option_value("diff", { win = win }) then
			return true
		end
	end
end

vim.fn.is_windows = function()
	return vim.fn.has("win32") == 1
end
