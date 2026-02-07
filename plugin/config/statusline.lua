-- Statusline configuration

local T = require("lib")

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

local git_root = nil
local function c_project()
	git_root = git_root or vim.fs.root(0, ".git")
	if not git_root or git_root == "" then
		return ""
	end
	local project_name = vim.fn.fnamemodify(git_root, ":t")
	local hl = "%#StatusLineProject#"
	local line = hl .. " "

	if project_name == "" then
		return ""
	end

	line = line .. " " .. project_name

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
		line = line .. "GIT STATUS"
	elseif ft == "gitcommit" then
		line = line .. "GIT COMMIT"
	elseif ft == "codediff-explorer" then
		line = line .. "GIT DIFF"
	elseif ft == "gitrebase" then
		line = line .. "GIT REBASE"
	elseif ft == "" or ft == "copilot-chat" or ft == "messages" then
		return ""
	else
		local path = vim.fn.expand("%:p:~")
		if ft == "oil" then
			line = line .. vim.fn.fnamemodify(path:sub(7), ":.")
		else
			local devicons = require("nvim-web-devicons")
			local fullpath = vim.api.nvim_buf_get_name(0)
			local filename = vim.fn.fnamemodify(fullpath, ":t")
			local relpath = vim.fn.fnamemodify(fullpath, ":.:h")
			local icon, icon_color = devicons.get_icon(filename, nil, { default = true })

			-- Icon with color
			if icon and icon_color then
				local hl_group = "StatusLineFileIconDynamic"
				vim.api.nvim_set_hl(0, hl_group, { link = icon_color })
				line = line .. "%#" .. hl_group .. "#" .. icon .. " "
			end
			line = line .. "%#StatusLineFilename#" .. filename
			if relpath ~= "." then
				line = line .. " %#StatusLineFilePath#" .. relpath
			end
		end
	end

	return line .. " %#StatusLineFileChanged#%m"
end

-- Show bookmark (using 'grapple' plugin)
local function c_bookmark()
	local index = require("grapple").name_or_index()
	if not index then
		return ""
	end

	local hl = "%#StatusLineBookmark#"
	return sep() .. " " .. hl .. "󰛢 " .. index
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
			local icon = k:sub(1, 1):upper()
			table.insert(lines, icon .. count)
		end
	end

	if #lines == 0 then
		return ""
	end

	return "%#StatusLine# " .. table.concat(lines, " ") .. " " .. sep()
end

-- Show git status
local function c_git_status()
	if not vim.b.gitsigns_status or vim.b.gitsigns_status == "" then
		return ""
	end

	return "%#StatusLineGitStatus#" .. " " .. vim.b.gitsigns_status .. " " .. sep()
end

-- Show the current git branch
local function c_git_branch()
	local head = vim.b.gitsigns_head
	if not head or head == "" then
		return ""
	end

	if T.ui.is_narrow_screen() and #head > 15 then
		head = head:sub(1, 20) .. "..."
	end

	return "%#StatusLine#" .. " " .. head .. " " .. sep()
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
	local hl = "%#StatusLine#"

	local components = {
		hl,
		c_mode(),
		c_project(),
		c_filename(),
		c_bookmark(),
		c_copilot_chat(),
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
