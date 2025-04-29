-- Quickfix.

local augroup = vim.api.nvim_create_augroup("ruicsh/filetypes/qf", { clear = true })
local ns = vim.api.nvim_create_namespace("ruicsh/filetypes/qf")

-- Hold the window id for the preview window
local preview_winid = nil

local function close_preview_window()
	if preview_winid and vim.api.nvim_win_is_valid(preview_winid) then
		vim.api.nvim_win_close(preview_winid, true)
	end
	preview_winid = nil
end

local function open_preview()
	local line = vim.fn.line(".")
	local qf = vim.fn.getqflist({ items = 0, size = 1, winid = 0 })
	local entry = qf.items[line]
	if not entry then
		vim.notify("No entry found at the current index in the quickfix list", vim.log.levels.ERROR)
		return
	end

	local file = vim.api.nvim_buf_get_name(entry.bufnr)

	if preview_winid and preview_winid ~= nil and vim.api.nvim_win_is_valid(preview_winid) then
		vim.api.nvim_set_current_win(preview_winid)
	else
		local buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
		local qfwin = vim.fn.getwininfo(qf.winid)[1]

		preview_winid = vim.api.nvim_open_win(buf, true, {
			anchor = "SW",
			border = "rounded",
			col = 0,
			focusable = false,
			height = 30,
			relative = "win",
			row = -1,
			width = qfwin.width,
			noautocmd = true,
			zindex = 52,
		})
	end

	vim.cmd.edit(file) -- Open the file in the preview window
	vim.cmd("normal! " .. entry.lnum .. "Gzz") -- Center the line in the preview window

	local title = string.format("[ %d/%d ] %s", line, qf.size, vim.fs.get_relative_path(file))
	vim.api.nvim_win_set_config(preview_winid, { title = title })
	vim.api.nvim_set_option_value("winhighlight", "", { win = preview_winid })
	vim.api.nvim_set_option_value("previewwindow", true, { win = preview_winid })
	vim.api.nvim_set_option_value("foldenable", false, { win = preview_winid })
	vim.api.nvim_set_option_value("relativenumber", false, { win = preview_winid })
end

local function preview_file()
	open_preview()
	vim.cmd.wincmd("p") -- go back to qf window
end

local mappings = {
	select = function(direction)
		return function()
			-- Don't go out of bounds.
			local line = vim.fn.line(".")
			if (line == 1 and direction == "previous") or (line == vim.fn.line("$") and direction == "next") then
				return
			end

			local key = direction == "next" and "j" or "k"
			vim.cmd("normal! " .. key) -- Move to next/previous line

			preview_file()
		end
	end,
	open = function()
		return function()
			-- Close before opening the file, so it doesn't open in the preview window
			close_preview_window()
			vim.cmd("cc")
			vim.cmd.cclose()
		end
	end,
}

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "qf",
	callback = function(event)
		local k = vim.keymap.set
		local opts = { buffer = event.buf }

		preview_winid = nil -- Reset preview window id

		-- Highlight current line (selected entry)
		vim.api.nvim_win_set_hl_ns(0, ns)
		vim.api.nvim_set_hl(ns, "CursorLine", { bg = _G.NordStoneColors.nord3 })

		-- Open preview window for the first entry in the quickfix list
		if vim.fn.getqflist({ size = 1 }).size > 0 then
			vim.defer_fn(preview_file, 10)
		end

		k("n", "<cr>", mappings.open(), opts)

		k("n", "<c-p>", vim.cmd.colder, opts) -- Open previous list.
		k("n", "<c-n>", vim.cmd.cnewer, opts) -- Open next list.

		-- Preview the file under the cursor in the preview window.
		for _, key in pairs({ "j", "<down>", "]q" }) do
			k("n", key, mappings.select("next"), opts)
		end
		for _, key in pairs({ "k", "<up>", "[q" }) do
			k("n", key, mappings.select("previous"), opts)
		end

		-- Use numbers to open the first 9 buffers
		local size = vim.fn.getqflist({ size = 1 }).size
		for i = 1, math.max(size, 9) do
			k("n", tostring(i), ":cc " .. i .. "<cr>:cclose<cr>", opts)
		end

		-- Search and replace on Quickfix files.
		-- https://github.com/theHamsta/dotfiles/blob/master/.config/nvim/ftplugin/qf.lua
		vim.cmd.packadd("cfilter") -- Install package to filter entries.
		k("n", "<leader>r", function()
			local fk = vim.api.nvim_feedkeys
			local tc = vim.api.nvim_replace_termcodes
			local listdo = vim.fn.getloclist(0, { winid = 0 }).winid == 0 and "cdo" or "ldo"
			-- :cdo s//<left><left>
			local cmd = ":" .. listdo .. " s//g<left><left>"
			fk(tc(cmd, true, false, true), "n", false)
		end, opts)

		vim.api.nvim_create_autocmd("WinClosed", {
			group = augroup,
			buffer = event.buf,
			callback = function()
				-- Always close the preview window when leaving the Quickfix window
				close_preview_window()
			end,
		})
	end,
})
