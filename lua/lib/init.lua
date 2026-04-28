local env = require("lib/env")
local fn = require("lib/fn")
local git = require("lib/git")
local spinner = require("lib/spinner")
local tailwindcss = require("lib/tailwindcss")
local ui = require("lib/ui")

local M = {
	env = env,
	fn = fn,
	git = git,
	spinner = spinner,
	tailwindcss = tailwindcss,
	ui = ui,
}

return M
