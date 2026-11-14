-- HTTP client for plain .http files
-- https://github.com/rest-nvim/rest.nvim

local T = require("lib")

local ENV_PATTERN = "%.env.*"

-- List environment files for `:Rest env select`: from the current .http file
-- upwards, then the cwd, so a `.env` next to the file wins over a project one.
local function find_env_files()
	return T.env.discover({
		pattern = ENV_PATTERN,
		-- `.env.example` / `.env.template` are committed templates, not usable envs.
		exclude = { "%.example$", "%.template$" },
	})
end

-- Collect the saved requests (`### Name` blocks) in the current buffer.
-- Returns the line of each block's first non-comment line, because that is
-- what `:Rest run` uses to find the request under the cursor.
local function request_blocks()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local blocks = {}
	for idx, line in ipairs(lines) do
		local name = line:match("^###%s*(.-)%s*$")
		if name then
			local lnum = idx + 1
			while lnum <= #lines and (lines[lnum]:match("^%s*$") or lines[lnum]:match("^%s*#")) do
				lnum = lnum + 1
			end
			blocks[#blocks + 1] = {
				name = name ~= "" and name or ("Request " .. (#blocks + 1)),
				lnum = math.min(lnum, #lines),
			}
		end
	end
	return blocks
end

-- Pick one of the requests in the current file and run it.
local function pick_request()
	local blocks = request_blocks()
	if #blocks == 0 then
		vim.notify("No `### Name` requests in this buffer", vim.log.levels.WARN)
		return
	end
	vim.ui.select(blocks, {
		prompt = "Run request",
		format_item = function(item)
			return item.name
		end,
	}, function(item)
		if not item then
			return
		end
		vim.api.nvim_win_set_cursor(0, { item.lnum, 0 })
		vim.cmd("Rest run")
	end)
end

return {
	"rest-nvim/rest.nvim",
	ft = "http",

	-- The rockspec depends on `tree-sitter-http`, whose LuaRock needs the
	-- tree-sitter CLI and a build backend that is not available to lazy's
	-- hererocks (upstream issue #559). nvim-treesitter already provides the
	-- parser, so skip the rockspec build and wire the remaining Lua deps in
	-- as regular plugins.
	build = false,
	dependencies = {
		"nvim-neotest/nvim-nio",
		"j-hui/fidget.nvim",
		-- rest.nvim needs the `http` tree-sitter parser; it is already in the
		-- nvim-treesitter language list.
		"nvim-treesitter/nvim-treesitter",
		{
			"manoelcampos/xml2lua",
			build = false,
			config = function(plugin)
				package.path = package.path .. ";" .. plugin.dir .. "/?.lua"
			end,
		},
		{
			"lunarmodules/lua-mimetypes",
			build = false,
			config = function(plugin)
				package.path = package.path .. ";" .. plugin.dir .. "/?.lua"
			end,
		},
	},
	init = function()
		vim.g.rest_nvim = {
			env = {
				enable = true,
				pattern = ENV_PATTERN,
				find = find_env_files,
			},
			request = {
				-- Always skip certificate verification (self-signed / internal endpoints).
				skip_ssl_verification = true,
				hooks = {
					encode_url = true,
					set_content_type = true,
				},
			},
			response = {
				hooks = {
					decode_url = true,
					format = true,
				},
			},
			ui = {
				winbar = true,
				keybinds = {
					prev = "H",
					next = "L",
				},
			},
			clients = {
				curl = {
					statistics = {
						{ id = "time_total", winbar = "tot", title = "Total time (s)" },
						{ id = "time_starttransfer", winbar = "ttfb", title = "TTFB (s)" },
						{ id = "size_download", winbar = "size", title = "Download size (B)" },
						{ id = "time_connect", title = "Connect time (s)" },
						{ id = "time_namelookup", title = "DNS lookup (s)" },
						{ id = "size_upload", title = "Upload size (B)" },
						{ id = "speed_download", title = "Download speed (B/s)" },
						{ id = "remote_ip", title = "Remote IP" },
						{ id = "http_version", title = "HTTP version" },
						{ id = "num_redirects", title = "Redirects" },
					},
				},
			},
		}
	end,
	keys = {
		{ "<leader>ar", "<cmd>Rest run<cr>", desc = "Rest: Run request" },
		{ "<leader>aR", "<cmd>Rest last<cr>", desc = "Rest: Re-run last request" },
		{ "<leader>aa", pick_request, desc = "Rest: Pick and run request" },
		{ "<leader>ao", "<cmd>Rest open<cr>", desc = "Rest: Open result pane" },
		{ "<leader>ae", "<cmd>Rest env select<cr>", desc = "Rest: Select environment" },
		{ "<leader>aE", "<cmd>Rest env show<cr>", desc = "Rest: Show environment" },
		{ "<leader>ac", "<cmd>Rest cookies<cr>", desc = "Rest: Edit cookies" },
		{ "<leader>al", "<cmd>Rest logs<cr>", desc = "Rest: Open logs" },
	},
}
