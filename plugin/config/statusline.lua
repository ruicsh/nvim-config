-- Statusline configuration

local icons = require("config/icons")

local function sep()
	return "%#StatusLineSeparator#|%#StatusLine#"
end

-- Show the current mode
-- https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/statusline.lua
local function c_mode()
	local mode_to_str = {
		["n"] = "NORMAL",
		["no"] = "O-PENDING",
		["nov"] = "O-PENDING",
		["noV"] = "O-PENDING",
		["no\22"] = "O-PENDING",
		["niI"] = "NORMAL",
		["niR"] = "NORMAL",
		["niV"] = "NORMAL",
		["nt"] = "NORMAL",
		["ntT"] = "NORMAL",
		["v"] = "VISUAL",
		["vs"] = "VISUAL",
		["V"] = "V-LINE",
		["Vs"] = "V-LINE",
		["\22"] = "V-BLOCK",
		["\22s"] = "V-BLOCK",
		["s"] = "SELECT",
		["S"] = "S-LINE",
		["\19"] = "S-BLOCK",
		["i"] = "INSERT",
		["ic"] = "INSERT",
		["ix"] = "INSERT",
		["R"] = "REPLACE",
		["Rc"] = "REPLACE",
		["Rx"] = "REPLACE",
		["Rv"] = "V-REPLACE",
		["Rvc"] = "V-REPLACE",
		["Rvx"] = "V-REPLACE",
		["c"] = "COMMAND",
		["cv"] = "VIM EX",
		["ce"] = "EX",
		["r"] = "REPLACE",
		["rm"] = "MORE",
		["r?"] = "CONFIRM",
		["!"] = "SHELL",
		["t"] = "TERMINAL",
	}

	-- Get the respective string to display.
	local mode = mode_to_str[vim.api.nvim_get_mode().mode] or "UNKNOWN"

	-- Set the highlight group.
	local hl = "Other"
	if mode:find("NORMAL") then
		hl = "Normal"
	elseif mode:find("PENDING") then
		hl = "Pending"
	elseif mode:find("VISUAL") or mode:find("V-LINE") or mode:find("V-BLOCK") then
		hl = "Visual"
	elseif mode:find("INSERT") or mode:find("SELECT") or mode:find("S-LINE") or mode:find("S-BLOCK") then
		hl = "Insert"
	elseif mode:find("COMMAND") or mode:find("TERMINAL") or mode:find("EX") then
		hl = "Command"
	end

	-- Special modes for certain filetypes
	local bt = vim.bo.buftype
	local ft = vim.bo.filetype
	if bt == "help" then
		mode = "HELP"
	elseif bt == "quickfix" then
		mode = "QF"
	elseif ft == "oil" or ft == "neo-tree" then
		mode = "DIR"
	elseif ft == "vim" then
		mode = "VIM"
	elseif ft == "fugitive" or ft == "gitcommit" or ft:match("Diffview") or vim.wo.diff then
		mode = "GIT"
	end

	-- return string.format("%%#StatusLineMode%s#  %%#StatusLineModeText# %s", hl, mode)
	return string.format("%%#StatusLineMode%s# %%#StatusLineMode%sText# %s", hl, hl, mode)
end

