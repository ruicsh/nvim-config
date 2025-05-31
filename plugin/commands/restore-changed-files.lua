-- Open all git changed files

-- Ignore files with this basename
local IGNORE_BASENAMES = {
	"lazy-lock.json",
	"package-lock.json",
	"yarn.lock",
}

-- Ignore files with these extensions
local IGNORE_EXTENSIONS = {
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
	-- Ignore by extension
	local extension = file:match("^.+(%..+)$")
	if extension then
		for _, ignore_extension in ipairs(IGNORE_EXTENSIONS) do
			if extension:lower() == ignore_extension:lower() then
				return true
			end
		end
	end

	-- Ignore by basename
	local basename = vim.fs.basename(file)
	for _, ignore_basename in ipairs(IGNORE_BASENAMES) do
		if basename:lower() == ignore_basename:lower() then
			return true
		end
	end

	-- Ignore by .env
	local env_ignore_files = vim.fn.env_get_list("RESTORE_CHANGED_FILES_IGNORE")
	for _, ignore_file in ipairs(env_ignore_files) do
		if file:lower():find(ignore_file:lower(), 1, true) then
			return true
		end
	end

	return false
end

-- List files changed on git status.
local function get_changed_files(callback)
	-- Early return if not in a git repo
	if not vim.git.is_git() then
		return callback({})
	end

	local git_root = vim.git.root()
	if not git_root then
		return callback({})
	end

	-- Pre-allocate table with expected size
	local files = table.new and table.new(64, 0) or {}

	-- Use local references for better performance
	local job = require("plenary.job")
	local normalize = vim.fs.normalize
	local isdirectory = vim.fn.isdirectory

	-- Track pending async operations
	local pending_operations = 0
	local completed = false

	-- Helper function to check if all operations are done
	local function check_completion()
		if completed and pending_operations == 0 then
			vim.schedule(function()
				callback(files)
			end)
		end
	end

	-- Run git status asynchronously using plenary.job
	job:new({
		command = "git",
		args = { "-C", git_root, "status", "--porcelain=v1" },
		on_exit = function(j, return_code)
			if return_code ~= 0 then
				callback({})
				return
			end

			-- Process the output
			local function process_files()
				local stdout = j:result()

				for _, line in ipairs(stdout) do
					if line ~= "" then
						local file = normalize(git_root .. "/" .. line:sub(4))

						if isdirectory(file) == 1 then
							-- Process directory contents asynchronously
							pending_operations = pending_operations + 1
							job:new({
								command = "fd",
								args = { "--type", "f", ".", file },
								on_exit = function(find_j, find_return_code)
									-- Handle find command errors
									if find_return_code ~= 0 then
										vim.schedule(function()
											vim.notify(
												string.format(
													"Error processing directory: %s (fd command failed)",
													file
												),
												vim.log.levels.WARN
											)
										end)
										pending_operations = pending_operations - 1
										check_completion()
										return
									end

									local found_files = find_j:result()
									for _, found_file in ipairs(found_files) do
										files[#files + 1] = normalize(found_file)
									end
									pending_operations = pending_operations - 1
									check_completion()
								end,
								on_stderr = function(_, data)
									-- Log stderr output if any
									if data and #data > 0 then
										vim.schedule(function()
											vim.notify(
												string.format(
													"fd command error for %s: %s",
													file,
													type(data) == "table" and table.concat(data, "\n") or tostring(data)
												),
												vim.log.levels.WARN
											)
										end)
									end
								end,
							}):start()
						else
							files[#files + 1] = file
						end
					end
				end

				-- Mark initial processing as complete
				completed = true
				check_completion()
			end

			-- Schedule the processing to avoid blocking
			vim.schedule(process_files)
		end,
	}):start()
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

vim.api.nvim_create_user_command("RestoreChangedFiles", function()
	get_changed_files(function(files)
		files = prune_list(files)
		files = sort_by_mtime(files)

		if #files == 0 then
			return
		end

		-- Add older changed files to the buffer list
		if #files > 2 then
			for i = 1, #files - 3 do
				vim.cmd.badd(files[i])
			end
		end

		-- Open the last changed file
		vim.cmd.edit(files[#files])

		-- Open the second last changed file in a new window
		if #files > 1 then
			vim.cmd.vsplit(files[#files - 1])
		end

		-- Place cursor on the last changed file window
		vim.cmd.wincmd("h")
	end)
end, {})
