-- Statusline configuration

local T = require("lib")

local statusline_augroup = vim.api.nvim_create_augroup("ruicsh/config/statusline", { clear = true })

-- Hoist requires out of the hot render path
local devicons = require("nvim-web-devicons")

-- Cache for git root to avoid vim.fs.root() on every statusline redraw

local cached_git_root = vim.fs.root(0, ".git")
vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged" }, {
	group = statusline_augroup,
	callback = function()
		if vim.bo.buftype == "" then
			cached_git_root = vim.fs.root(0, ".git")
		end
	end,
})

-- Cache for repo-wide git info (updated asynchronously)
local repo_status_cache = ""
local remote_status_cache = ""
local git_info_timer = nil

local function refresh_git_info()
	if not cached_git_root then
		repo_status_cache = ""
		remote_status_cache = ""
		return
	end

	if git_info_timer then
		vim.uv.timer_stop(git_info_timer)
	end

	git_info_timer = vim.uv.new_timer()
	git_info_timer:start(200, 0, function()
		git_info_timer:close()
		git_info_timer = nil

		T.git.repo_status(function(repo)
			T.git.remote_status(function(remote)
				vim.schedule(function()
					repo_status_cache = repo
					remote_status_cache = remote
					vim.cmd("redrawstatus!")
				end)
			end, cached_git_root)
		end, cached_git_root)
	end)
end

vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged", "FocusGained", "CursorHold" }, {
	group = statusline_augroup,
	callback = function()
		vim.schedule(refresh_git_info)
	end,
})

vim.api.nvim_create_autocmd("VimEnter", {
	group = statusline_augroup,
	callback = function()
		refresh_git_info()
	end,
})

-- Pre-create icon highlight groups at startup so the hot render path never calls nvim_set_hl
vim.api.nvim_create_autocmd("VimEnter", {
	group = statusline_augroup,
	callback = function()
		local ok, icons = pcall(devicons.get_icons)
		if not ok or not icons then
			return
		end
		local seen = {}
		for _, icon_data in pairs(icons) do
			if icon_data.name and not seen[icon_data.name] then
				seen[icon_data.name] = true
				local src_hl = "DevIcon" .. icon_data.name
				local dst_hl = "StatusLineFileIcon_" .. icon_data.name
				-- Only create if the source highlight group exists (defensive)
				if vim.fn.hlexists(src_hl) == 1 then
					vim.api.nvim_set_hl(0, dst_hl, { link = src_hl })
				end
			end
		end
	end,
})

local function sep()
	return "%#StatusLineSeparator#|%#StatusLine#"
end

local function item_sep()
	return " %#StatusLineSeparator#│%#StatusLine#"
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

local function c_spinner()
	local spinner_val = _G.pin_spinner or ""
	local spinner_msg = _G.pin_spinner_msg or ""
	if spinner_val == "" and spinner_msg == "" then
		return ""
	end
	return "%#StatusLineSpinner# " .. spinner_val .. " " .. spinner_msg .. " " .. sep()
end

local function c_project()
	if not cached_git_root or cached_git_root == "" then
		return ""
	end
	local project_name = vim.fn.fnamemodify(cached_git_root, ":t")
	local hl = "%#StatusLineProject#"
	local line = hl .. " "

	if project_name == "" then
		return ""
	end

	line = line .. " " .. project_name

	return line
end

-- Show the current filename
local function c_filename(bufnr)
	bufnr = bufnr or 0
	local hl = "%#StatusLineFilename#"
	local line = sep() .. " " .. hl
	local ft = vim.bo[bufnr].filetype
	local bt = vim.bo[bufnr].buftype

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
	elseif ft == "" or ft == "messages" then
		return ""
	else
		local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":~")
		if ft == "oil" then
			line = line .. vim.fn.fnamemodify(path:sub(7), ":.")
		else
			local fullpath = vim.api.nvim_buf_get_name(bufnr)
			local filename = vim.fn.fnamemodify(fullpath, ":t")
			local relpath = vim.fn.fnamemodify(fullpath, ":.:h")
			local icon, icon_color = devicons.get_icon(filename, nil, { default = true })

			-- Icon with color (highlight group pre-created at VimEnter)
			if icon and icon_color then
				-- icon_color is already a highlight group name like "DevIconLua"
				-- Map to our namespaced group: "DevIconFoo" -> "StatusLineFileIcon_Foo"
				local hl_group = icon_color:gsub("^DevIcon", "StatusLineFileIcon_")
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
	local ok, grapple = pcall(require, "grapple")
	if not ok then
		return ""
	end
	local index = grapple.name_or_index()
	if not index then
		return ""
	end

	local hl = "%#StatusLineBookmark#"
	return sep() .. " " .. hl .. "󰛢 " .. index
end

-- Show the current git branch with diff and remote tracking status
local function c_git_branch(bufnr)
	local head = T.fn.get_buf_var("gitsigns_head", bufnr)
	if not head or head == "" then
		return ""
	end

	if T.ui.is_narrow_screen() and #head > 20 then
		head = head:sub(1, 20) .. "..."
	end

	local result = "%#StatusLine#"

	if repo_status_cache ~= "" then
		result = result .. " " .. repo_status_cache .. item_sep()
	end

	if remote_status_cache ~= "" then
		result = result .. " " .. remote_status_cache .. item_sep()
	end

	result = result .. "  " .. head .. " "
	return result
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
		local is_selected = vim.fn.tabpagenr() == i
		local hl = (is_selected and "%#TabLineSel#" or "%#TabLine#")
		local icon = is_selected and "" or ""
		local cell = hl .. icon .. " "
		table.insert(tabs, cell)
	end

	return table.concat(tabs, "")
end

-- Resolve the buffer to display in the statusline.
-- When the active window is a floating/non-editing window (e.g. Sidekick),
-- falls back to a visible non-floating window with a regular file buffer.
local function statusline_bufnr(winid)
	local bufnr = vim.api.nvim_win_get_buf(winid)
	local win_config = vim.api.nvim_win_get_config(winid)

	if win_config.relative == "" and vim.bo[bufnr].buftype == "" then
		return bufnr
	end

	for _, w in ipairs(vim.api.nvim_list_wins()) do
		if w ~= winid then
			local cfg = vim.api.nvim_win_get_config(w)
			if cfg.relative == "" then
				local b = vim.api.nvim_win_get_buf(w)
				if vim.bo[b].buftype == "" then
					return b
				end
			end
		end
	end

	return bufnr
end

-- Construct the statusline (default)
function _G.statusline()
	local winid = vim.g.statusline_winid or vim.api.nvim_get_current_win()
	local editing_bufnr = statusline_bufnr(winid)
	local actual_bufnr = vim.api.nvim_win_get_buf(winid)
	local hl = "%#StatusLine#"

	local components = {
		hl,
		c_mode(),
		c_spinner(),
		c_project(),
		c_filename(actual_bufnr),
		c_bookmark(),
		"%=",
		c_git_branch(editing_bufnr),
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
