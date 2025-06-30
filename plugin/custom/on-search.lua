-- On search behaviours

-- 1. Pause folds on search
-- https://github.com/chrisgrieser/nvim-origami/blob/main/lua/origami/features/pause-folds-on-search.lua
-- 2. Search count indicator
-- https://github.com/chrisgrieser/.config/blob/main/nvim/lua/config/autocmds.lua

if vim.g.vscode then
	return
end

local ns = vim.api.nvim_create_namespace("ruicsh/custom/on-search")
local ns_count = vim.api.nvim_create_namespace("ruicsh/custom/on-search/count")

local lines_cache = {}

-- Show search count indicators with virtual text
local function searchCountIndicator(mode)
	local ft = vim.bo.filetype
	-- Don't show in these filetypes
	if ft == "snacks_picker_input" or ft == "gitcommit" or ft == "vim-messages" then
		return
	end

	local signColumnPlusScrollbarWidth = 2 + 3
	vim.api.nvim_buf_clear_namespace(0, ns_count, 0, -1)
	if mode == "clear" then
		lines_cache = {}
		return
	end

	local row = vim.api.nvim_win_get_cursor(0)[1]
	local count = vim.fn.searchcount()
	if not count or not count.total or count.total == 0 or count.current == nil then
		return
	end

	local text = (" %d/%d "):format(count.current, count.total)
	if lines_cache[row] == nil then
		lines_cache[row] = vim.api.nvim_get_current_line():gsub("\t", (" "):rep(vim.bo.shiftwidth))
	end
	local line = lines_cache[row]
	local lineFull = #line + signColumnPlusScrollbarWidth >= vim.api.nvim_win_get_width(0)
	local margin = { (" "):rep(lineFull and signColumnPlusScrollbarWidth or 0) }

	vim.api.nvim_buf_set_extmark(0, ns_count, row - 1, 0, {
		virt_text = { { text, "InlineSearchCount" }, margin },
		virt_text_pos = lineFull and "right_align" or "eol",
		priority = 200, -- So it comes in front of `nvim-lsp-endhints`
	})
end

local user_is_searching = false
-- Track the last motion to distinguish f/t from / search
local last_motion_type = nil

local function stop_searching()
	if user_is_searching then
		vim.opt_local.foldenable = true
		searchCountIndicator("clear")
		last_motion_type = nil
		user_is_searching = false
	end
end

vim.on_key(function(char)
	local key = vim.fn.keytrans(char)
	local isCmdlineSearch = vim.fn.getcmdtype():find("[/?]") ~= nil
	local isNormalMode = vim.api.nvim_get_mode().mode == "n"
	local isCmdlineMode = vim.api.nvim_get_mode().mode == "c"

	if isNormalMode then
		-- Toggle search highlighting
		if vim.api.nvim_get_mode().mode == "n" then
			vim.opt.hlsearch = vim.tbl_contains({ "<CR>", "n", "N", "*", "#", "?", "/" }, key)
		end

		-- Track f/t motions
		if vim.tbl_contains({ "f", "F", "t", "T" }, key) then
			last_motion_type = "ft"
			stop_searching()
			return
		end

		-- Jumping to search results
		if vim.tbl_contains({ "n", "N" }, key) and last_motion_type ~= "ft" then
			last_motion_type = "search"
		end

		-- Track search motions
		if vim.tbl_contains({ "/", "?", "*", "#" }, key) then
			last_motion_type = "search"
		end
	end

	local searchStarted = (key == "/" or key == "?") and isNormalMode
	local searchConfirmed = (key == "<CR>" and isCmdlineSearch)
	local searchCancelled = (key == "<Esc>" and isCmdlineSearch)
	local searchMovement = vim.tbl_contains({ "*", "#" }, key)
		or (vim.tbl_contains({ "n", "N" }, key) and last_motion_type == "search")

	local searchRestarted = not user_is_searching and searchMovement and isNormalMode

	if searchCancelled then
		stop_searching()
		return
	end

	if isCmdlineMode or key == ":" then
		return
	end

	if searchStarted or searchRestarted then
		user_is_searching = true
		vim.opt_local.foldenable = false -- Pause folding
		vim.defer_fn(searchCountIndicator, 1)
		return
	end

	if user_is_searching then
		-- User either confirmed or is browsing the search results
		if searchConfirmed or searchMovement then
			vim.defer_fn(searchCountIndicator, 1)
			return
		end

		stop_searching()
		if vim.fn.foldclosed(vim.fn.line(".")) ~= -1 then
			vim.cmd("normal! zO") -- Open fold at the cursor position
		end
	end
end, ns)
