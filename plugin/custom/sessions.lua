-- Session management

local augroup = vim.api.nvim_create_augroup("ruicsh/custom/sessions", { clear = true })

-- Generate a session name based on the git-repo/git-branch or current directory
local function get_session_name()
	local name = ""
	local cwd = vim.fn.getcwd()
	local dir_sep = vim.fn.is_windows() and "\\" or "/"

	local git_root = vim.fs.root(cwd, ".git")
	local git_dir = git_root and git_root .. dir_sep .. ".git" or nil
	if git_dir and vim.fn.isdirectory(git_dir) == 1 then
		local branch = "default"
		local head_file = git_dir .. dir_sep .. "HEAD"
		if vim.fn.filereadable(head_file) == 1 then
			local head_content = vim.fn.readfile(head_file)[1]
			if head_content and head_content:match("^ref: refs/heads/") then
				branch = head_content:gsub("ref: refs/heads/(.+)", "%1")
			end
		end
		local git_repo = vim.fn.fnamemodify(git_dir, ":h:t")
		name = git_repo:gsub("[:\\/%s]", "_") .. "_" .. branch
	else
		name = cwd:gsub("[:\\/%s]", "_")
	end

	return name
end

-- Get the full path to the session file
local function get_session_path()
	local dir_sep = vim.fn.is_windows() and "\\" or "/"

	local name = get_session_name()
	local dir = vim.fn.stdpath("data") .. dir_sep .. "sessions"
	vim.fn.mkdir(dir, "p")

	return dir .. dir_sep .. name .. ".vim"
end

-- Save the current session to a file
local function save_session()
	if vim.g.skip_session then
		return
	end

	local path = get_session_path()
	vim.cmd("mksession! " .. vim.fn.fnameescape(path))
end

-- Restore the session from a file
local function restore_session()
	if vim.fn.argc() > 0 or vim.g.started_with_stdin then
		vim.g.skip_session = true
		return
	end

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

-- Mark that Neovim was started with piped input, no session should be loaded
vim.api.nvim_create_autocmd({ "StdinReadPre" }, {
	group = augroup,
	callback = function()
		vim.g.started_with_stdin = true
	end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	group = augroup,
	callback = save_session,
})

vim.api.nvim_create_autocmd("VimEnter", {
	group = augroup,
	callback = restore_session,
})
