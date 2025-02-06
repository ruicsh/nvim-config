-- Save and restore folds for each buffer

-- Create a directory to store fold information
local fold_dir = vim.fn.stdpath("data") .. "/folds"
if vim.fn.isdirectory(fold_dir) == 0 then
	vim.fn.mkdir(fold_dir, "p")
end

-- Function to get the fold file path for a given buffer
local function get_fold_file()
	local file_path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":p") -- absolute path
	return file_path:gsub("[^%w]", ""):lower() -- sanitize the file path
end

-- List all lines with closed folds
local function list_folds()
	local folds = {}
	for i = 1, vim.api.nvim_buf_line_count(0) do
		local fc = vim.fn.foldclosed(i)
		if fc ~= -1 then
			if not vim.tbl_contains(folds, fc) then
				table.insert(folds, fc)
			end
		end
	end
	return folds
end

-- Save folds when closing a buffer
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*",
	callback = function()
		local folds = list_folds()
		if #folds > 0 then
			local fold_file = get_fold_file()
			local file = io.open(fold_dir .. "/" .. fold_file, "w")
			if file then
				for _, ln in ipairs(folds) do
					file:write(ln .. " foldclose\n")
				end
				file:close()
			end
		end
	end,
})

-- Restore folds when reading a buffer
vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*",
	callback = function()
		local fold_file = get_fold_file()
		local file_path = fold_dir .. "/" .. fold_file
		if vim.fn.filereadable(file_path) == 1 then
			-- Read file and apply commands
			local file = io.open(file_path, "r")
			if file then
				for cmd in file:lines() do
					local ln = tonumber(cmd:match("^(%d+)"))
					-- if the fold is already closed, don't close it again
					if vim.fn.foldclosed(ln) == -1 then
						vim.cmd(cmd)
					end
				end
				file:close()
			end
		end
	end,
})
