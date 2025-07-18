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
	elseif ft == "oil" then
		mode = "DIR"
	elseif ft == "vim" then
		mode = "VIM"
	elseif ft == "fugitive" or ft == "gitcommit" or vim.wo.diff then
		mode = "GIT"
	elseif ft == "messages" then
		mode = "MESSAGES"
	end

	return string.format("%%#StatusLineMode%s# %%#StatusLineMode%sText# %s %%#StatusLine#", hl, hl, mode)
end

local function c_project()
	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
	local hl = "%#StatusLineProject#"
	local line = hl .. " "

	if project_name == "" then
		return ""
	end

	if vim.g.vscode then
		line = line .. project_name .. ": "
	else
		line = line .. " " .. project_name
	end

	return line
end

-- Show the current filename
local function c_filename()
	local hl = "%#StatusLineFilename#"
	local line = sep() .. " " .. hl
	local ft = vim.bo.filetype
	local bt = vim.bo.buftype

	if bt == "terminal" then
		return ""
	elseif ft == "fugitive" then
		line = line .. "STATUS"
	elseif ft == "gitcommit" then
		line = line .. "COMMIT"
	elseif ft == "" or ft == "copilot-chat" or ft == "messages" then
		return ""
	else
		local path = vim.fn.expand("%:p:~")
		if ft == "oil" then
			line = line .. vim.fn.fnamemodify(path:sub(7), ":.")
		else
			local parent = vim.fn.fnamemodify(path, ":h:t")
			local filename = vim.fn.fnamemodify(path, ":t")
			local display = parent == filename and filename or parent .. "/" .. filename
			line = line .. display
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
	for i, k in ipairs(keys) do
		local ki = vim.diagnostic.severity[i]
		local severity = vim.diagnostic.severity[ki]
		local count = vim.diagnostic.count(0, { severity = severity })[severity]
		if count and count > 0 then
			table.insert(lines, icons.diagnostics[k] .. count)
		end
	end

	if #lines == 0 then
		return ""
	end

	return "%#StatusLine# " .. table.concat(lines, " ") .. " " .. sep()
end

-- Show git status
local cache_git_status = {}
local function c_git_status()
	local bufnr = vim.api.nvim_get_current_buf()
	if cache_git_status[bufnr] and cache_git_status[bufnr].time > vim.loop.now() - 1000 then
		return cache_git_status[bufnr].value
	end

	local status = vim.b.minidiff_summary
	if not status or status == "" then
		return ""
	end

	local n_changes = 0
	local keys = { "add", "change", "delete" }
	local entries = {}
	for _, k in ipairs(keys) do
		local count = (status[k] or 0)
		if count > 0 then
			table.insert(entries, icons.git[k] .. count)
		end
		n_changes = n_changes + count
	end

	-- Don't show anything if there are no changes
	local git_status = n_changes == 0 and "" or icons.git.commit .. " " .. table.concat(entries, " ") .. " " .. sep()

	cache_git_status[bufnr] = { time = vim.loop.now(), value = git_status }

	return "%#StatusLine#" .. git_status
end

-- Show the current git branch
local function c_git_branch()
	local head = vim.g.git_branch_name
	if not head or head == "" then
		return ""
	end

	return icons.git.branch .. " " .. head .. " " .. sep()
end

-- Show the current position
local function c_cursor_position()
	local has_tabs = vim.fn.tabpagenr("$") > 1
	return "%#StatusLine#%4l %3p%% " .. (has_tabs and sep() or "")
end

-- Show tabs (only if there are more than one)
local function c_tabs()
	local n_tabs = vim.fn.tabpagenr("$")

	-- Only show tabs if there are more than one
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

-- Show Quickfix status
local c_quickfix = function()
	local title = vim.fn.getqflist({ title = 1 }).title
	return "%#StatusLine#" .. title .. " [%l/%L] %p%%"
end

-- Show AI Assistant model
local function c_copilot_chat()
	local ft = vim.bo.filetype
	if ft ~= "copilot-chat" then
		return ""
	end

	local async = require("plenary.async")
	local chat = require("CopilotChat")
	local config = chat.config
	local model = config.model

	async.run(function()
		local resolved_model = chat.resolve_model()
		if resolved_model then
			model = resolved_model
		end
	end, function(_, _)
		-- Nothing to do here since we're just updating a local variable
	end)

	local status = { sep(), "Copilot", sep(), model }
	return table.concat(status, " ")
end

-- Construct the statusline (default)
function _G.status_line()
	if vim.g.vscode then
		return table.concat({
			c_mode(),
		})
	end

	local hl = "%#StatusLine#"

	local components = {
		hl,
		c_mode(),
		c_project(),
		c_filename(),
		c_copilot_chat(),
		c_search_count(),
		"%=",
		"%=",
		c_lsp_diagnostics(),
		c_git_status(),
		c_git_branch(),
		c_cursor_position(),
		c_tabs(),
	}

	local filtered_components = {}
	for _, component in ipairs(components) do
		if component ~= "" then
			table.insert(filtered_components, component)
		end
	end

	return table.concat(filtered_components, " ")
end

-- Used on Quickfix window
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
