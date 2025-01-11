-- Tabline

local function cell(index)
	local isSelected = vim.fn.tabpagenr() == index
	local hl = (isSelected and "%#TabLineSel#" or "%#TabLine#")
	local icon = (isSelected and "" or "")

	return hl .. "  " .. icon .. " " .. index .. "  "
end

function TabLine()
	local line = ""
	local n_tabs = vim.fn.tabpagenr("$")

	for i = 1, n_tabs, 1 do
		line = line .. cell(i)
	end

	-- Right aligned
	line = "%#TabLineFill#%=" .. line

	return line
end

vim.opt.tabline = "%!v:lua.TabLine()"
