-- Show only the last two segments of a path (parent/filename)
vim.fs.get_short_path = function(path)
	local path_separator = path:find("\\") and "\\" or "/"
	local segments = vim.split(path, path_separator)

	if #segments == 0 then
		return path
	elseif #segments == 1 then
		return segments[#segments]
	end

	return table.concat({ segments[#segments - 1], segments[#segments] }, path_separator)
end

-- Show the path relative to the current working directory
vim.fs.get_relative_path = function(filename)
	return vim.fn.fnamemodify(filename, ":~:.")
end

-- Read the contents of a file
vim.fs.read_file = function(filename)
	local file = io.open(filename, "r")
	if not file then
		return nil
	end

	local content = file:read("*all")
	file:close()

	return content
end

-- List files in given directory
vim.fs.list_dir = function(path)
	local files = {}

	if not vim.fn.isdirectory(path) then
		vim.notify("Directory does not exist", vim.log.levels.WARN)
		return files
	end

	for _, file in ipairs(vim.fn.readdir(path)) do
		table.insert(files, file)
	end

	return files
end

-- List all directories in the current working directory
vim.fs.list_dirs = function(opts)
	local ignore_git_dirs = opts.ignore_git_dirs or false
	local dirs_to_exclude = opts.dirs_to_exclude or {}

	local gitignore_dirs = {}
	if not ignore_git_dirs then
		gitignore_dirs = vim.fn.systemlist("git ls-files --others --ignored --exclude-standard --directory")
	end

	local dirs = {}
	local conditions = {}

	local cmd = ""
	if vim.fn.has("win32") == 1 then
		for _, dir in ipairs(gitignore_dirs) do
			dir = dir:gsub("/", "\\")
			table.insert(conditions, "Not-Match '.+\\" .. dir .. ".*'")
		end
		for _, dir in ipairs(dirs_to_exclude) do
			dir = dir:gsub("/", "\\")
			table.insert(conditions, "Not-Name '" .. dir .. "'")
		end
		local exclude = table.concat(conditions, " -and ")
		cmd = 'powershell -Command "&{Get-ChildItem -Directory -Recurse | Where-Object {'
			.. exclude
			.. '} | Select-Object -ExpandProperty FullName | ForEach-Object { $_.Substring($pwd.Path.Length + 1) } | Sort-Object}"'
	else
		for _, dir in ipairs(gitignore_dirs) do
			table.insert(conditions, "-path '*" .. dir .. "*'")
		end
		for _, dir in ipairs(dirs_to_exclude) do
			table.insert(conditions, "-name " .. dir)
		end
		local exclude = table.concat(conditions, " -o ")
		cmd = "find . -type d \\( " .. exclude .. " \\) -prune -o -type d -print | sort"
	end

	dirs = vim.fn.systemlist(cmd)
	if #dirs == 0 then
		return {}
	end

	return dirs
end
