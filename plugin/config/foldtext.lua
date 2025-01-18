-- Custom fold text.

local group = vim.api.nvim_create_augroup("ruicsh/config/foldtext", { clear = true })

function _G.custom_fold_text()
	local line = vim.fn.getline(vim.v.foldstart)
	-- count line being folded
	local line_count = vim.v.foldend - vim.v.foldstart + 1
	-- perserve indentation (replace tabs with spaces)
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
