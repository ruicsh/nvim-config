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