-- Show the current filename
local function c_filename()
	local hl = "%#StatusLineFilename#"
	local line = hl .. " "
	local ft = vim.bo.filetype
	local bt = vim.bo.buftype

	if bt == "terminal" then
		return ""
	elseif ft == "fugitive" then
		line = line .. "STATUS"
	elseif ft == "gitcommit" then
		line = line .. "COMMIT"
	elseif ft == "DiffviewFiles" then
		line = line .. "DIFF"
	elseif ft == "DiffviewFileHistory" then
		line = line .. "LOG"
	elseif ft == "" or ft == "codecompanion" then
		return ""
	else
		local cwd = vim.fn.getcwd()
		local path = vim.fn.expand("%:p:~")

		if ft == "oil" or ft == "neo-tree" then
			-- show full path
			line = line .. " " .. path:sub(#cwd + 3)
		else
			-- show only parent/filename
			line = line .. " " .. vim.fs.getshortpath(path)
		end
	end

	return line .. " %m"
end

-- Show search count
-- https://github.com/echasnovski/mini.statusline/blob/main/lua/mini/statusline.lua
local function c_search_count()
	if vim.v.hlsearch == 0 then
		return ""
	end

	-- `searchcount()` can return errors because it is evaluated very often in
	-- statusline. For example, when typing `/` followed by `\(`, it gives E54.
	local ok, s_count = pcall(vim.fn.searchcount, { recompute = true })
	if not ok or s_count.current == nil or s_count.total == 0 then
		return ""
	end

	local line = sep() .. " "

	if s_count.incomplete == 1 then
		line = line .. " ?/?"
		return line
	end

	local too_many = ">" .. s_count.maxcount
	local current = s_count.current > s_count.maxcount and too_many or s_count.current
	local total = s_count.total > s_count.maxcount and too_many or s_count.total

	return line .. " " .. current .. " of " .. total .. " matches"
end

-- Show LSP diagnostics
local function c_lsp_diagnostics()
	if not rawget(vim, "lsp") then
		return ""
	end

	local lines = {}
	local keys = { "error", "warning", "information", "hint" }
	local total_count = 0
	for i, k in ipairs(keys) do
		local ki = vim.diagnostic.severity[i]
		local severity = vim.diagnostic.severity[ki]
		local count = vim.diagnostic.count(0, { severity = severity })[severity]
		if count and count > 0 then
			total_count = total_count + count
			table.insert(lines, icons.diagnostics[k] .. " " .. count)
		end
	end

	if total_count == 0 then
		return ""
	end

	return " " .. table.concat(lines, " ") .. " " .. sep()
end

-- Show git status
local function c_git_status()
	local status = vim.b.gitsigns_status_dict
	if not status or status == "" then
		return ""
	end

	local n_changes = 0
	local keys = { "added", "changed", "removed" }
	local entries = {}
	for _, k in ipairs(keys) do
		local count = (status[k] or 0)
		if count > 0 then
			table.insert(entries, icons.git[k] .. " " .. count)
		end
		n_changes = n_changes + count
	end

	-- don't show anything if there are no changes
	if n_changes == 0 then
		return ""
	end

	return " " .. table.concat(entries, " ") .. " " .. sep()
end

-- Show the current git branch
local function c_git_branch()
	local ft = vim.bo.filetype
	if ft == "fugitive" then
		return ""
	end

	local head = vim.b.gitsigns_head
	if not head or head == "" then
		return ""
	end

	return " " .. head .. " " .. sep()
end

-- Show the current position
local function c_cursor_position()
	local bt = vim.bo.buftype
	local ft = vim.bo.filetype

	if bt == "terminal" or ft == "" or ft == "fugitive" or ft == "gitcommit" then
		return ""
	end

	local has_tabs = vim.fn.tabpagenr("$") > 1

	return " %l:%c %p%% " .. (has_tabs and sep() or "")
end

-- Show tabs (only if there are more than one)
local function c_tabs()
	local n_tabs = vim.fn.tabpagenr("$")

	-- only show tabs if there are more than one
	if n_tabs == 1 then
		return ""
	end

	local tabs = {}
	for i = 1, n_tabs, 1 do
		local isSelected = vim.fn.tabpagenr() == i
		local hl = (isSelected and "%#TabLineSel#" or "%#TabLine#")
		local icon = isSelected and "" or ""
		local cell = hl .. icon .. " "
		table.insert(tabs, cell)
	end

	return table.concat(tabs, "")
end

-- Show quickfix status
local c_quickfix = function()
	local title = vim.fn.getqflist({ title = 1 }).title
	return "%#StatusLine#" .. title .. " [%l/%L] %p%%"
end

-- Show LSP progress
_G.lsp_progress = {}
local c_lsp_progress = function()
	local status = {}
	for client_id, client_progress in pairs(_G.lsp_progress) do
		for _, progress in pairs(client_progress) do
			local client_name = vim.lsp.get_client_by_id(client_id).name
			local parts = { client_name }

			if progress.title and progress.title ~= "" then
				table.insert(parts, progress.title)
			end
			if progress.message and progress.message ~= "" then
				table.insert(parts, progress.message)
			end

			table.insert(status, table.concat(parts, " - "))
		end
	end

	return status and table.concat(status, " ") or ""
end

_G.codecompanion = { is_processing = false, spinner_frame = 1 }
local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

local function update_spinner()
	_G.codecompanion.spinner_frame = (_G.codecompanion.spinner_frame % #spinner_frames) + 1
end

local function c_codecompanion()
	local ft = vim.bo.filetype
	if ft ~= "codecompanion" then
		return ""
	end

	local cc = require("codecompanion")
	local bufnr = vim.api.nvim_get_current_buf()
	local chat = cc.buf_get_chat(bufnr)
	if not chat then
		return ""
	end

	local adapter = chat.adapter.formatted_name
	local model = chat.settings.model

	local status = { "㋶", adapter, "%#StatusLine#", model }
	if _G.codecompanion.is_processing then
		table.insert(status, spinner_frames[_G.codecompanion.spinner_frame])
		update_spinner()
	end

	return table.concat(status, " ")
end

-- Optionally, you can set up a timer to update the spinner frame periodically
vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		if _G.codecompanion.is_processing then
			update_spinner()
			vim.cmd("redrawstatus")
		end
	end,
})

-- Construct the statusline (default)
function _G.status_line()
	local hl = "%#StatusLine#"

	return table.concat({
		hl,
		c_mode(),
		c_filename(),
		c_codecompanion(),
		c_search_count(),
		"%=",
		c_lsp_progress(),
		"%=",
		c_lsp_diagnostics(),
		c_git_status(),
		c_git_branch(),
		c_cursor_position(),
		c_tabs(),
	}, " ")
end

-- Used on quickfix window
function _G.status_line_qf()
	local hl = "%#StatusLine#"

	return table.concat({
		hl,
		c_mode(),
		c_quickfix(),
		"%=",
		c_lsp_diagnostics(),
		c_tabs(),
	}, " ")
end

vim.o.statusline = "%!v:lua._G.status_line()"
