local M = {}

local default_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

---@param bufnr number|function
---@return number|nil
local function resolve_bufnr(bufnr)
	if type(bufnr) == "function" then
		local bn = bufnr()
		return bn
	end
	return bufnr
end

---@param line number|function|nil
---@param bufnr number
---@return number
local function resolve_line(line, bufnr)
	if type(line) == "function" then
		local ln = line()
		return ln or math.max(0, vim.api.nvim_buf_line_count(bufnr) - 1)
	end
	if type(line) == "number" then
		return line
	end
	-- Default to last line (0-indexed)
	return math.max(0, vim.api.nvim_buf_line_count(bufnr) - 1)
end

---Create a new spinner instance
---@param opts? table
---@field method? "global_var"|"extmark" — default: "global_var"
---@field frames? table — spinner frames, default: braille
---@field interval? number — ms between frames, default: 80
---@field global_var? string — for method="global_var", default: "spinner"
---@field bufnr? number|function — for method="extmark": buffer number or fn returning it
---@field line? number|function — for method="extmark": line number (0-indexed) or fn returning it, default: last line
---@field ns? number|string — for method="extmark": namespace id or name, default: auto-generated
---@field hl_group? string — for method="extmark": virt_text hl group, default: "Normal"
---@return table
function M.create(opts)
	opts = opts or {}

	local frames = opts.frames or default_frames
	local interval = opts.interval or 80
	local method = opts.method or "global_var"

	local frame_idx = 1
	local timer = nil
	local stopped = false

	-- State for extmark method
	local ns_id = nil
	local extmark_id = nil

	if method == "extmark" then
		if opts.ns then
			if type(opts.ns) == "number" then
				ns_id = opts.ns
			else
				ns_id = vim.api.nvim_create_namespace(opts.ns)
			end
		else
			ns_id = vim.api.nvim_create_namespace("spinner_" .. tostring(math.random(100000)))
		end
	end

	local function start()
		if timer then
			return
		end
		frame_idx = 1
		stopped = false
		timer = vim.uv.new_timer()

		if method == "global_var" then
			local global_var = opts.global_var or "spinner"
			_G[global_var] = frames[1]
			timer:start(
				0,
				interval,
				vim.schedule_wrap(function()
					if stopped then
						return
					end
					frame_idx = frame_idx % #frames + 1
					_G[global_var] = frames[frame_idx]
					vim.cmd("redrawstatus")
				end)
			)
		elseif method == "extmark" then
			local hl_group = opts.hl_group or "Normal"
			timer:start(
				0,
				interval,
				vim.schedule_wrap(function()
					if stopped then
						return
					end
					local buf = resolve_bufnr(opts.bufnr)
					if not buf or not vim.api.nvim_buf_is_valid(buf) then
						return
					end

					frame_idx = frame_idx % #frames + 1
					local target_line = resolve_line(opts.line, buf)

					if extmark_id then
						local ok = pcall(vim.api.nvim_buf_del_extmark, buf, ns_id, extmark_id)
						if not ok then
							extmark_id = nil
						end
					end

					local extmark_opts = { id = extmark_id }
					extmark_opts.virt_text = { { frames[frame_idx], hl_group } }
					extmark_opts.virt_text_pos = "eol"

					extmark_id = vim.api.nvim_buf_set_extmark(buf, ns_id, target_line, 0, extmark_opts)
				end)
			)
		end
	end

	local function stop()
		stopped = true
		if not timer then
			return
		end
		timer:stop()
		timer:close()
		timer = nil

		if method == "global_var" then
			local global_var = opts.global_var or "spinner"
			_G[global_var] = ""
			vim.cmd("redrawstatus")
		elseif method == "extmark" then
			local buf = resolve_bufnr(opts.bufnr)
			if buf and vim.api.nvim_buf_is_valid(buf) and ns_id then
				if extmark_id then
					pcall(vim.api.nvim_buf_del_extmark, buf, ns_id, extmark_id)
					extmark_id = nil
				end
			end
		end
	end

	return {
		start = start,
		stop = stop,
	}
end

return M
