-- GitHub Copilot Chat
-- https://github.com/CopilotC-Nvim/CopilotChat.nvim

-- Custom prompts to be used with the `:CopilotChat` command
local custom_prompts = {
	"angular",
	"js",
	"lua",
	"microbit",
	"react",
	"rust",
	"ts",
	"vim",
}

-- Read the contents of a prompt file given its basename
local function read_prompt_file(basename)
	local config_path = vim.fn.stdpath("config")
	local file_path = config_path .. "/prompts/" .. basename .. ".txt"
	return vim.fs.read_file(string.lower(file_path))
end

-- Build a system prompt based on the current file type
local function get_system_prompt()
	local ft = vim.bo.filetype
	local filename = vim.fn.expand("%:t")
	local prompts = {}

	if
		filename:match("%.component%.ts$")
		or filename:match("%.component%.html$")
		or filename:match("%.module%.ts$")
		or ft == "htmlangular"
	then
		table.insert(prompts, "angular")
		table.insert(prompts, "js")
		table.insert(prompts, "ts")
	elseif ft == "javascript" then
		table.insert(prompts, "js")
	elseif ft == "typescript" then
		table.insert(prompts, "js")
		table.insert(prompts, "ts")
	elseif ft == "vim" or ft == "lua" then
		table.insert(prompts, "vim")
		table.insert(prompts, "lua")
	elseif ft == "rust" then
		table.insert(prompts, "rust")
	elseif ft == "typescriptreact" then
		table.insert(prompts, "react")
		table.insert(prompts, "js")
		table.insert(prompts, "ts")
	end

	table.insert(prompts, "communication")

	local system_prompt = ""
	for _, prompt in ipairs(prompts) do
		system_prompt = system_prompt .. "\n\n" .. "> /" .. prompt
		-- system_prompt = system_prompt .. "\n\n" .. read_prompt_file(prompt)
	end

	return system_prompt
end

vim.api.nvim_create_user_command("CopilotCommitMessage", function()
	local chat = require("CopilotChat")
	local filename = vim.fn.getenv("IS_WORK") == "true" and "commit_message_work" or "commit_message"
	local prompt = read_prompt_file(filename)

	chat.ask(prompt, {
		clear_chat_on_new_prompt = true,
		window = {
			col = 1,
			height = 20,
			layout = "float",
			relative = "cursor",
			row = 1,
			title = "  Commit message",
			width = 80,
		},
	})
end, {})

vim.api.nvim_create_user_command("CopilotCodeReview", function()
	local chat = require("CopilotChat")
	local config = require("CopilotChat.config")

	local system_prompt = read_prompt_file("code_review")
	local prompt = [[
> #git:staged

Review my staged code files before I commit them.
  ]]

	chat.ask(prompt, {
		callback = config.prompts.Review.callback,
		clear_chat_on_new_prompt = true,
		system_prompt = system_prompt,
	})
end, {})

