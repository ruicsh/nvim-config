-- Caddyfile

local function get_sw()
	return vim.fn.shiftwidth()
end

_G.get_caddyfile_indent = function(lnum)
	local prevlnum = vim.fn.prevnonblank(lnum - 1)
	if prevlnum == 0 then
		return 0
	end

	local thisl = vim.fn.getline(lnum):gsub("#.*$", "")
	local prevl = vim.fn.getline(prevlnum):gsub("#.*$", "")

	local ind = vim.fn.indent(prevlnum)

	if prevl:match("{" .. "%s*$") then
		ind = ind + get_sw()
	end

	if thisl:match("^%s*}" .. "%s*$") then
		ind = ind - get_sw()
	end

	return ind
end

vim.bo.lisp = false
vim.bo.autoindent = true
vim.bo.indentexpr = "v:lua.get_caddyfile_indent(v:lnum)"
vim.bo.indentkeys = vim.bo.indentkeys .. ",<:>,0=},0=)"
