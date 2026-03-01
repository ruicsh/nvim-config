-- GitHub Copilot Chat
-- https://github.com/CopilotC-Nvim/CopilotChat.nvim
-- https://docs.github.com/en/copilot/concepts/billing/copilot-requests
-- https://lmarena.ai/leaderboard/webdev

local T = require("lib")

local augroup = vim.api.nvim_create_augroup("ruicsh/plugin/copilot-chat", { clear = true })

local CHAT_HISTORY_DIR = vim.fn.stdpath("data") .. "/copilot-chats"

local function read_prompt_file(basename)
	local config_dir = tostring(vim.fn.stdpath("config"))
	local prompt_dir = vim.fs.joinpath(config_dir, "prompts")
	local file_path = vim.fs.joinpath(prompt_dir, string.format("%s.md", string.lower(basename)))
	if vim.fn.filereadable(file_path) == 0 then
		return ""
	end

	local lines = vim.fn.readfile(file_path)
	local content = table.concat(lines, "\n")

	-- Strip YAML front-matter (between --- markers)
	content = content:gsub("^%-%-%-\n.-\n%-%-%-\n*", "")

	return content
end

local function load_prompts(prompt_dir)
	local prompts = {}
	local prompt_files = vim.fn.glob(prompt_dir .. "/*.md", false, true)

	for _, file_path in ipairs(prompt_files) do
		local basename = vim.fn.fnamemodify(file_path, ":t:r")
		local prompt = read_prompt_file(basename)
		prompts[basename] = {
			prompt = prompt,
			system_prompt = prompt,
		}
	end

	return prompts
end

-- Parse a YAML front-matter field from a prompt file.
-- `field` is the front-matter key to look for (e.g. "keywords" or "buffer_keywords").
-- Returns a list of comma-separated values, or an empty table if none found.
local function parse_front_matter_field(file_path, field)
	if vim.fn.filereadable(file_path) == 0 then
		return {}
	end

	local lines = vim.fn.readfile(file_path)
	if #lines == 0 or lines[1] ~= "---" then
		return {}
	end

	for i = 2, #lines do
		if lines[i] == "---" then
			break
		end

		local value = lines[i]:match("^" .. field .. ":%s*(.+)$")
		if value then
			local items = {}
			for item in value:gmatch("[^,]+") do
				item = vim.trim(item)
				if item ~= "" then
					table.insert(items, item:lower())
				end
			end
			return items
		end
	end

	return {}
end

-- Build a keyword-to-prompt lookup table from all prompt files.
-- `field` is the front-matter key to read (defaults to "keywords").
-- Returns a table of { keyword = string, basename = string } entries, sorted by keyword
-- length descending so that multi-word keywords match before single-word ones.
local function load_keyword_map(prompt_dir, field)
	field = field or "keywords"
	local entries = {}
	local prompt_files = vim.fn.glob(prompt_dir .. "/*.md", false, true)

	for _, file_path in ipairs(prompt_files) do
		local basename = vim.fn.fnamemodify(file_path, ":t:r")
		local keywords = parse_front_matter_field(file_path, field)
		for _, keyword in ipairs(keywords) do
			table.insert(entries, { keyword = keyword, basename = basename })
		end
	end

	-- Sort by keyword length descending so multi-word keywords match first
	table.sort(entries, function(a, b)
		return #a.keyword > #b.keyword
	end)

	return entries
end

-- Module-level keyword maps, populated once in the config function
local keyword_map = {}
local buffer_keyword_map = {}

-- Detect which prompt files should be injected based on keywords found in the user prompt.
-- Returns a list of unique prompt basenames whose keywords appear in the prompt text.
local function detect_keyword_prompts(prompt)
	if not prompt or prompt == "" then
		return {}
	end

	local text = prompt:lower()
	local matched = {}
	local seen = {}

	for _, entry in ipairs(keyword_map) do
		if not seen[entry.basename] then
			-- Build a pattern that matches the keyword at word boundaries.
			-- Lua doesn't have \b, so we use frontier patterns %f.
			local escaped = entry.keyword:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")
			local pattern = "%f[%w:]" .. escaped .. "%f[^%w:]"
			if text:match(pattern) then
				table.insert(matched, entry.basename)
				seen[entry.basename] = true
			end
		end
	end

	return matched
end

