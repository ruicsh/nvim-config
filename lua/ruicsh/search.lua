local ns_id = vim.api.nvim_create_namespace("ruicsh/core/search")

vim.search = vim.search or {}

local extmark_id

vim.search.show_search_count = function()
	local sc = vim.fn.searchcount({ maxcount = 9999 })
	if sc.current == 0 or sc.total == 0 then
		return
	end

	-- Clear previous extmark
	if extmark_id then
		vim.api.nvim_buf_del_extmark(0, ns_id, extmark_id)
	end

	local lnum = vim.fn.line(".")
	extmark_id = vim.api.nvim_buf_set_extmark(0, ns_id, lnum - 1, 0, {
		virt_text = { { string.format("[%d/%d]", sc.current, sc.total), "InlineSearchCount" } },
		virt_text_pos = "eol",
		hl_mode = "combine",
	})
end

vim.search.clear_search_count = function()
	if extmark_id then
		vim.api.nvim_buf_del_extmark(0, ns_id, extmark_id)
		extmark_id = nil
	end
end
