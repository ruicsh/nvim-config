local M = {}

local PIN_FILE = vim.fn.stdpath("config") .. "/lua/plugins/_pins.lua"
local REGISTRY_FILE = vim.fn.stdpath("data") .. "/pin-discovery.json"

-- Track graduates globally for :PinReview
local _last_graduates = {}

---@param plugin table
---@return string|nil
local function get_repo_dir(plugin)
	if plugin.dir then
		return plugin.dir
	end
	return vim.fn.stdpath("data") .. "/lazy/" .. plugin.name
end

---@param url string
---@return string
local function normalize_url(url)
	local normalized = url:gsub("^https?://[^/]+/", ""):gsub("^git@[^:]+:", ""):gsub("%.git$", ""):gsub("/$", "")
	return normalized
end

---@return table
local function load_registry()
	if vim.fn.filereadable(REGISTRY_FILE) == 0 then
		return {}
	end
	local f = io.open(REGISTRY_FILE, "r")
	if not f then
		return {}
	end
	local content = f:read("*a")
	f:close()
	local ok, data = pcall(vim.json.decode, content)
	return ok and data or {}
end

---@param registry table
local function save_registry(registry)
	local f = io.open(REGISTRY_FILE, "w")
	if f then
		f:write(vim.json.encode(registry))
		f:close()
	end
end

M.show_review = function()
	if #_last_graduates == 0 then
		vim.notify("No pending updates to review. Run :PinPlugins first.", vim.log.levels.INFO)
		return
	end

	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(bufnr, "Plugin Update Review")
	vim.api.nvim_set_option_value("filetype", "markdown", { buf = bufnr })

	local lines = {
		"# Plugin Update Review",
		"",
		"The following plugins have aged and are ready to be pinned.",
		"Press `gx` on the GitHub links to see the changes.",
		"",
	}

	for _, g in ipairs(_last_graduates) do
		table.insert(lines, string.format("## %s", g.name))
		table.insert(lines, string.format("- **From:** `%s`", (g.from or "none"):sub(1, 7)))
		table.insert(lines, string.format("- **To:**   `%s` (Aged %d days)", g.to:sub(1, 7), g.age_days))
		table.insert(lines, string.format("- **Diff:** https://github.com/%s/compare/%s...%s", g.url, g.from or "", g.to))
		table.insert(lines, "")
	end

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
	vim.api.nvim_set_option_value("modifiable", false, { buf = bufnr })

	-- Open in a float or a split
	vim.api.nvim_open_win(bufnr, true, {
		relative = "editor",
		width = math.floor(vim.o.columns * 0.8),
		height = math.floor(vim.o.lines * 0.8),
		row = math.floor(vim.o.lines * 0.1),
		col = math.floor(vim.o.columns * 0.1),
		border = "rounded",
		style = "minimal",
	})

	-- Keymap to close
	vim.keymap.set("n", "q", ":close<CR>", { buffer = bufnr, silent = true })
	vim.keymap.set("n", "<ESC>", ":close<CR>", { buffer = bufnr, silent = true })
end

