-- On VimEnter, open all git changed files in current working directory.

local scan_dir = require("plenary.scandir").scan_dir

local group = vim.api.nvim_create_augroup("ruicsh/restore_changed_files", { clear = true })

-- ignore files with these basenames
local ignore_basenames = {
	"lazy-lock.json",
	"package-lock.json",
	"yarn.lock",
}

-- ignore files with these extensions
local ignore_extensions = {
	".bmp",
	".gif",
	".jpeg",
	".jpg",
	".png",
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

	return false
end

-- List files changed on git status.
local function get_changed_files()
	local git_root = vim.fn.getgitroot()
	local git_status = vim.fn.systemlist("git status --porcelain")

	local changed_files = {}
	for _, line in ipairs(git_status) do
		-- remove the trailing symbols from git
		local status, file = line:match("^(..)%s+(.*)")
		if status and file then
			-- Generate absolute path for each file (relative to the git repo root)
			local filepath = vim.fs.normalize(git_root .. "/" .. file)
			if vim.fn.isdirectory(filepath) ~= 0 then
				local dir_files = scan_dir(filepath)
				for _, dir_file in ipairs(dir_files) do
					table.insert(changed_files, dir_file)
				end
			else
				table.insert(changed_files, filepath)
			end
		end
	end

	return changed_files
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
	group = group,
	callback = function()
		vim.schedule(function()
			local files = get_changed_files()
			files = prune_list(files)
			files = sort_by_mtime(files)

			-- Use vim.cmd.edit to open the file in a new buffer
			local n_files = vim.tbl_count(files)
			for i, file in ipairs(files) do
				-- limit to the last 10 updated files
				if i > n_files - 10 then
					vim.cmd.edit(file)
				end
			end
		end)
	end,
})