-- Detect which prompt files should be injected based on keywords found in the buffer content.
-- Scans the first 50 lines of the source buffer for buffer_keywords matches.
-- `exclude` is an optional set of basenames to skip (already matched by user-prompt detection).
local function detect_buffer_keyword_prompts(bufnr, exclude)
	if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
		return {}
	end

	local line_count = vim.api.nvim_buf_line_count(bufnr)
	local max_lines = math.min(50, line_count)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, max_lines, false)
	local text = table.concat(lines, "\n"):lower()

	if text == "" then
		return {}
	end

	local matched = {}
	local seen = exclude or {}

	for _, entry in ipairs(buffer_keyword_map) do
		if not seen[entry.basename] then
			local escaped = entry.keyword:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")
			local pattern = "%f[%w:/@%-]" .. escaped .. "%f[^%w:/@%-]"
			if text:match(pattern) then
				table.insert(matched, entry.basename)
				seen[entry.basename] = true
			end
		end
	end

	return matched
end

local function save_chat(response)
	local chat = require("CopilotChat")

	if vim.g.copilot_chat_title then
		chat.save(vim.g.copilot_chat_title)
		return
	end

	-- Use AI to generate prompt title based on first AI response to user question
	local system_prompt = read_prompt_file("chattitle")
	local prompt = vim.trim(system_prompt:format(response.content))
	chat.ask(prompt, {
		callback = function(gen_response)
			-- Generate timestamp in format YYYYMMDD_HHMMSS
			local timestamp = os.date("%Y%m%d_%H%M%S")
			-- Encode the generated title to make it safe as a filename
			local safe_title = vim.base64.encode(gen_response.content):gsub("/", "_"):gsub("+", "-"):gsub("=", "")
			vim.g.copilot_chat_title = timestamp .. "_" .. vim.trim(safe_title)
			chat.save(vim.g.copilot_chat_title)
			return gen_response
		end,
		headless = true, -- Disable updating chat buffer and history with this question
		model = T.env.get("COPILOT_MODEL_CHEAP"),
	})
end

local function new_chat_window(prompt, opts)
	local chat = require("CopilotChat")

	vim.g.copilot_chat_title = nil -- Reset chat title used for saving chat history
	chat.reset()

	if prompt ~= "" then
		chat.ask(prompt, opts)
	else
		chat.open(opts)
		if opts.load then
			chat.load(opts.load)
		end
	end
end

local function customize_chat_window()
	vim.api.nvim_create_autocmd("BufEnter", {
		group = augroup,
		pattern = "copilot-chat",
		callback = function()
			vim.opt_local.conceallevel = 0
			vim.opt_local.signcolumn = "yes:1"
			vim.opt_local.foldlevel = 999
			vim.opt_local.foldlevelstart = 99
			vim.opt_local.formatoptions:remove("r")
			vim.api.nvim_win_set_var(0, "side_panel", true)
		end,
	})
end

-- Suffixes to strip when looking for the source file (order matters: longest first)
local ALTERNATE_SUFFIXES = {
	".stories.tsx",
	".stories.ts",
	".spec.tsx",
	".spec.ts",
	".test.tsx",
	".test.ts",
}

