-- Reverse a list
vim.tbl_reverse = function(tbl)
	local reversed = {}
	for i = #tbl, 1, -1 do
		table.insert(reversed, tbl[i])
	end
	return reversed
end
