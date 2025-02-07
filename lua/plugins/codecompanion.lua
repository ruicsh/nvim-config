-- AI chat and inline assistant.
-- https://codecompanion.olimorris.dev/

local augroup = vim.api.nvim_create_augroup("ruicsh/plugins/codecompanion", { clear = true })

local function read_prompt_file(basename)
	local config_path = vim.fn.stdpath("config")
	local file_path = config_path .. "/prompts/" .. basename .. ".txt"
	return vim.fs.read_file(file_path)
end

vim.api.nvim_create_autocmd({ "User" }, {
	pattern = "CodeCompanion*",
	group = augroup,
	callback = function(request)
		if request.match == "CodeCompanionChatHidden" or request.match == "CodeCompanionChatClosed" then
			-- Restore the current window, that was maximized before opening the chat
			vim.cmd("WindowToggleMaximize")
		elseif request.match == "CodeCompanionInlineFinished" then
			-- Format the buffer after the inline request has completed
			require("conform").format({ bufnr = request.buf })
		end
	end,
})

return {
	"olimorris/codecompanion.nvim",
	keys = function()
		local function switch_window(cmd)
			return function()
				vim.cmd("WindowToggleMaximize") -- maximize the current window
				vim.cmd("vsplit") -- open a vertical split
				vim.cmd(cmd) -- issue the CodeCompanion command
			end
		end

		local mappings = {
			{ "<leader>aa", switch_window("CodeCompanionChat"), "Chat", { mode = { "n", "v" } } },
			{ "<leader>ae", switch_window("CodeCompanion /explain"), "Explain", { mode = { "v" } } },
			{ "<leader>ac", ":CodeCompanionActions<cr>", "Actions", { mode = { "n", "v" } } },
			{ "ga", switch_window("CodeCompanionChat Add"), "Add", { mode = { "v" } } },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "AI")
	end,
	opts = {
		adapters = {
			anthropic = function()
				return require("codecompanion.adapters").extend("anthropic", {
					env = {
						ANTHROPIC_API_KEY = vim.fn.getenv("ANTHROPIC_API_KEY"),
					},
				})
			end,
			copilot = function()
				return require("codecompanion.adapters").extend("copilot", {
					schema = {
						model = {
							-- default = "claude-3.5-sonnet",
							-- default = "o3-mini-2025-01-31",
							default = "gemini-2.0-flash-001",
							-- default = "gpt-4o-2024-08-06",
						},
						max_tokens = {
							default = 8192,
						},
					},
				})
			end,
			openai = function()
				return require("codecompanion.adapters").extend("openai", {
					env = {
						OPENAI_API_KEY = vim.fn.getenv("OPENAI_API_KEY"),
					},
				})
			end,
		},
		display = {
			chat = {
				intro_message = "Press ? for options",
				separator = "──",
				show_header_separator = true,
				show_references = true,
				start_in_insert_mode = true,
				window = {
					layout = "buffer",
					opts = {
						cursorline = true,
						foldcolumn = "1",
						numberwidth = 5,
						signcolumn = "yes",
					},
				},
			},
			diff = {
				enabled = true,
				close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
				layout = "horizontal", -- vertical|horizontal split for default provider
				opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
				provider = "mini_diff", -- default|mini_diff
			},
		},
		strategies = {
			chat = {
				adapter = "copilot",
				roles = {
					user = "ruic",
					llm = function(adapter)
						return string.format(
							"㋶ %s%s",
							adapter.formatted_name,
							adapter.schema.model.default and " (" .. adapter.schema.model.default .. ")" or ""
						)
					end,
				},
				keymaps = {
					previous_chat = {
						modes = { n = "<tab>" },
					},
					next_chat = {
						modes = { n = "<s-tab>" },
					},
				},
				slash_commands = {
					["buffer"] = {
						opts = {
							provider = "snacks",
						},
					},
					["help"] = {
						opts = {
							provider = "snacks",
							max_lines = 1000,
						},
					},
					["file"] = {
						opts = {
							provider = "snacks",
						},
					},
					["symbols"] = {
						opts = {
							provider = "snacks",
						},
					},
				},
			},
			inline = {
				adapter = "copilot",
			},
		},
		prompt_library = (function()
			local dev_prompts = {
				{
					short_name = "dev-angular",
					description = "Ask a Angular expert",
				},
				{
					short_name = "dev-js",
					description = "Ask a JavaScript expert",
				},
				{
					short_name = "dev-microbit",
					description = "Ask a micro:bit expert",
				},
				{
					short_name = "dev-react",
					description = "Ask a React expert",
				},
				{
					short_name = "dev-ts",
					description = "Ask a TypeScript expert",
				},
				{
					short_name = "dev-vim",
					description = "Ask a vim/neovim expert",
					references = {
						{
							type = "url",
							content = "https://github.com/ruicsh/nvim-config",
						},
					},
				},
			}

			local config = {}
			for _, prompt in ipairs(dev_prompts) do
				config[prompt.short_name] = {
					strategy = "chat",
					description = prompt.description,
					opts = {
						is_slash_cmd = true,
						short_name = prompt.short_name,
					},
					prompts = {
						{
							role = "system",
							content = read_prompt_file(prompt.short_name),
						},
						{
							role = "user",
							content = "",
						},
					},
					references = prompt.references or {},
				}
			end
			return config
		end)(),
	},
	config = function(_, opts)
		local cc = require("codecompanion")
		cc.setup(opts)

		vim.cmd([[cab cc CodeCompanion]]) -- shortcut on the cmdline
	end,

	cmd = {
		"CodeCompanion",
		"CodeCompanionActions",
		"CodeCompanionChat",
		"CodeCompanionCmd",
	},
	dependencies = {
		{ "nvim-lua/plenary.nvim", branch = "master" },
		"nvim-treesitter/nvim-treesitter",
		{ "hrsh7th/nvim-cmp" },
	},
}
