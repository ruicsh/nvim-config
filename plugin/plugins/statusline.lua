-- Tabline

local icons = require("config/icons")

local function sep()
	return "%#StatusLineSeparator#|"
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
		mode = "QUICKFIX"
	elseif ft == "oil" then
		mode = "DIRECTORY"
	elseif ft == "vim" then
		mode = "VIM"
	elseif ft == "fugitive" or ft == "gitcommit" or ft:match("Diffview") or vim.wo.diff then
		mode = "GIT"
	end

	-- return string.format("%%#StatusLineMode%s#  %%#StatusLineModeText# %s", hl, mode)
	return string.format("%%#StatusLineMode%s# %%#StatusLineMode%sText# %s", hl, hl, mode)
end

-- Show only the last two segments of a path
local function only_last_two_segments(path)
	local path_separator = "/"
	local segments = vim.split(path, path_separator)
	if #segments == 0 then
		return path
	elseif #segments == 1 then
		return segments[#segments]
	else
		return table.concat({ segments[#segments - 1], segments[#segments] }, path_separator)
	end
end

-- Show the current filename
local function c_filename()
	local hl = "%#StatusLineFilename#"
	local line = hl .. " "
	local ft = vim.bo.filetype
	local bt = vim.bo.buftype

	if bt == "terminal" then
		line = line .. "term://%t"
	elseif ft == "fugitive" then
		line = line .. "STATUS"
	elseif ft == "gitcommit" then
		line = line .. "COMMIT"
	elseif ft == "DiffviewFiles" then
		line = line .. "DIFF"
	elseif ft == "DiffviewFileHistory" then
		line = line .. "LOG"
	elseif bt == "nofile" then
		return ""
	else
		local cwd = vim.fn.getcwd()
		local path = vim.fn.expand("%:p:~")

		if ft == "oil" then
			-- show full path
			line = line .. path:sub(#cwd + 3)
		else
			local icon = "󰈚 "
			local name = (path == "" and "Empty ") or path:match("([^/\\]+)[/\\]*$")
			local devicons_present, devicons = pcall(require, "nvim-web-devicons")
			if devicons_present then
				local ft_icon = devicons.get_icon(name)
				icon = (ft_icon ~= nil and ft_icon) or icon
			end
			-- show parent/filename
			line = line .. icon .. " " .. only_last_two_segments(path)
		end
	end

	return line
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

	local hl = "%#StatusLineSearchCount#"
	if s_count.incomplete == 1 then
		line = line .. hl .. "   ?/?"
		return line
	end

	local too_many = ">" .. s_count.maxcount
	local current = s_count.current > s_count.maxcount and too_many or s_count.current
	local total = s_count.total > s_count.maxcount and too_many or s_count.total

	return line .. hl .. "  " .. current .. " of " .. total .. " matches"
end

-- Show diagnostics
local function c_lsp_diagnostics()
	local line = ""
	if not rawget(vim, "lsp") then
		return line
	end

	local keys = { "error", "warning", "information", "hint" }
	for i, k in ipairs(keys) do
		local ki = vim.diagnostic.severity[i]
		local severity = vim.diagnostic.severity[ki]
		local count = vim.diagnostic.count(0, { severity = severity })[severity]
		if count and count > 0 then
			local hl = "%#StatusLineDiagnostics" .. k:sub(1, 1):upper() .. k:sub(2) .. "#"
			line = line .. hl .. " " .. icons.diagnostics[k] .. count
		end
	end

	return line
end

-- Show LSP status
local function c_lsp_status()
	if not rawget(vim, "lsp") then
		return ""
	end

	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	for _, client in ipairs(clients) do
		if client.name ~= "copilot" and client.name ~= "eslint" then
			return " LSP"
		end
	end
	return ""
end

-- Show git status
local function c_git_status()
	local line = ""
	local status = vim.b.gitsigns_status_dict
	if not status or status == "" then
		return line
	end

	local n_changes = 0
	local keys = { "added", "changed", "removed" }
	for _, k in ipairs(keys) do
		n_changes = n_changes + (status[k] or 0)
	end

	-- don't show anything if there are no changes
	if n_changes == 0 then
		return ""
	end

	local hl = "%#StatusLine#"
	return sep() .. " " .. hl .. vim.b.gitsigns_status
end

-- Show the current git branch
local function c_git_branch()
	local head = vim.b.gitsigns_head
	if not head or head == "" then
		return ""
	end

	local hl = "%#StatusLineGitBranch#"
	return sep() .. " " .. string.format("%s %s", hl, head)
end

-- Show the current position
local function c_cursor_position()
	local ft = vim.bo.filetype
	if ft == "" or ft == "fugitive" then
		return ""
	end

	local hl = "%#StatusLine#"
	local pos = vim.api.nvim_win_get_cursor(0)
	local total_lines = vim.fn.line("$")
	local text = math.modf((pos[1] / total_lines) * 100) .. tostring("%%")
	return sep() .. " " .. hl .. " " .. pos[1] .. ":" .. pos[2] .. " " .. text .. " "
end

-- Show tabs (only if there are more than one)
local function c_tabs()
	local line = ""
	local n_tabs = vim.fn.tabpagenr("$")

	-- only show tabs if there are more than one
	if n_tabs == 1 then
		return ""
	end

	for i = 1, n_tabs, 1 do
		local isSelected = vim.fn.tabpagenr() == i
		local hl = (isSelected and "%#TabLineSel#" or "%#TabLine#")
		local icon = (isSelected and "" or "")

		local cell = hl .. "  " .. icon .. " " .. i .. "  "
		line = line .. cell
	end

	return line
end

local function concat_components(components)
	return vim.iter(components):skip(1):fold(components[1], function(acc, component)
		return #component > 0 and string.format("%s %s", acc, component) or acc
	end)
end

-- Construct the statusline
function StatusLine()
	local line = "%#StatusLine#"

	line = concat_components({
		c_mode(),
		c_filename(),
		c_search_count(),
		"%=",
		c_lsp_diagnostics(),
		c_lsp_status(),
		c_git_status(),
		c_git_branch(),
		c_cursor_position(),
		c_tabs(),
	})

	return line
end

vim.opt.statusline = "%!v:lua.StatusLine()"
