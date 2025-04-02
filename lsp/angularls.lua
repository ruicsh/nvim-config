-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/angularls.lua

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
		"typescript",
		"htmlangular",
	},
	root_markers = {
		"angular.json",
		"package.json",
		".git",
	},
}
