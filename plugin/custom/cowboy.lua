-- Restricts repeating cursor movements
-- https://github.com/folke/dot/blob/master/nvim/lua/util/init.lua

local restricted_keys = { "h", "j", "k", "l", "<left>", "<down>", "<up>", "<right>" } -- keys under restrictions
local max_count = 5 -- max successive key presses
local reset_ms = 2000 -- time to reset count
local ignore_ft = { "help", "fugitive", "qf" } -- don't limit on these filetypes

local ok = true

for _, key in ipairs(restricted_keys) do
	local count = 0
	local timer = assert(vim.uv.new_timer())
	local map = key

	vim.keymap.set("n", key, function()
		if vim.v.count > 0 then
			count = 0
		end

		if count >= max_count and vim.bo.buftype ~= "nofile" and not vim.tbl_contains(ignore_ft, vim.bo.filetype) then
			ok = pcall(vim.notify, "Hold it Cowboy!", vim.log.levels.WARN, {
				id = "cowboy",
				keep = function()
					return count >= max_count
				end,
			})
			if not ok then
				return map
			end
		else
			count = count + 1
			timer:start(reset_ms, 0, function()
				count = 0
			end)
			return map
		end
	end, { expr = true, silent = true })
end
