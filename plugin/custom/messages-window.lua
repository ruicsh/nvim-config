-- List messages in a separate window
-- https://github.com/deathbeam/dotfiles/blob/master/vim/.vimrc#L178C1-L179C1

vim.keymap.set("n", "<leader>nm", function()
	vim.cmd("botright new +set\\ buftype=nofile\\ bufhidden=wipe\\ wrap")
	vim.api.nvim_win_set_height(0, math.floor(vim.o.lines * 0.2)) -- Set height to 30% of screen
	vim.cmd("put =execute('messages')")
end, { desc = "Messages", unique = true })
