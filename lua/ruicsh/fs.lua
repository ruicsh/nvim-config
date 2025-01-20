-- Show only the last two segments of a path (parent/filename)
vim.fs.getshortpath = function(path)
	local path_separator = "/"
	local segments = vim.split(path, path_separator)

	if #segments == 0 then
		return path
	elseif #segments == 1 then
		return segments[#segments]
	end

	return table.concat({ segments[#segments - 1], segments[#segments] }, path_separator)
end

-- Show the path relative to the current working directory
vim.fs.getrelativepath = function(filename)
	return vim.fn.fnamemodify(filename, ":~:.")
end
