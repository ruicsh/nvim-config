-- Open files and commits in git hosting portals.
-- https://github.com/folke/snacks.nvim/blob/main/docs/gitbrowse.md

local gitbrowse = function(opts)
	return function()
		require("snacks").gitbrowse(opts)
	end
end

-- Commit that last touched the line (or start of the selection) under the cursor.
-- Returns nil for uncommitted lines, untracked files and non-git buffers.
local line_commit = function()
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" or vim.bo.buftype ~= "" then
		return nil
	end

	local line = vim.fn.line(".")
	if vim.fn.mode():find("[vV]") then
		line = math.min(line, vim.fn.line("v"))
	end

	local out = vim.fn.systemlist({
		"git",
		"-C",
		vim.fn.fnamemodify(file, ":h"),
		"blame",
		"-L",
		("%d,%d"):format(line, line),
		"--porcelain",
		"--",
		file,
	})

	-- All-zero hash means the line is not committed yet
	local hash = vim.v.shell_error == 0 and out[1] and out[1]:match("^(%x%x%x%x%x%x%x+)")
	if not hash or hash:match("^0+$") then
		return nil
	end

	return hash
end

local open_commit = function()
	local commit = line_commit()
	require("snacks").gitbrowse(commit and { what = "commit", commit = commit } or { what = "file" })
end

return {
	"folke/snacks.nvim",
	keys = {
		{ "<leader>hx", gitbrowse({ what = "file" }), desc = "Git: Open in browser", mode = { "n", "x" } },
		{ "<leader>hX", open_commit, desc = "Git: Open commit in browser", mode = { "n", "x" } },
	},
}
