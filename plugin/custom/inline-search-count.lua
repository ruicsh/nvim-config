-- Search count indicator
-- https://github.com/chrisgrieser/.config/blob/main/nvim/lua/config/autocmds.lua

local ns = vim.api.nvim_create_namespace("ruicsh/custom/inline-search-count")

local function searchCountIndicator(mode)
	local signColumnPlusScrollbarWidth = 2 + 3 -- CONFIG

	local countNs = vim.api.nvim_create_namespace("ruicsh/search_counter")
	vim.api.nvim_buf_clear_namespace(0, countNs, 0, -1)
	if mode == "clear" then
		return
	end

	local row = vim.api.nvim_win_get_cursor(0)[1]
	local count = vim.fn.searchcount()
	if count.total == 0 then
		return
	end

	local text = (" %d/%d "):format(count.current, count.total)
	local line = vim.api.nvim_get_current_line():gsub("\t", (" "):rep(vim.bo.shiftwidth))
	local lineFull = #line + signColumnPlusScrollbarWidth >= vim.api.nvim_win_get_width(0)
	local margin = { (" "):rep(lineFull and signColumnPlusScrollbarWidth or 0) }

	vim.api.nvim_buf_set_extmark(0, countNs, row - 1, 0, {
		virt_text = { { text, "InlineSearchCount" }, margin },
		virt_text_pos = lineFull and "right_align" or "eol",
		priority = 200, -- So it comes in front of `nvim-lsp-endhints`
	})
end

vim.on_key(function(key)
	key = vim.fn.keytrans(key)

	local isCmdlineSearch = vim.fn.getcmdtype():find("[/?]") ~= nil
	local isNormalMode = vim.api.nvim_get_mode().mode == "n"
	local searchStarted = (key == "/" or key == "?") and isNormalMode
	local searchConfirmed = (key == "<cr>" and isCmdlineSearch)
	local searchCancelled = (key == "<esc>" and isCmdlineSearch)
	if not (searchStarted or searchConfirmed or searchCancelled or isNormalMode) then
		return
	end

	-- Works for RHS - therefore no need to consider remaps
	local searchMovement = vim.tbl_contains({ "n", "N", "*", "#" }, key)
	local shortPattern = vim.fn.getreg("/"):gsub([[\V\C]], ""):len() <= 1 -- For `fF` function

	if searchCancelled or (not searchMovement and not searchConfirmed) then
		searchCountIndicator("clear")
	elseif (searchMovement and not shortPattern) or searchConfirmed or searchStarted then
		vim.defer_fn(searchCountIndicator, 1)
	end
end, ns)
