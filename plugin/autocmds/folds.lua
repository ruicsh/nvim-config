-- Save and restore folds for each buffer

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/folds", { clear = true })

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
	group = augroup,
	pattern = "*",
	callback = function()
		local folds = list_folds()
		local fold_file = get_fold_file()
		if #folds > 0 then
			local file = io.open(fold_dir .. "/" .. fold_file, "w")
			if file then
				for _, ln in ipairs(folds) do
					file:write(ln .. " foldclose\n")
				end
				file:close()
			end
		elseif #folds == 0 then
			-- delete the file if it exists
			if vim.fn.filereadable(fold_dir .. "/" .. fold_file) == 1 then
				vim.fn.delete(fold_dir .. "/" .. fold_file)
			end
		end
	end,
})

-- Apply fold commands to the buffer
local function process_folds(file)
	for cmd in file:lines() do
		local ok, ln = pcall(function()
			return tonumber(cmd:match("^(%d+)"))
		end)

		if ok and ln and ln <= vim.fn.line("$") and vim.fn.foldclosed(ln) == -1 then
			pcall(vim.cmd, cmd)
		end
	end
end

-- Restore folds when reading a buffer
vim.api.nvim_create_autocmd("BufWinEnter", {
	group = augroup,
	pattern = "*",
	callback = function()
		local fold_file = get_fold_file()
		local file_path = fold_dir .. "/" .. fold_file
		if vim.fn.filereadable(file_path) ~= 1 then
			return
		end

		-- Read file and apply commands with pcall for safety
		local file = io.open(file_path, "r")
		if not file then
			return
		end

		-- Defer fold operations to ensure buffer is ready
		vim.schedule(function()
			process_folds(file)
			file:close()
		end)
	end,
})

-- Some files have special folding rules
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	pattern = "*/plugin/options.lua",
	callback = function()
		vim.opt_local.foldmethod = "marker" -- use {{{-}}} to create folds
	end,
})
