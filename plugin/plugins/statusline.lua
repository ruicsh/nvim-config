-- Tabline

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

	return string.format("%%#StatusLineMode%s#  %s", hl, mode)
end

-- Show the current git branch
local function c_git_branch()
	local head = vim.b.gitsigns_head
	if not head or head == "" then
		return ""
	end

	local hl = "%#StatusLineB#"
	return string.format("%s   %s", hl, head)
end

-- Show only the last two segments of a path
local function only_last_two_segments(path)
	local sep = "/"
	local segments = vim.split(path, sep)
	if #segments == 0 then
		return path
	elseif #segments == 1 then
		return segments[#segments]
	else
		return table.concat({ segments[#segments - 1], segments[#segments] }, sep)
	end
end

-- Show the current filename
local function c_filename()
	local hl = "%#StatusLineC#"
	local line = hl

	if vim.bo.buftype == "terminal" then
		line = line .. " %t"
	else
		line = line .. "  " .. only_last_two_segments(vim.fn.expand("%:p:~"))
	end

	return line
end

-- Show the git status
local function c_git_status()
	local status = vim.b.gitsigns_status
	if not status or status == "" then
		return ""
	end

	-- extract the counts from status (ex +115 ~21 -14)
	local added, changed, removed
	for a, c, r in status:gmatch("([+-]?%d+)%s?~?(%d*)%s?[-]?(%d*)") do
		-- If the number is missing, it will be an empty string, so we default to nil
		added = (a ~= "" and tonumber(a)) or nil
		changed = (c ~= "" and tonumber(c)) or nil
		removed = (r ~= "" and tonumber(r)) or nil
	end

	local line = ""
	if added then
		line = line .. "%#StatusLineGitStatusAdded#  " .. added
	end
	if changed then
		line = line .. "%#StatusLineGitStatusChanged#  " .. changed
	end
	if removed then
		line = line .. "%#StatusLineGitStatusRemoved#  " .. removed
	end

	-- remove the first character
	return line:sub(1)
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

	local hl = "%#StatusLineSearchCount#"
	if s_count.incomplete == 1 then
		return hl .. "?/?"
	end

	local too_many = ">" .. s_count.maxcount
	local current = s_count.current > s_count.maxcount and too_many or s_count.current
	local total = s_count.total > s_count.maxcount and too_many or s_count.total

	return hl .. current .. " of " .. total .. " matches"
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
		return #component > 0 and string.format("%s %s ", acc, component) or acc
	end)
end

-- Construct the statusline
function StatusLine()
	local line = ""

	line = concat_components({
		c_mode(),
		c_git_branch(),
		c_filename(),
		c_git_status(),
		c_search_count(),
		"%#StatusLine#%=",
		c_tabs(),
	})

	return line
end

vim.opt.statusline = "%!v:lua.StatusLine()"
