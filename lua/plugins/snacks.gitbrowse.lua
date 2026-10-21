-- Open files and commits in git hosting portals.
-- https://github.com/folke/snacks.nvim/blob/main/docs/gitbrowse.md

local T = require("lib")

local gitbrowse = function(opts)
	return function()
		require("snacks").gitbrowse(opts)
	end
end

-- Commit that last touched the line (or start of the selection) under the cursor.
-- Returns nil for uncommitted lines, untracked files and non-git buffers.
local line_commit = function()
	if vim.api.nvim_buf_get_name(0) == "" or vim.bo.buftype ~= "" then
		return nil
	end

	local line = vim.fn.line(".")
	local mode = vim.fn.mode()
	if mode == "v" or mode == "V" or mode == "\22" then
		-- Start of the selection (charwise, linewise or blockwise)
		line = math.min(line, vim.fn.line("v"))
	end

	return T.git.commit_at_line(line)
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
