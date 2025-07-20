local augroup = vim.api.nvim_create_augroup("ruicsh/filetype/rust", { clear = true })

-- Setup DAP
-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#ccrust-via-codelldb
local function setup_dap()
	local dap = package.loaded.dap

	dap.adapters.codelldb = {
		type = "server",
		port = "${port}",
		executable = {
			command = "codelldb",
			args = { "--port", "${port}" },
			detached = vim.fn.is_windows() and false or true,
		},
	}

	dap.configurations.rust = {
		{
			cwd = "${workspaceFolder}",
			name = "Launch file",
			program = function()
				-- Find the nearest Cargo.toml relative to the current buffer
				local current_file = vim.fn.expand("%:p")
				local current_dir = vim.fn.fnamemodify(current_file, ":h")
				local cargo_toml = ""

				-- Traverse up until we find a Cargo.toml
				local dir = current_dir
				while dir ~= "/" do
					local potential_cargo = dir .. "/Cargo.toml"
					if vim.fn.filereadable(potential_cargo) == 1 then
						cargo_toml = potential_cargo
						break
					end
					dir = vim.fn.fnamemodify(dir, ":h")
				end

				if cargo_toml == "" then
					return vim.fn.input("Path to release executable: ", vim.fn.getcwd() .. "/debug/", "file")
				end

				vim.fn.jobstart("cargo build")

				-- Run cargo metadata with the discovered manifest
				local manifest_path = "--manifest-path=" .. cargo_toml
				local metadata_command = "cargo metadata --format-version=1 --no-deps " .. manifest_path
				local metadata = vim.fn.system(metadata_command)
				local ok, decoded = pcall(vim.fn.json_decode, metadata)

				if ok and decoded and decoded.target_directory then
					local target_dir = decoded.target_directory
					local package = decoded.packages[1]
					local package_name = package.targets[1].name
					local executable = target_dir .. "/debug/" .. package_name

					if vim.fn.filereadable(executable) == 1 then
						return executable
					else
						return vim.fn.input("Path to debug executable: ", target_dir .. "/debug/", "file")
					end
				end

				return vim.fn.input("Path to debug executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			request = "launch",
			stopOnEntry = false,
			type = "codelldb",
		},
	}
end

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "rust",
	callback = function()
		setup_dap()
	end,
})
