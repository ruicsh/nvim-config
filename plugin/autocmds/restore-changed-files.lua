-- On VimEnter, open all git changed files in current working directory.

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/restore_changed_files", { clear = true })

-- ignore files with these basenames
local ignore_basenames = {
	"lazy-lock.json",
	"package-lock.json",
	"yarn.lock",
}

-- ignore files with these extensions
local ignore_extensions = {
	".bmp",
	".bru",
	".gif",
	".jpeg",
	".jpg",
	".png",
	".snap",
	".svg",
	".tiff",
	".webp",
}

local function is_file_to_ignore(file)
	-- ignore by extension
	local extension = file:match("^.+(%..+)$")
	if extension then
		for _, ignore_extension in ipairs(ignore_extensions) do
			if extension:lower() == ignore_extension:lower() then
				return true
			end
		end
	end

	-- ignore by basename
	local basename = vim.fs.basename(file)
	for _, ignore_basename in ipairs(ignore_basenames) do
		if basename:lower() == ignore_basename:lower() then
			return true
		end
	end

	-- ignore by .env
	local env_ignore_files = vim.fn.getenv("RESTORE_CHANGED_FILES_IGNORE")
	if env_ignore_files ~= vim.NIL and env_ignore_files ~= "" then
		local ignore_files = vim.split(env_ignore_files, ",")
		for _, ignore_file in ipairs(ignore_files) do
			if file:lower():find(ignore_file:lower()) then
				return true
			end
		end
	end

	return false
end

-- List files changed on git status.
local function get_changed_files()
	-- Check if we're in a git repo first
	if not vim.git.is_git() then
		return {}
	end

	local git_root = vim.git.root()
	if not git_root then
		return {}
	end

	local git_cmd = "git -C " .. vim.fn.shellescape(git_root)
	local status_cmd = git_cmd .. " status --porcelain=v1"
	local status_output = vim.fn.systemlist(status_cmd)

	local files = {}
	-- Process each status line
	for _, line in ipairs(status_output) do
		if line ~= "" then
			-- Extract filename from status output (starts at position 4)
			local file = line:sub(4)
			local filepath = vim.fs.normalize(git_root .. "/" .. file)

			if vim.fn.isdirectory(filepath) == 1 then
				-- Handle directories
				local ok, dir_files = pcall(vim.fs.dir, filepath, { depth = 9999 })
				if ok then
					for dirfile, type in dir_files do
						if type == "file" then
							local dirfilepath = vim.fs.joinpath(filepath, dirfile)
							table.insert(files, dirfilepath)
						end
					end
				end
			else
				table.insert(files, filepath)
			end
		end
	end

	return files
end

-- Prune list of files from files to ignore or unreadable.
local function prune_list(filepaths)
	local to_read_files = {}
	for _, file in ipairs(filepaths) do
		if not is_file_to_ignore(file) then
			if vim.fn.filereadable(file) == 1 then
				table.insert(to_read_files, file)
			end
		end
	end

	return to_read_files
end

-- Sort files by last updated time.
local function sort_by_mtime(filepaths)
	table.sort(filepaths, function(a, b)
		local mtime_a = vim.fn.getftime(a)
		local mtime_b = vim.fn.getftime(b)
		return mtime_a < mtime_b
	end)

	return filepaths
end

vim.api.nvim_create_autocmd({ "VimEnter" }, {
	group = augroup,
	callback = function()
		-- if vim was opened with files, don't open changed files
		if #vim.fn.argv() > 0 then
			return
		end

		-- Check if Lazy is open
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local buf = vim.api.nvim_win_get_buf(win)
			local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
			if filetype == "lazy" then
				return -- Exit the callback if Lazy is open
			end
		end

		vim.schedule(function()
			local files = get_changed_files()
			files = prune_list(files)
			files = sort_by_mtime(files)

			-- always open a vertical split and focus on the left
			vim.cmd.vsplit()
			vim.cmd.wincmd("h")

			if #files == 0 then
				return
			end

			-- open the last modified on the left
			vim.cmd.edit(files[#files])

			-- if there's more than one file, open them all
			if #files > 1 then
				vim.cmd.wincmd("l")
				for i = 1, #files - 1 do
					vim.cmd.edit(files[i])
				end
				-- Focus on the left window
				vim.cmd.wincmd("h")
			end
		end)
	end,
})