M.pin_plugins = function(opts)
	opts = opts or {}
	local days = opts.days or 14
	local force_fetch = opts.force_fetch or false
	local now = os.time()
	local age_seconds = days * 24 * 60 * 60

	local ok, lazy_config = pcall(require, "lazy.core.config")
	if not ok then
		vim.notify("Lazy.nvim config not found", vim.log.levels.ERROR)
		return
	end

	local registry = load_registry()
	local pins = {}
	local graduates = {}
	local total = 0
	local skipped = 0

	for _, plugin in pairs(lazy_config.plugins) do
		if plugin.url then
			if plugin.version or plugin.tag then
				skipped = skipped + 1
			else
				total = total + 1
			end
		end
	end

	local count = 0
	local spinner = require("lib.spinner").create({ global_var = "pin_spinner" })
	spinner.start()

	local names = {}
	for name, _ in pairs(lazy_config.plugins) do
		table.insert(names, name)
	end
	table.sort(names)

	-- Load existing pins to have a baseline
	local existing_pins = {}
	local pins_ok, current_pins = pcall(require, "plugins._pins")
	if pins_ok and type(current_pins) == "table" then
		for _, pin in ipairs(current_pins) do
			existing_pins[pin[1]] = pin.commit
		end
	end

	for _, name in ipairs(names) do
		local plugin = lazy_config.plugins[name]
		if plugin.url and not (plugin.version or plugin.tag) then
			count = count + 1
			_G.pin_spinner_msg = string.format("Processing %d/%d: %s", count, total, name)
			vim.cmd("redrawstatus")

			local repo_dir = get_repo_dir(plugin)
			local url_key = normalize_url(plugin.url)

			if repo_dir and vim.fn.isdirectory(repo_dir) == 1 then
				local branch = plugin.branch
				if not branch then
					local res = vim.system({ "git", "-C", repo_dir, "symbolic-ref", "--short", "refs/remotes/origin/HEAD" })
						:wait()
					if res.code == 0 then
						branch = res.stdout:gsub("^origin/", ""):gsub("%s+$", "")
					end
				end
				branch = branch or "main"

				if force_fetch then
					vim.system({ "git", "-C", repo_dir, "fetch", "origin" }):wait()
				end

				-- Get current remote HEAD
				local head_res = vim.system({ "git", "-C", repo_dir, "rev-parse", "origin/" .. branch }):wait()
				if head_res.code == 0 then
					local head_commit = head_res.stdout:gsub("%s+$", "")

					-- Update registry
					if not registry[url_key] then
						registry[url_key] = { branch = branch, discoveries = {} }
					end
					if not registry[url_key].discoveries[head_commit] then
						registry[url_key].discoveries[head_commit] = now
					end

					-- Find best eligible commit (most recent that is old enough)
					local best_commit = nil
					local best_discovery_time = -1

					for commit, discovery_time in pairs(registry[url_key].discoveries) do
						if (now - discovery_time) >= age_seconds then
							if discovery_time > best_discovery_time then
								best_discovery_time = discovery_time
								best_commit = commit
							end
						end
					end

					-- Determine final pin
					local final_commit = best_commit or existing_pins[url_key] or head_commit
					if best_commit and best_commit ~= existing_pins[url_key] then
						table.insert(graduates, {
							name = name,
							url = url_key,
							from = existing_pins[url_key],
							to = best_commit,
							age_days = math.floor((now - best_discovery_time) / (24 * 60 * 60)),
						})
					end

					table.insert(pins, { url = url_key, commit = final_commit, name = name })
				end
			end
		end
	end

	_G.pin_spinner_msg = nil
	spinner.stop()

	save_registry(registry)

	if #pins == 0 then
		vim.notify("No plugins to pin.", vim.log.levels.WARN)
		return
	end

	_last_graduates = graduates

	-- Write the pins file
	local lines = {
		"-- Auto-generated by :PinPlugins on " .. os.date("%Y-%m-%d"),
		"-- DO NOT EDIT MANUALLY. Run :PinPlugins to regenerate.",
		"",
		"return {",
	}

	table.sort(pins, function(a, b)
		return a.name < b.name
	end)
	for _, pin in ipairs(pins) do
		table.insert(lines, string.format('  { "%s", commit = "%s" },', pin.url, pin.commit))
	end
	table.insert(lines, "}")

	local f = io.open(PIN_FILE, "w")
	if f then
		f:write(table.concat(lines, "\n") .. "\n")
		f:close()

		local msg = "Updated pins. " .. #graduates .. " plugins graduated to newer commits."
		if skipped > 0 then
			msg = msg .. " (Skipped " .. skipped .. " plugins with version/tag)"
		end
		vim.notify(msg, vim.log.levels.INFO)

		if #graduates > 0 then
			M.show_review()
		end
	else
		vim.notify("Failed to write pins file: " .. PIN_FILE, vim.log.levels.ERROR)
	end
end

return M
