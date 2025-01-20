-- Keeping buffers in tabs scoped to the tab they were opened in
-- https://github.com/tiagovla/scope.nvim

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/scoped_tabs", { clear = true })

local cache = {}
local last_tab = 0

local function is_valid_buffer(bufnr)
	if not bufnr or bufnr < 1 then
		return false
	end
	local exists = vim.api.nvim_buf_is_valid(bufnr)
	return vim.bo[bufnr].buflisted and exists
end

local function get_valid_buffers()
	local bufnrs = vim.api.nvim_list_bufs()
	local ids = {}
	for _, bufnr in ipairs(bufnrs) do
		if is_valid_buffer(bufnr) then
			table.insert(ids, bufnr)
		end
	end
	return ids
end

vim.api.nvim_create_autocmd("TabNewEntered", {
	group = augroup,
	callback = function()
		vim.api.nvim_set_option_value("buflisted", true, { buf = 0 })
	end,
})

vim.api.nvim_create_autocmd("TabEnter", {
	group = augroup,
	callback = function()
		local tab = vim.api.nvim_get_current_tabpage()
		local buf_nums = cache[tab]
		if buf_nums then
			for _, buf in pairs(buf_nums) do
				vim.api.nvim_set_option_value("buflisted", true, { buf = buf })
			end
		end
	end,
})

vim.api.nvim_create_autocmd("TabLeave", {
	group = augroup,
	callback = function()
		local tab = vim.api.nvim_get_current_tabpage()
		local buf_nums = get_valid_buffers()
		cache[tab] = buf_nums
		for _, bufnr in pairs(buf_nums) do
			vim.api.nvim_set_option_value("buflisted", false, { buf = bufnr })
		end
		last_tab = tab
	end,
})

vim.api.nvim_create_autocmd("TabClosed", {
	group = augroup,
	callback = function()
		cache[last_tab] = nil
	end,
})
