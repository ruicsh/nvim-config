-- LSP configuration and management

vim.api.nvim_create_user_command("LspEnable", function()
	local disabled_servers = vim.fn.env_get_list("LSP_DISABLED_SERVERS")

	local lsp_configs = {}
	for _, f in pairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
		local server_name = vim.fn.fnamemodify(f, ":t:r")
		-- Skip if on the disabled list
		if not vim.tbl_contains(disabled_servers, server_name) then
			table.insert(lsp_configs, server_name)
		end
	end

	vim.lsp.enable(lsp_configs)
end, {})

-- https://www.reddit.com/r/neovim/comments/1kzdd5x/restartlsp_but_for_native_vimlsp/
vim.api.nvim_create_user_command("LspRestart", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	vim.lsp.stop_client(clients, true)

	local timer = vim.uv.new_timer()

	timer:start(500, 0, function()
		for _, _client in ipairs(clients) do
			vim.schedule_wrap(function(client)
				vim.lsp.enable(client.name)

				vim.cmd(":noautocmd write")
				vim.cmd(":edit")
			end)(_client)
		end
	end)
end, {})