return {
	"CopilotC-Nvim/CopilotChat.nvim",
	keys = function()
		local chat = require("CopilotChat")
		local actions = require("CopilotChat.actions")
		local config = require("CopilotChat.config")

		local function switch_window(cmd)
			return function()
				vim.cmd("WindowToggleMaximize") -- maximize the current window
				vim.cmd("vsplit") -- open a vertical split
				vim.cmd(cmd) -- issue the command
			end
		end

		local function show_actions()
			require("CopilotChat.integrations.snacks").pick(actions.prompt_actions())
		end

		local function ask_question()
			require("snacks").input({
				prompt = " Copilot",
			}, function(input)
				if input ~= "" then
					local cmd = "CopilotChat " .. input
					switch_window(cmd)()
				end
			end)
		end

		local function switch_prompt()
			vim.ui.select(custom_prompts, {
				prompt = "Select a custom prompt",
				format_item = function(item)
					return item
				end,
			}, function(choice)
				local cmd = "CopilotChat" .. choice

				local ft = vim.bo.filetype
				if ft ~= "copilot-chat" then
					switch_window(cmd)()
				else
					vim.cmd(cmd)
				end
			end)
		end

		local function inline(action)
			return function()
				local system_prompt = get_system_prompt()

				local prompt = ""
				if action == "Explain" then
					prompt = "Write an explanation for the selected code as paragraphs of text."
					system_prompt = config.prompts.COPILOT_EXPLAIN.system_prompt .. system_prompt
				elseif action == "Fix" then
					prompt = "There is a problem in this code. Rewrite the code to show it with the bug fixed."
					system_prompt = config.prompts.COPILOT_GENERATE.system_prompt .. system_prompt
				elseif action == "Implement" then
					-- prompt = config.prompts.Implement.prompt
				elseif action == "Optimize" then
					prompt = "Optimize the selected code to improve performance and readability."
					system_prompt = config.prompts.COPILOT_GENERATE.system_prompt .. system_prompt
				elseif action == "Refactor" then
					-- prompt = config.prompts.Refactor.prompt
				elseif action == "Simplify" then
					-- prompt = config.prompts.Simplify.prompt
				end

				chat.ask(prompt, {
					auto_insert_mode = false,
					clear_chat_on_new_prompt = true,
					model = "claude-3.5-sonnet",
					system_prompt = system_prompt,
					window = {
						col = 1,
						height = 20,
						layout = "float",
						relative = "cursor",
						row = 1,
						title = "  " .. action,
						width = 80,
					},
				})
			end
		end

		local mappings = {
			-- chat
			{ "<leader>aA", switch_window("CopilotChatOpen"), "Chat" },
			{ "<leader>aa", switch_window("CopilotChatToggle"), "Chat" },
			-- TODO: remove this mapping, after it's all done
			{ "<leader>ac", show_actions, "Chat" },
			{ "<leader>am", chat.select_model, "Models" },
			{ "<leader>ap", switch_prompt, "Switch prompt" },
			{ "<leader>aq", ask_question, "Ask" },
			{ "<leader>ax", chat.reset, "Reset" },
			{ "<c-]>", chat.stop, "Stop" },

			-- inline
			{ "<leader>ae", inline("Explain"), "Explain", { mode = "v" } },
			{ "<leader>af", inline("Fix"), "Fix", { mode = "v" } },
			{ "<leader>ai", inline("Implement"), "Implement", { mode = "v" } },
			{ "<leader>ao", inline("Optimize"), "Optimize", { mode = "v" } },
			{ "<leader>ar", inline("Refactor"), "Refactor", { mode = "v" } },
			{ "<leader>as", inline("Simplify"), "Simplify", { mode = "v" } },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "AI")
	end,
	opts = {
		answer_header = "  Copilot ",
		auto_insert_mode = true,
		chat_autocomplete = false,
		error_header = "  Error ",
		insert_at_end = true,
		mappings = {
			accept_diff = {
				normal = "<c-l>",
				insert = "<c-l>",
			},
			close = {
				normal = "<c-]>",
				insert = "<c-]>",
			},
			reset = {
				normal = "<c-x>",
				insert = "<c-x>",
			},
			show_diff = {
				full_diff = true,
			},
			yank_diff = {
				normal = "gy",
				register = "+",
			},
		},
		model = "claude-3.5-sonnet",
		question_header = "  ruicsh ",
		prompts = (function()
			local prompts = {}
			-- Load custom prompts
			for _, prompt in ipairs(custom_prompts) do
				prompts[prompt] = read_prompt_file(prompt)
			end
			return prompts
		end)(),
		show_help = false,
		sticky = {
			"/COPILOT_GENERATE",
		},
		window = {
			layout = "replace",
		},
	},

	lazy = false,
	dependencies = {
		{ "zbirenbaum/copilot.lua" },
		{ "nvim-lua/plenary.nvim" },
	},
}
