local augroup = vim.api.nvim_create_augroup("ruicsh/ft/python", { clear = true })

-- Find virtual environment in current project
local function find_venv()
	local cwd = vim.fn.getcwd()
	local possible_venvs = {
		cwd .. "/venv",
		cwd .. "/.venv",
		cwd .. "/env",
		cwd .. "/.env",
		cwd .. "/.virtualenv",
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

	-- Also check for poetry virtual environment
	local poetry_toml = cwd .. "/pyproject.toml"
	if vim.fn.filereadable(poetry_toml) == 1 then
		local poetry_venv = vim.fn.trim(vim.fn.system("poetry env info -p"))
		if vim.v.shell_error == 0 then
			return poetry_venv
		end
	end

	return nil
end

-- Setup LSP for Python
local function setup_lsp(venv, python_path)
	local lspconfig = require("lspconfig")
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