local function get_alternate_file()
	local current_file = vim.fn.expand("%:p")

	for _, suffix in ipairs(ALTERNATE_SUFFIXES) do
		if current_file:sub(-#suffix) == suffix then
			local base = current_file:sub(1, -#suffix - 1)
			-- Try the corresponding source extension (.tsx or .ts)
			local source_ext = suffix:match("%.([^.]+)$")
			local source_file = base .. "." .. source_ext
			if vim.fn.filereadable(source_file) == 1 then
				local cwd = vim.fn.getcwd()
				return source_file:gsub("^" .. vim.pesc(cwd) .. "/", "")
			end
		end
	end

	return nil
end

local function open_chat()
	local sticky = {}

	-- Include alternate source file if current file is a test/story
	local alternate = get_alternate_file()
	if alternate then
		table.insert(sticky, "#file:" .. alternate)
	end

	local is_visual_mode = vim.fn.mode():match("[vV]") ~= nil
	if is_visual_mode then
		table.insert(sticky, "#selection")
	else
		table.insert(sticky, "#buffer")
	end

	new_chat_window("", {
		model = T.env.get("COPILOT_MODEL_CODEGEN"),
		sticky = sticky,
		system_prompt = "COPILOT_INSTRUCTIONS",
	})
end

local function delete_old_chat_files()
	local scandir = require("plenary.scandir")

	local files = scandir.scan_dir(CHAT_HISTORY_DIR, {
		search_pattern = "%.json$",
		depth = 1,
	})

	local current_time = os.time()
	local one_month_ago = current_time - (30 * 24 * 60 * 60) -- 30 days in seconds
	local deleted_count = 0

	for _, file in ipairs(files) do
		local mtime = vim.fn.getftime(file)

		if mtime < one_month_ago then
			local success, err = os.remove(file)
			if success then
				deleted_count = deleted_count + 1
			else
				vim.notify("Failed to delete old chat file: " .. err, vim.log.levels.WARN)
			end
		end
	end

	if deleted_count > 0 then
		vim.notify("Deleted " .. deleted_count .. " old chat files", vim.log.levels.INFO)
	end
end

local function decode_title(encoded_title)
	-- Extract the timestamp part (before first underscore)
	local timestamp, encoded = encoded_title:match("^(%d%d%d%d%d%d%d%d_%d%d%d%d%d%d)_(.+)$")

	-- Restore base64 padding characters
	local padding_len = 4 - (#encoded % 4)
	if padding_len < 4 then
		encoded = encoded .. string.rep("=", padding_len)
	end

	-- Restore original base64 characters
	encoded = encoded:gsub("_", "/"):gsub("-", "+")

	-- Decode and return with timestamp if successful
	local success, decoded = pcall(vim.base64.decode, encoded)
	if success and timestamp then
		return timestamp .. ": " .. decoded
	else
		return encoded_title -- Fallback to encoded if decoding fails
	end
end

local function list_chat_history()
	local snacks = require("snacks")
	local chat = require("CopilotChat")
	local scandir = require("plenary.scandir")

	-- Delete old chat files first
	delete_old_chat_files()

	local files = scandir.scan_dir(CHAT_HISTORY_DIR, {
		search_pattern = "%.json$",
		depth = 1,
	})

	if #files == 0 then
		vim.notify("No chat history found", vim.log.levels.INFO)
		return
	end

	local items = {}
	for i, item in ipairs(files) do
		-- Extract basename from file's full path without extension
		local filename = item:match("^.+[/\\](.+)$") or item
		local basename = filename:match("^(.+)%.[^%.]*$") or filename

		table.insert(items, {
			idx = i,
			file = item,
			basename = basename,
			text = basename,
		})
	end

	table.sort(items, function(a, b)
		return a.file > b.file
	end)

	-- Check if we have any valid items
	if #items == 0 then
		vim.notify("No valid chat history files found", vim.log.levels.INFO)
		return
	end

	snacks.picker({
		actions = {
			delete_history_file = function(picker, item)
				if not item or not item.file then
					vim.notify("No file selected", vim.log.levels.WARN)
					return
				end

				-- Confirm deletion
				vim.ui.select(
					{ "Yes", "No" },
					{ prompt = "Delete " .. vim.fn.fnamemodify(item.file, ":t") .. "?" },
					function(choice)
						if choice == "Yes" then
							-- Delete the file
							local success, err = os.remove(item.file)
							if success then
								vim.notify("Deleted: " .. item.file, vim.log.levels.INFO)
								-- Refresh the picker to show updated list
								picker:close()
								vim.schedule(function()
									list_chat_history()
								end)
							else
								vim.notify("Failed to delete: " .. (err or "unknown error"), vim.log.levels.ERROR)
							end
						end
					end
				)
			end,
		},
		confirm = function(picker, item)
			picker:close()

			-- Verify file exists before loading
			if vim.fn.filereadable(item.file) == 0 then
				vim.notify("Chat history file not found: " .. item.file, vim.log.levels.ERROR)
				return
			end

			vim.g.copilot_chat_title = item.basename

			new_chat_window("", {
				load = item.basename,
			})
		end,
		items = items,
		format = function(item)
			local formatted_title = decode_title(item.basename)
			local display = " " .. formatted_title

			local mtime = vim.fn.getftime(item.file)
			local date = T.fn.fmt_relative_time(mtime)

			return {
				{ string.format("%-5s", date), "SnacksPickerLabel" },
				{ display },
			}
		end,
		preview = function(ctx)
			local file = io.open(ctx.item.file, "r")
			if not file then
				ctx.preview:set_lines({ "Unable to read file" })
				return
			end

			local content = file:read("*a")
			file:close()

			local ok, messages = pcall(vim.json.decode, content, {
				luanil = {
					object = true,
					array = true,
				},
			})

			if not ok then
				ctx.preview:set_lines({ "vim.fn.json_decode error" })
				return
			end

			local config = chat.config
			local preview = {}
			for _, message in ipairs(messages or {}) do
				local header = message.role == "user" and config.question_header or config.answer_header
				table.insert(preview, header .. config.separator .. "\n")
				table.insert(preview, message.content .. "\n")
			end

			ctx.preview:highlight({ ft = "copilot-chat" })
			ctx.preview:set_lines(preview)
		end,
		sort = {
			fields = { "text:desc" },
		},
		title = "Copilot Chat History",
		win = {
			input = {
				keys = {
					["dd"] = "delete_history_file", -- Use our custom action
				},
			},
		},
	})
end

local function resources_get_buffer(bufnr)
	local utils = require("CopilotChat.utils")
	local files = require("CopilotChat.utils.files")

	local content = nil

	if not utils.buf_valid(bufnr) then
		-- Read it from disk if not loaded in a buffer
		local name = vim.api.nvim_buf_get_name(bufnr)
		if name == "" or vim.fn.filereadable(name) == 0 then
			return nil
		end
		content = vim.fn.readfile(name)
		if not content or #content == 0 then
			return nil
		end
	else
		content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
		if not content or #content == 0 then
			return nil
		end
	end

	return table.concat(content, "\n"), files.filetype_to_mimetype(vim.bo[bufnr].filetype)
end

return {
	"CopilotC-Nvim/CopilotChat.nvim",
	keys = function()
		local chat = require("CopilotChat")

		return {
			{ "<leader>aa", open_chat, desc = "AI: Assistance", mode = { "n", "v" } },
			{ "<leader>ah", list_chat_history, desc = "AI: List chat history" },
			{ "<leader>am", chat.select_model, desc = "AI: Models" },
		}
	end,
	config = function()
		local chat = require("CopilotChat")
		local utils = require("CopilotChat.utils")
		local resources = require("CopilotChat.resources")

		customize_chat_window()
		local proxy = T.env.get("COPILOT_PROXY")
		local prompt_dir = vim.fn.stdpath("config") .. "/prompts"
		local prompts = load_prompts(prompt_dir)

		-- Build keyword maps from prompt file front-matter
		keyword_map = load_keyword_map(prompt_dir, "keywords")
		buffer_keyword_map = load_keyword_map(prompt_dir, "buffer_keywords")

		chat.setup({
			allow_insecure = true,
			auto_fold = true,
			auto_follow_cursor = true,
			auto_insert_mode = true,
			callback = function(response)
				save_chat(response)
				-- Scroll to the bottom of the chat window
				vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(0), 0 })
			end,
			chat_autocomplete = false,
			functions = {
				buffer = {
					group = "copilot",
					uri = "buffer://{name}",
					description = "Retrieves content from a specific buffer.",
					schema = {
						type = "object",
						required = { "name" },
						properties = {
							name = {
								type = "string",
								description = "Buffer filename to include in chat context.",
								enum = function()
									local chat_winid = vim.api.nvim_get_current_win()
									local async = require("plenary.async")
									local fn = async.wrap(function(callback)
										Snacks.picker.buffers({
											confirm = function(picker, item)
												picker:close()
												-- Return focus to the chat window
												if vim.api.nvim_win_is_valid(chat_winid) then
													vim.api.nvim_set_current_win(chat_winid)
													vim.cmd("normal! a")
												end
												callback({ item.file })
											end,
										})
									end, 1)
									return fn()
								end,
							},
						},
					},
					resolve = function(input, source)
						utils.schedule_main()
						local name = input.name or vim.api.nvim_buf_get_name(source.bufnr)
						local found_buf = nil
						for _, buf in ipairs(vim.api.nvim_list_bufs()) do
							if vim.api.nvim_buf_get_name(buf) == name then
								found_buf = buf
								break
							end
						end

						if not found_buf then
							error("Buffer not found: " .. name)
						end

						local data, mimetype = resources_get_buffer(found_buf)
						if not data then
							error("Buffer not found: " .. name)
						end

						return {
							{
								uri = "buffer://" .. name,
								name = name,
								mimetype = mimetype,
								data = data,
							},
						}
					end,
				},
				file = {
					group = "copilot",
					uri = "file://{path}",
					description = "Pick a file to include in chat context.",
					resolve = function(input)
						utils.schedule_main()
						local data, mimetype = resources.get_file(input.path)
						if not data then
							error("File not found: " .. input.path)
						end

						return {
							{
								uri = "file://" .. input.path,
								name = input.path,
								mimetype = mimetype,
								data = data,
							},
						}
					end,
					schema = {
						type = "object",
						required = { "path" },
						properties = {
							path = {
								type = "string",
								description = "Path to file to include in chat context.",
								enum = function()
									local chat_winid = vim.api.nvim_get_current_win()
									local async = require("plenary.async")
									local fn = async.wrap(function(callback)
										Snacks.picker.smart({
											confirm = function(picker, item)
												picker:close()
												-- Return focus to the chat window
												if vim.api.nvim_win_is_valid(chat_winid) then
													vim.api.nvim_set_current_win(chat_winid)
													vim.cmd("normal! a")
												end
												callback({ item.file })
											end,
										})
									end, 1)
									return fn()
								end,
							},
						},
					},
				},
				gitdiff = {
					group = "copilot",
					uri = "git://diff/{target}",
					description = "Retrieves git diff information. Requires git to be installed. Useful for discussing code changes or explaining the purpose of modifications.",
					schema = {
						type = "object",
						required = { "target" },
						properties = {
							target = {
								type = "string",
								description = "Target to diff against.",
								enum = { "unstaged", "staged", "<sha>" },
								default = "unstaged",
							},
						},
					},
					resolve = function(input, source)
						local cmd = { "git", "-C", source.cwd(), "diff", "--no-color", "--no-ext-diff" }

						if input.target == "staged" then
							table.insert(cmd, "--staged")
						elseif input.target == "unstaged" then
							table.insert(cmd, "--")
						else
							table.insert(cmd, input.target)
						end

						local EXCLUDE_FILES = { "package-lock.json", "lazy-lock.json", "Cargo.lock" }
						for _, file in ipairs(EXCLUDE_FILES) do
							table.insert(cmd, ":(exclude)" .. file)
						end

						local out = utils.system(cmd)

						return {
							{
								uri = "git://diff/" .. input.target,
								mimetype = "text/plain",
								data = out.stdout,
							},
						}
					end,
				},
			},
			insert_at_end = false,
			headers = {
				user = "꠵ User ",
				assistant = "꠵ Assistant ",
				tool = "꠵ Tool ",
			},
			history_path = CHAT_HISTORY_DIR, -- Default path to stored history
			log_level = "warn",
			mappings = {
				close = {
					normal = "<c-d>",
					insert = "<c-d>",
				},
				submit_prompt = {
					normal = "<c-s>",
					insert = "<c-s>",
				},
				show_help = {
					normal = "g?",
				},
			},
			model = T.env.get("COPILOT_MODEL_CODEGEN"),
			prompts = prompts,
			proxy = proxy,
			remember_as_sticky = false,
			separator = "⠒",
			show_help = false,
			show_folds = true,
			window = vim.tbl_extend("force", T.ui.side_panel_win_config(), {
				focusable = true,
				layout = "float",
				zindex = 50,
			}),
		})

		-- Wrap chat.ask() to auto-inject system prompts based on keywords
		local original_ask = chat.ask
		chat.ask = function(prompt, config)
			config = config or {}

			-- Skip keyword detection for headless calls (e.g., commit message generation)
			if config.headless then
				return original_ask(prompt, config)
			end

			local seen = {}
			local extra_prompts = {}

			-- Detect from user prompt text
			local prompt_basenames = detect_keyword_prompts(prompt)
			for _, basename in ipairs(prompt_basenames) do
				local content = read_prompt_file(basename)
				if content ~= "" then
					table.insert(extra_prompts, content)
				end
				seen[basename] = true
			end

			-- Detect from buffer content
			local source = chat.get_source()
			local bufnr = source and source.bufnr or nil
			local buffer_basenames = detect_buffer_keyword_prompts(bufnr, seen)
			for _, basename in ipairs(buffer_basenames) do
				local content = read_prompt_file(basename)
				if content ~= "" then
					table.insert(extra_prompts, content)
				end
			end

			if #extra_prompts > 0 then
				-- Resolve the base system prompt: use whatever is already in config,
				-- fall back to the global default (e.g. "COPILOT_INSTRUCTIONS").
				-- If it's a named prompt reference, read its content so we can append to it.
				local base = config.system_prompt or chat.config.system_prompt or ""
				if chat.config.prompts[base] then
					base = chat.config.prompts[base].system_prompt or base
				end
				config.system_prompt = base .. "\n\n" .. table.concat(extra_prompts, "\n\n")
			end

			return original_ask(prompt, config)
		end
	end,

	tag = "v4.7.4",
	dependencies = {
		{ "zbirenbaum/copilot.lua" },
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-treesitter/nvim-treesitter" },
	},
}
