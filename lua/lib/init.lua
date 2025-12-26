local env = require("lib/env")
local fn = require("lib/fn")
local git = require("lib/git")
local ui = require("lib/ui")

local M = {
	env = env,
	fn = fn,
	git = git,
	ui = ui,
}

return M
