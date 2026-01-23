-- Grapple's menu

local k = vim.keymap.set
local opts = { buffer = 0 }

-- Move bookmarks up/down on the list
k("n", "<a-k>", "<cmd>move .-2<cr>==", opts)
k("n", "<a-j>", "<cmd>move .+1<cr>==", opts)

-- The order may have been changed when leaving the menu, we need to reset and reassign
vim.api.nvim_create_autocmd("WinClosed", {
	group = vim.api.nvim_create_augroup("ruicsh/filetypes/grapple", { clear = true }),
	callback = function()
		local ft = vim.bo.filetype
		if ft ~= "grapple" then
			return
		end

		local grapple = require("grapple")
		local tags = grapple.tags()
		grapple.reset()
		local names = { "a", "s", "d", "f", "g", "h", "j", "k", "l" }
		for index, tag in ipairs(tags) do
			grapple.tag({ index = index, name = names[index], path = tag.path })
		end
	end,
})
