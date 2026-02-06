vim.opt_local.conceallevel = 1 -- Conceal Tailwind CSS classes

-- Toggle Tailwind class conceal
vim.keymap.set("n", "<leader>tt", function()
	local cl = vim.api.nvim_get_option_value("conceallevel", { scope = "local" })
	vim.opt_local.conceallevel = cl == 1 and 0 or 1
end, { buffer = true, desc = "Toggle Tailwind class conceal" })
