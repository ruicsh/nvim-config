local augroup = vim.api.nvim_create_augroup("ruicsh/ft/python", { clear = true })

-- Find virtual environment in current project
local function find_venv()
	local cwd = vim.fn.getcwd()
	local buf_dir = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":h")
	local check_dirs = { buf_dir }

	-- Add parent directories of the buffer directory
	local current_dir = buf_dir
	while current_dir ~= "/" and current_dir ~= cwd do
		current_dir = vim.fn.fnamemodify(current_dir, ":h")
		table.insert(check_dirs, current_dir)
	end

	-- Add cwd if it's not already in the list
	if not vim.tbl_contains(check_dirs, cwd) then
		table.insert(check_dirs, cwd)
	end

	-- Function to check for venv in a directory
	local function check_venv_in_dir(dir)
		local possible_venvs = {
			dir .. "/venv",
			dir .. "/.venv",
			dir .. "/env",
			dir .. "/.env",
			dir .. "/.virtualenv",
		}

		for _, venv in ipairs(possible_venvs) do
			-- Check for bin/activate (Unix) or Scripts/activate.bat (Windows)
			local is_windows = vim.fn.has("win32") == 1
			local activation_script = is_windows and "Scripts/activate.bat" or "bin/activate"
			local venv_path = venv .. "/" .. activation_script

			if vim.fn.filereadable(venv_path) == 1 then
				return venv
			end
		end

		-- Check for poetry virtual environment
		local poetry_toml = dir .. "/pyproject.toml"
		if vim.fn.filereadable(poetry_toml) == 1 then
			local poetry_cmd_output = vim.fn.system("poetry env info -p")
			if vim.v.shell_error == 0 and poetry_cmd_output ~= "" then
				local poetry_venv = vim.fn.trim(poetry_cmd_output)
				-- Verify the path actually exists before returning it
				if vim.fn.isdirectory(poetry_venv) == 1 then
					return poetry_venv
				end
			end
		end

		return nil
	end

	-- Check each directory in the list
	for _, dir in ipairs(check_dirs) do
		local venv = check_venv_in_dir(dir)
		if venv then
			return venv
		end
	end

	return nil
end

-- Setup LSP for Python
local function setup_lsp(venv, python_path)
	local lspconfig = require("lspconfig")
	-- https://github.com/microsoft/pyright/blob/main/docs/configuration.md#environment-options
	lspconfig.pyright.setup({
		settings = {
			python = {
				pythonPath = python_path,
				venvPath = vim.fn.fnamemodify(venv, ":h"),
				venv = vim.fn.fnamemodify(venv, ":t"),
			},
		},
	})
end

-- Setup DAP for Python
-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#python
local function setup_dap(python_path)
	local dap = require("dap")

	dap.adapters.python = function(cb, config)
		cb({
			type = "executable",
			command = python_path,
			args = { "-m", "debugpy.adapter" },
			options = {
				source_filetype = "python",
			},
		})
	end

	dap.configurations.python = {
		{
			type = "python",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			console = "integratedTerminal",
			justMyCode = false,
			cwd = "${workspaceFolder}",
		},
		{
			type = "python",
			request = "launch",
			name = "Run pytest current file",
			module = "pytest",
			args = { "${file}", "-v" },
			console = "integratedTerminal",
			cwd = "${workspaceFolder}",
		},
	}
end

-- Activate virtual environment and configure LSP/DAP
local function auto_activate_venv()
	local venv = find_venv()
	if not venv then
		vim.fn.notify("No virtual environment found.")
		return
	end

	-- Determine Python path in the virtual environment
	local is_windows = vim.fn.has("win32") == 1
	local python_path = is_windows and venv .. "/Scripts/python.exe" or venv .. "/bin/python"

	-- Update Neovim Python provider
	vim.g.python3_host_prog = python_path

	setup_lsp(venv, python_path)

	setup_dap(python_path)

	vim.fn.notify("Activated venv: " .. venv)
end

vim.g.venv_configured = false

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "python",
	callback = function()
		-- Only run once per session
		if vim.g.venv_configured then
			return
		end

		vim.g.venv_configured = true
		auto_activate_venv()
	end,
})
