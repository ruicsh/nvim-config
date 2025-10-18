vim.fs = vim.fs or {}

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

vim.fs.rmdir = function(dir)
	local job = require("plenary.job")
	if dir and dir ~= "" then
		if vim.fn.has("win32") == 1 then
			-- Windows command
			job:new({
				command = "cmd",
				args = { "/c", "rmdir", "/s", "/q", dir },
			}):start()
		else
			-- Unix command
			job:new({
				command = "rm",
				args = { "-rf", dir },
			}):start()
		end
	end
end

vim.fs.find_upwards = function(target)
	local dir = vim.fn.getcwd()
	local dir_sep = vim.fn.is_windows() == 1 and "\\" or "/"
	while dir ~= "/" do
		local candidate = dir .. dir_sep .. target
		if vim.fn.isdirectory(candidate) == 1 or vim.fn.filereadable(candidate) == 1 then
			return candidate
		end
		dir = vim.fn.fnamemodify(dir, ":h")
	end
	return nil
end
