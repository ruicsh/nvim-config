-- Open a scratch buffer with the command `:Scratch`.
vim.api.nvim_create_user_command("Scratch", function()
	vim.cmd("vertical 60vsplit")
	local buf = vim.api.nvim_get_current_buf()
	for name, value in pairs({
		filetype = "scratch",
		buftype = "nofile",
		bufhidden = "wipe",
		swapfile = false,
		modifiable = true,
	}) do
		vim.api.nvim_set_option_value(name, value, { buf = buf })
	end
end, {})
