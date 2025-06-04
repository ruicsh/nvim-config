-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/angularls.lua

local function get_probe_dir(root_dir)
	local project_root = vim.fs.dirname(vim.fs.find("node_modules", { path = root_dir, upward = true })[1])
	return project_root and (project_root .. "/node_modules") or ""
end

local function get_angular_core_version(root_dir)
	local project_root = vim.fs.dirname(vim.fs.find("node_modules", { path = root_dir, upward = true })[1])
	if not project_root then
		return ""
	end

	local package_json = project_root .. "/package.json"
	if not vim.fn.filereadable(package_json) then
		return ""
	end

	local contents = io.open(package_json):read("*a")
	local json = vim.json.decode(contents)
	if not json.dependencies then
		return ""
	end

	local angular_core_version = json.dependencies["@angular/core"]
	angular_core_version = angular_core_version and angular_core_version:match("%d+%.%d+%.%d+")

	return angular_core_version
end

local default_probe_dir = get_probe_dir(vim.fn.getcwd())
local default_angular_core_version = get_angular_core_version(vim.fn.getcwd())

local ROOT_MARKERS = {
	".git",
	"angular.json",
	"package.json",
}

return {
	cmd = {
		"ngserver",
		"--stdio",
		"--tsProbeLocations",
		default_probe_dir,
		"--ngProbeLocations",
		default_probe_dir,
		"--angularCoreVersion",
		default_angular_core_version,
	},
	filetypes = {
		"htmlangular",
		"typescript",
	},
	root_markers = ROOT_MARKERS,
	root_dir = function(bufnr, on_dir)
		local filename = vim.api.nvim_buf_get_name(bufnr)
		-- Only if Angular files trigger the LSP.
		if
			not filename:match("component%.html$")
			and not filename:match("component%.scss$")
			and not filename:match("component%.ts$")
			and not filename:match("directive%.ts$")
			and not filename:match("module%.ts$")
			and not filename:match("pipe%.ts$")
			and not filename:match("service%.ts$")
		then
			return nil
		end

		local root_dir = vim.fs.dirname(vim.fs.find(ROOT_MARKERS, { path = filename, upward = true })[1])
		if not root_dir then
			return nil
		end

		on_dir(root_dir)
	end,

	on_new_config = function(new_config, new_root_dir)
		local new_probe_dir = get_probe_dir(new_root_dir)
		local angular_core_version = get_angular_core_version(new_root_dir)

		-- We need to check our probe directories because they may have changed.
		new_config.cmd = {
			vim.fn.exepath("ngserver"),
			"--stdio",
			"--tsProbeLocations",
			new_probe_dir,
			"--ngProbeLocations",
			new_probe_dir,
			"--angularCoreVersion",
			angular_core_version,
		}
	end,
}
