local M = {}

M.default_branch = function()
	-- Use `git symbolic-ref` to directly get the default branch name
	local args = { "git", "symbolic-ref", "refs/remotes/origin/HEAD" }

	local result = vim.system(args):wait(5000)
	if not result or not result.stdout then
		return nil, "Could not find HEAD branch"
	end

	-- Remove trailing newline
	return result.stdout:gsub("%s+$", "")
end

M.diff = function(ref)
	-- To ignore files (ex. package-lock.json) add 'package-lock.json -diff' to .gitattributes
	local args = { "git", "diff", "--no-color", ref }

	local result = vim.system(args):wait(10000)
	if not result or not result.stdout then
		return nil, "Could not get git diff"
	end

	return result.stdout
end

M.blame_line = function()
	local linenr = vim.fn.line(".")
	local file = vim.fn.expand("%")
	local args = { "git", "blame", "-L", linenr .. ",+1", file }

	local result = vim.system(args):wait(5000)
	if not result or not result.stdout then
		return nil, "Could not get blame info"
	end

	return result.stdout
end

return M
