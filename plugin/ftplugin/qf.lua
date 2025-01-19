-- Quickfix.

local augroup = vim.api.nvim_create_augroup("ruicsh/ftplugin/qf", { clear = true })

-- hold the window id for the preview window
local preview_window = nil

local function open_preview()
	local line = vim.fn.line(".")
	local qf_items = vim.fn.getqflist()
	local entry = qf_items[line]
	local file = vim.api.nvim_buf_get_name(entry.bufnr)
	local lnum = entry.lnum

	if not preview_window then
		local buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })

		local qfwinid = vim.fn.getqflist({ winid = 0 }).winid
		local qfwin = vim.fn.getwininfo(qfwinid)[1]

		local config = {
			anchor = "SW",
			border = "rounded",
			col = 0,
			focusable = false,
			height = vim.api.nvim_get_option_value("previewheight", { scope = "global" }),
			relative = "win",
			row = -1,
			width = qfwin.width,
			noautocmd = true,
			zindex = 52,
		}
		preview_window = vim.api.nvim_open_win(buf, true, config)
	else
		vim.api.nvim_set_current_win(preview_window) -- Focus the preview window
	end

	vim.cmd.edit(file) -- Open the file in the preview window
	vim.api.nvim_win_set_cursor(0, { lnum, 0 }) -- Move to the specific line
	vim.api.nvim_win_set_config(preview_window, {
		title = file,
	})
	vim.api.nvim_set_option_value("winhighlight", "", { win = preview_window })

	vim.api.nvim_create_autocmd({ "WinClosed" }, {
		group = augroup,
		buffer = vim.api.nvim_get_current_buf(),
		callback = function()
			preview_window = nil
		end,
	})
end

local function close_preview_window()
	if preview_window then
		vim.api.nvim_win_close(preview_window, true)
	end
end

local function preview_file()
	open_preview()
	vim.cmd.wincmd("p") -- go back to qf window
end

local function restore_highlight_on_entered_window()
	local qf = vim.fn.getqflist({ items = 1, idx = 0 })
	local active = qf.items[qf.idx]

	local wins = vim.api.nvim_list_wins()
	for _, win in ipairs(wins) do
		local bufnr = vim.api.nvim_win_get_buf(win)
		if bufnr == active.bufnr then
			vim.api.nvim_set_option_value("winhighlight", "", { win = win })
			return
		end
	end
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
			vim.cmd("normal! " .. key) -- move to next/previous line

			preview_file()
		end
	end,
	open = function()
		return function()
			close_preview_window() -- close before opening the file, so it doesn't open in the preview window
			local line = vim.fn.line(".") -- get the current line
			vim.cmd("cc " .. line)
			vim.cmd.cclose()
		end
	end,
}

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "qf",
	callback = function(event)
		if vim.g.is_quickfix_open then
			return
		end

		vim.g.is_quickfix_open = true -- signal that the quickfix window is open

		vim.wo.spell = false
		vim.wo.relativenumber = false
		vim.wo.statusline = "%!v:lua._G.status_line_qf()"
		vim.wo.cursorline = true

		local k = vim.keymap.set
		local opts = { buffer = event.buf, silent = true }

		k("n", "<cr>", mappings.open(), opts)

		k("n", "<c-p>", ":colder<cr>", opts) -- Open previous list.
		k("n", "<c-n>", ":cnewer<cr>", opts) -- Open next list.

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

		-- Search and replace on quickfix files.
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

		-- Remove quickfix entry.
		-- https://github.com/famiu/dot-nvim/blob/master/ftplugin/qf.lua
		vim.keymap.set("n", "dd", function()
			local line = vim.api.nvim_win_get_cursor(0)[1]
			local qflist = vim.fn.getqflist()
			-- Remove line from qflist.
			table.remove(qflist, line)
			vim.fn.setqflist(qflist, "r")
			-- Restore cursor position.
			local max_lines = vim.api.nvim_buf_line_count(0)
			vim.api.nvim_win_set_cursor(0, { math.min(line, max_lines), 0 })
		end, opts)

		vim.api.nvim_create_autocmd({ "BufHidden" }, {
			group = augroup,
			buffer = event.buf,
			callback = function()
				-- Always close the preview window when leaving the quickfix window
				close_preview_window()
				-- Because thq quickfix window is active the dim window events are paused
				restore_highlight_on_entered_window()

				vim.g.is_quickfix_open = false
			end,
		})
	end,
})
