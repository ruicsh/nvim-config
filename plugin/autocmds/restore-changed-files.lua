-- On VimEnter, open all git changed files in current working directory.

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

local function is_to_ignore_file(file)
	-- ignore by extension
	local extension = file:match("^.+(%..+)$")
	if extension then
		for _, ignore_extension in ipairs(ignore_extensions) do
			if extension:lower() == ignore_extension then
				return true
			end
		end
	end

	-- ignore by basename
	local basename = file:match("([^/\\]+)$")
	for _, ignore_basename in ipairs(ignore_basenames) do
		if basename:lower() == ignore_basename then
			return true
		end
	end

	return false
end

vim.api.nvim_create_autocmd({ "VimEnter" }, {
	group = group,
	callback = function()
		vim.schedule(function()
			-- Run the git status command to get changed files.
			local git_status = vim.fn.systemlist("git status --porcelain")

			-- Filter out the lines that represent changed files and map them to absolute paths.
			local changed_files = {}
			for _, line in ipairs(git_status) do
				local status, file = line:match("^(..)%s+(.*)")
				if status and file then
					-- Generate absolute path for each file (relative to the git repo root)
					local abs_path = vim.fn.expand("%:p:h") .. "/" .. file
					table.insert(changed_files, abs_path)
				end
			end

			-- ignore configured files
			local to_read_files = {}
			for _, file in ipairs(changed_files) do
				if not is_to_ignore_file(file) then
					table.insert(to_read_files, file)
				end
			end

			-- Use vim.cmd.edit to open the file in a new buffer
			for _, file in ipairs(to_read_files) do
				if vim.fn.filereadable(file) == 1 then
					vim.cmd.edit(file)
				end
			end
		end)
	end,
})
