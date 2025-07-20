-- Install LSP servers and 3rd-party tools
-- https://github.com/williamboman/mason.nvim

local PACKAGES = {
	-- LSP
	"angular-language-server",
	"ansible-language-server",
	"css-lsp",
	"cssmodules-language-server",
	"css-variables-language-server",
	"dockerfile-language-server",
	"emmet-language-server",
	"harper-ls",
	"html-lsp",
	"json-lsp",
	"lua-language-server",
	"pyright",
	"typescript-language-server",
	"yaml-language-server",
	-- DAP
	"codelldb",
	"js-debug-adapter",
	-- Format
	"black",
	"flake8",
	"prettierd",
	"stylua",
	-- Lint
	"eslint-lsp",
	"pylint",
}

local function install(pack, version)
	local notifyOpts = { title = "Mason", icon = "", id = "mason.install" }

	local msg = version and ("[%s] updating to %s…"):format(pack.name, version)
		or ("[%s] installing…"):format(pack.name)
	vim.defer_fn(function()
		vim.notify(msg, nil, notifyOpts)
	end, 0)

	pack:once("install:success", function()
		local msg2 = ("[%s] %s"):format(pack.name, version and "updated." or "installed.")
		notifyOpts.icon = " "
		vim.defer_fn(function()
			vim.notify(msg2, nil, notifyOpts)
		end, 0)
	end)

	pack:once("install:failed", function()
		local error = "Failed to install [" .. pack.name .. "]"
		vim.defer_fn(function()
			vim.notify(error, vim.log.levels.ERROR, notifyOpts)
		end, 0)
	end)

	pack:install({ version = version })
end

local function syncPackages(ensurePacks)
	local masonReg = require("mason-registry")

	local function refreshCallback()
		-- Auto-install missing packages & auto-update installed ones
		vim.iter(ensurePacks):each(function(packName)
			-- Extract package name and pinned version if specified
			local name, pinnedVersion = packName:match("([^@]+)@?(.*)")
			if not masonReg.has_package(name) then
				return
			end
			local pack = masonReg.get_package(name)
			if pack:is_installed() then
				-- Only check for updates if no version was pinned
				if pinnedVersion == "" then
					local latest_version = pack:get_latest_version()
					-- Check if the latest version is different from the installed one
					if latest_version and latest_version ~= pack:get_installed_version() then
						local msg = ("[%s] updating to %s…"):format(pack.name, latest_version)
						vim.defer_fn(function()
							vim.notify(msg, nil, { title = "Mason", icon = "󰅗" })
						end, 0)
						-- Install the latest version
						pack:install({ version = latest_version })
					end
				end
			else
				-- Install with pinned version if specified
				install(pack, pinnedVersion ~= "" and pinnedVersion or nil)
			end
		end)

		-- Auto-clean unused packages
		local installedPackages = masonReg.get_installed_package_names()
		vim.iter(installedPackages):each(function(packName)
			-- Check if installed package is in our ensure list (without version suffix)
			local isEnsured = vim.iter(ensurePacks):any(function(ensurePack)
				local name = ensurePack:match("([^@]+)")
				return name == packName
			end)

			if not isEnsured then
				masonReg.get_package(packName):uninstall()
				local msg = ("[%s] uninstalled."):format(packName)
				vim.defer_fn(function()
					vim.notify(msg, nil, { title = "Mason", icon = "󰅗" })
				end, 0)
			end
		end)
	end

	masonReg.refresh(refreshCallback)
end

return {
	"williamboman/mason.nvim",
	init = function()
		-- Make mason packages available before loading it; allows to lazy-load mason.
		vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH
		-- Do not crowd home directory with NPM cache folder
		vim.env.npm_config_cache = vim.env.HOME .. "/.cache/npm"
	end,
	opts = {
		ui = {
			border = "single",
			height = 0.85,
			width = 0.8,
		},
	},
	config = function(_, opts)
		require("mason").setup(opts)

		-- Filter out disabled packages
		local disabled = vim.fn.env_get_list("MASON_DISABLED_PACKAGES")
		local packages = {}
		for _, package in ipairs(PACKAGES) do
			if not vim.tbl_contains(disabled, package) then
				table.insert(packages, package)
			end
		end

		vim.defer_fn(function()
			syncPackages(packages)
		end, 3000)
	end,

	event = { "VeryLazy" },
}
