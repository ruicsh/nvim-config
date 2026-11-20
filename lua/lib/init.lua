local env = require("lib/env")
local fff = require("lib/fff")
local file_refs = require("lib/file_refs")
local fn = require("lib/fn")
local git = require("lib/git")
local tailwindcss = require("lib/tailwindcss")
local ui = require("lib/ui")

local M = {
	env = env,
	fff = fff,
	file_refs = file_refs,
	fn = fn,
	git = git,
	tailwindcss = tailwindcss,
	ui = ui,
}

return M
