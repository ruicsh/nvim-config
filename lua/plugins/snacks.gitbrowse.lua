-- Open files and commits in git hosting portals.
-- https://github.com/folke/snacks.nvim/blob/main/docs/gitbrowse.md

local T = require("lib")

local function open_gitbrowse_url(url)
	-- On Windows, vim.ui.open goes through `cmd.exe /c start`, which splits the
	-- Azure DevOps query string on `&`. Call the URL handler directly instead.
	-- Other platforms keep vim.ui.open's default behavior.
	local opts = T.fn.is_windows() and { cmd = { "rundll32.exe", "url.dll,FileProtocolHandler" } } or nil
	local _, err = vim.ui.open(url, opts)
	if err then
		vim.notify(err, vim.log.levels.ERROR)
	end
end

-- Percent-encode a repo path while keeping `/` separators intact.
local function encode_path(path)
	local segments = {}
	for segment in path:gmatch("[^/]+") do
		segments[#segments + 1] = T.fn.urlencode(segment)
	end
	return table.concat(segments, "/")
end

local function azure_file_url(fields, version)
	local line_end = fields.line_end or fields.line_start or 1
	local line = vim.api.nvim_buf_get_lines(0, line_end - 1, line_end, false)[1] or ""
	local line_end_column = math.max(vim.str_utfindex(line, "utf-16"), 1)

	return ("?path=/%s&version=%s&line=%s&lineEnd=%s&lineStartColumn=1&lineEndColumn=%d&lineStyle=plain&_a=contents"):format(
		encode_path(fields.file or ""),
		version,
		fields.line_start,
		line_end,
		line_end_column
	)
end

local azure_url_patterns = {
	branch = "?version=GB{branch}",
	file = function(fields)
		return azure_file_url(fields, "GB" .. fields.branch)
	end,
	permalink = function(fields)
		return azure_file_url(fields, "GC" .. fields.commit)
	end,
	commit = "/commit/{commit}",
}

local url_patterns = {
	["dev%.azure%.com"] = azure_url_patterns,
	["%.visualstudio%.com"] = azure_url_patterns, -- legacy Azure DevOps host
}

local azure_host = T.env.get("SNACKS_GITBROWSE_AZURE_DEVOPS_HOST")
if azure_host then
	azure_host = azure_host:gsub("^https?://", ""):gsub("/+$", "")
	if azure_host ~= "" then
		local host_pattern = azure_host:gsub("([^%w])", "%%%1")
		url_patterns["^https?://" .. host_pattern .. "/"] = azure_url_patterns
	end
end

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
	opts = {
		gitbrowse = {
			notify = false,
			open = open_gitbrowse_url,
			url_patterns = url_patterns,
		},
	},
	keys = {
		{ "<leader>hx", gitbrowse({ what = "file" }), desc = "Git: Open in browser", mode = { "n", "x" } },
		{ "<leader>hX", open_commit, desc = "Git: Open commit in browser", mode = { "n", "x" } },
	},
}
