-- Session management

local function get_session_name()
	local cwd = vim.fn.getcwd()
	local dir_sep = vim.fn.is_windows() and "\\" or "/"

	-- Safe git branch retrieval with fallback
	local branch = "default"
	local git_dir = vim.fs.find_upwards(".git")
	if git_dir and vim.fn.isdirectory(git_dir) == 1 then
		local head_file = git_dir .. dir_sep .. "HEAD"
		if vim.fn.filereadable(head_file) == 1 then
			local head_content = vim.fn.readfile(head_file)[1]
			if head_content and head_content:match("^ref: refs/heads/") then
				branch = head_content:gsub("ref: refs/heads/(.+)", "%1")
			end
		end
	end

	local name = cwd:gsub("[:\\/%s]", "_") .. "_" .. branch
	return name
end

local function get_session_path()
	local dir_sep = vim.fn.is_windows() and "\\" or "/"

	local name = get_session_name()
	local dir = vim.fn.stdpath("data") .. dir_sep .. "sessions"
	vim.fn.mkdir(dir, "p")

	return dir .. dir_sep .. name .. ".vim"
end

local function save_session()
	local path = get_session_path()
	vim.cmd("mksession! " .. vim.fn.fnameescape(path))
end

local function restore_session()
	local path = get_session_path()
	if vim.fn.filereadable(path) == 1 then
		vim.cmd("source " .. vim.fn.fnameescape(path))
		vim.defer_fn(function()
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local buf = vim.api.nvim_win_get_buf(win)
				vim.api.nvim_exec_autocmds("BufRead", { buffer = buf })
			end
		end, 10)
	end
end

vim.api.nvim_create_autocmd("VimLeavePre", { callback = save_session })
vim.api.nvim_create_autocmd("VimEnter", { callback = restore_session })
