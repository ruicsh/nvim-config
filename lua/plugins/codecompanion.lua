-- AI chat and inline assistant.
-- https://codecompanion.olimorris.dev/

local function read_prompt_file(basename)
	local config_path = vim.fn.stdpath("config")
	local file_path = config_path .. "/prompts/" .. basename .. ".txt"
	return vim.fs.read_file(file_path)
end

return {
	"olimorris/codecompanion.nvim",
	keys = function()
		local function switch_window(cmd)
			return function()
				vim.cmd.wincmd("w")
				vim.cmd(cmd)
			end
		end

		local mappings = {
			{ "<leader>aa", switch_window("CodeCompanionChat"), "Chat", { mode = { "n", "v" } } },
			{ "<leader>ae", switch_window("CodeCompanion /explain"), "Explain", { mode = { "v" } } },
			{ "<leader>ac", ":CodeCompanionActions<cr>", "Actions", { mode = { "n", "v" } } },
			{ "<c-a>", ":CodeCompanionChat Toggle<cr>", "Chat", { mode = { "n", "v" } } },
			{ "ga", ":CodeCompanionChat Add<cr>", "Add", { mode = { "v" } } },
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
							default = "gpt-4o-2024-08-06",
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
		},
		strategies = {
			chat = {
				adapter = "copilot",
				roles = {
					user = "Me",
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
						modes = {
							n = "<tab>",
						},
					},
					next_chat = {
						modes = {
							n = "<s-tab>",
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
					short_name = "dev-react",
					description = "Ask a React expert",
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
