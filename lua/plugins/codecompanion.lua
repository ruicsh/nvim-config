-- Code assistant chat/inline
-- https://codecompanion.olimorris.dev

local T = require("lib")

-- Track inline request window for cleanup
local inline_request_win = nil

-- Opens a floating input for inline CodeCompanion prompts
local function inline_prompt()
	-- Capture visual range and original buffer/window before we lose selection
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	local orig_win = vim.api.nvim_get_current_win()
	local range = string.format("%d,%d", start_pos[2], end_pos[2])

	-- Create a scratch buffer for the input
	local buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].filetype = "codecompanion-inline"

	-- Open floating window
	local width = math.min(60, math.floor(vim.o.columns * 0.5))
	local opts = {
		relative = "cursor",
		row = 1,
		col = 0,
		width = width,
		height = 1,
		style = "minimal",
		border = "rounded",
		title = " Prompt ",
		title_pos = "center",
	}
	local win = vim.api.nvim_open_win(buf, true, opts)
	inline_request_win = win

	-- Submit function: start request and show spinner in float
	local function submit()
		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
		local prompt = table.concat(lines, " "):gsub("^%s+", ""):gsub("%s+$", "")

		if prompt == "" then
			return
		end

		-- Clear content first, then lock the buffer
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
		vim.bo[buf].modifiable = false

		-- Remove keymaps
		vim.keymap.del({ "i", "n" }, "<C-s>", { buffer = buf })
		vim.keymap.del({ "i", "n" }, "<Esc>", { buffer = buf })

		-- Add cancel keymap that just closes the window
		vim.keymap.set({ "i", "n" }, "<Esc>", function()
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
			inline_request_win = nil
		end, { buffer = buf, silent = true })

		-- Create spinner for this float
		local request_spinner = T.spinner.create({
			method = "extmark",
			bufnr = buf,
			line = 0,
			hl_group = "CodeCompanionVirtualText",
		})

		-- Store reference to close on request finish
		local function cleanup()
			request_spinner.stop()
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
			inline_request_win = nil
		end

		-- Start the spinner
		request_spinner.start()

		-- Switch back to original window so CodeCompanion edits the right buffer
		if vim.api.nvim_win_is_valid(orig_win) then
			vim.api.nvim_set_current_win(orig_win)
			-- Ensure we're in normal mode, not insert mode
			vim.cmd("stopinsert")
		end

		-- Run the CodeCompanion command
		vim.cmd(string.format("%sCodeCompanion %s", range, prompt))

		-- Set up autocmd to close float when request finishes
		local group = vim.api.nvim_create_augroup("CodeCompanionInlineFloat" .. buf, { clear = true })
		vim.api.nvim_create_autocmd("User", {
			pattern = { "CodeCompanionRequestFinished", "CodeCompanionChatStopped" },
			group = group,
			callback = function()
				cleanup()
				vim.api.nvim_del_augroup_by_id(group)
			end,
			once = true,
		})
	end

	-- Cancel function: just close the window
	local function cancel()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
		inline_request_win = nil
	end

	-- Keymaps
	vim.keymap.set({ "i", "n" }, "<C-s>", submit, { buffer = buf, silent = true })
	vim.keymap.set({ "i", "n" }, "<Esc>", cancel, { buffer = buf, silent = true })

	-- Start in insert mode
	vim.cmd("startinsert")
end

local spinner = T.spinner.create({
	method = "extmark",
	bufnr = function()
		local chat = require("codecompanion").last_chat()
		return chat and chat.bufnr
	end,
	hl_group = "CodeCompanionVirtualText",
})

return {
	"olimorris/codecompanion.nvim",
	keys = {
		{ "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", desc = "CodeCompanion: ToggleChat" },
		{ "<leader>aa", inline_prompt, desc = "CodeCompanion: Inline prompt", mode = "x" },
	},
	config = function(_, opts)
		require("codecompanion").setup(opts)

		local group = vim.api.nvim_create_augroup("CodeCompanionSpinner", { clear = true })

		vim.api.nvim_create_autocmd("User", {
			pattern = "CodeCompanionRequestStarted",
			group = group,
			callback = spinner.start,
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = { "CodeCompanionRequestFinished", "CodeCompanionChatStopped" },
			group = group,
			callback = spinner.stop,
		})
	end,
	opts = {
		display = {
			chat = {
				fold_context = false,
				fold_reasoning = false,
				intro_message = "",
				window = {
					layout = "float",
					width = 0.5,
					height = function()
						return vim.o.lines - vim.o.cmdheight - 1
					end,
					col = math.floor(vim.o.columns * 0.5),
					row = 0,
					relative = "editor",
					border = { "", "", "", "", "", "", "", "│" },
					title = false,
					opts = {
						signcolumn = "yes:1",
					},
				},
			},
		},
		adapters = {
			acp = {
				opencode = false,
			},
			http = {
				opencode = function()
					return require("codecompanion.adapters").extend("openai_compatible", {
						env = {
							url = "https://opencode.ai/zen/go",
							api_key = "OPENCODE_API_KEY",
							chat_url = "/v1/chat/completions",
						},
						schema = {
							model = {
								default = T.env.get("OPENCODE_CHAT_MODEL"),
							},
						},
					})
				end,
			},
		},
		interactions = {
			chat = {
				adapter = "opencode",
				keymaps = {
					close = {
						modes = { n = "<c-d>", i = "<c-d>" },
						opts = {},
					},
					next_chat = false,
					previous_chat = false,
				},
			},
			inline = {
				adapter = "opencode",
			},
		},
	},
}
