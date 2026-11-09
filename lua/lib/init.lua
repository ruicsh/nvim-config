local env = require("lib/env")
local fff = require("lib/fff")
local fn = require("lib/fn")
local git = require("lib/git")
local tailwindcss = require("lib/tailwindcss")
local ui = require("lib/ui")

local M = {
	env = env,
	fff = fff,
	fn = fn,
	git = git,
	tailwindcss = tailwindcss,
	ui = ui,
}

return M
