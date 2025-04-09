-- Simple yank ring
-- https://www.reddit.com/r/neovim/comments/1jv03t1/simple_yankring/

-- Shift numbered registers up (1 becomes 2, etc.)
local function yank_shift()
	for i = 9, 1, -1 do
		vim.fn.setreg(tostring(i), vim.fn.getreg(tostring(i - 1)))
	end
end

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		local event = vim.v.event
		if event.operator == "y" then
			yank_shift()
		end
	end,
})
