-- Custom fold text.

local group = vim.api.nvim_create_augroup("ruicsh/custom_fold_text", { clear = true })

function _G.custom_fold_text()
	local line = vim.fn.getline(vim.v.foldstart)
	local line_count = vim.v.foldend - vim.v.foldstart + 1
	line = line:gsub("\t", string.rep(" ", vim.bo.tabstop))
	return line .. ": " .. line_count .. " lines "
end

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	callback = function()
		if custom_fold_text then
			vim.o.foldtext = "v:lua.custom_fold_text()"
		end
	end,
})
