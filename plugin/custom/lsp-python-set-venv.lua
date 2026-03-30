local augroup = vim.api.nvim_create_augroup("ruicsh/custom/lsp-python-set-venv", { clear = true })

-- Cache: root_dir -> venv table
local venv_cache = {}

-- Current venv state
local current_venv = nil

-- Find .venv directory by searching up from buf's path
local function find_venv(bufnr)
	local bufname = vim.api.nvim_buf_get_name(bufnr)
	if bufname == "" then
		return nil
	end

	local buf_dir = vim.fs.dirname(bufname)
	local root = vim.fs.root(buf_dir, ".venv")

	if not root then
		return nil
	end

	if venv_cache[root] then
		return venv_cache[root]
	end

	local venv = {
		name = vim.fn.fnamemodify(root, ":t") .. "/.venv",
		path = root .. "/.venv",
		source = "venv",
	}

	venv_cache[root] = venv
	return venv
end

-- Set venv and notify pyright
local function set_venv(venv)
	if current_venv and current_venv.path == venv.path then
		return
	end

	vim.fn.setenv("VIRTUAL_ENV", venv.path)
	current_venv = venv

	local client = vim.lsp.get_clients({ name = "pyright" })[1]
	if not client then
		return
	end

	local venv_python = venv.path .. "/bin/python"
	if client.settings then
		client.settings = vim.tbl_deep_extend("force", client.settings, { python = { pythonPath = venv_python } })
	else
		client.config.settings =
			vim.tbl_deep_extend("force", client.config.settings, { python = { pythonPath = venv_python } })
	end

	client:notify("workspace/didChangeConfiguration", { settings = nil })
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.name == "pyright" then
			vim.schedule(function()
				local venv = find_venv(args.buf)
				if venv then
					set_venv(venv)
				end
			end)
		end
	end,
})
