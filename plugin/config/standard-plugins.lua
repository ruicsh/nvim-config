-- Disable unused built-in plugins
local disabled_plugins = {
	"2html_plugin",
	"getscript",
	"getscriptPlugin",
	"gzip",
	"netrw",
	"netrwPlugin",
	"rrhelper",
	"tar",
	"tarPlugin",
	"tutor_mode_plugin",
	"vimball",
	"vimballPlugin",
	"zip",
	"zipPlugin",
}
for _, plugin in pairs(disabled_plugins) do
	vim.g["loaded_" .. plugin] = 1
end

-- Disable unused remote plugin providers
local disable_providers = {
	"node",
	"perl",
	"python",
	"python3",
	"ruby",
}
for _, provider in pairs(disable_providers) do
	vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- matchparen `:h matchparen`
vim.g.matchparen_disable_cursor_hl = 1
