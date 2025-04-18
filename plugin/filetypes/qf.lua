-- Quickfix.

local augroup = vim.api.nvim_create_augroup("ruicsh/filetypes/qf", { clear = true })

-- Hold the window id for the preview window
local preview_winid = nil

local function close_preview_window()
	if preview_winid then
		if not vim.api.nvim_win_is_valid(preview_winid) then
			preview_winid = nil
		else
			vim.api.nvim_win_close(preview_winid, true)
		end
	end
end

local function open_preview()
	local line = vim.fn.line(".")
	local qf = vim.fn.getqflist({ items = 0, size = 1 })
	local entry = qf.items[line]
	local file = vim.api.nvim_buf_get_name(entry.bufnr)
	local lnum = entry.lnum

	if preview_winid and vim.api.nvim_win_is_valid(preview_winid) then
		vim.api.nvim_set_current_win(preview_winid)
	else
		local buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })

		local qfwinid = vim.fn.getqflist({ winid = 0 }).winid
		local qfwin = vim.fn.getwininfo(qfwinid)[1]

		local config = {
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
		}
		preview_winid = vim.api.nvim_open_win(buf, true, config)
	end

	vim.cmd.edit(file) -- Open the file in the preview window
	vim.api.nvim_win_set_cursor(0, { lnum, 0 }) -- Move to the specific line
	vim.cmd("normal! zz") -- Center the line in the preview window

	local title = string.format("[ %d/%d ] %s", line, qf.size, vim.fs.get_relative_path(file))
	vim.api.nvim_win_set_config(preview_winid, {
		title = title,
	})
	vim.api.nvim_set_option_value("winhighlight", "", { win = preview_winid })
	vim.api.nvim_set_option_value("previewwindow", true, { win = preview_winid })
	vim.api.nvim_set_option_value("foldenable", false, { win = preview_winid })

	local bufnr = vim.api.nvim_get_current_buf()

	vim.api.nvim_create_autocmd({ "WinClosed" }, {
		group = augroup,
		buffer = bufnr,
		callback = function()
			preview_winid = nil
		end,
	})
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
			close_preview_window() -- Close before opening the file, so it doesn't open in the preview window
			local line = vim.fn.line(".") -- Get the current line
			vim.cmd("cc " .. line)
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

		k("n", "<cr>", mappings.open(), opts)

		k("n", "<c-p>", vim.cmd.colder, opts) -- Open previous list.
		k("n", "<c-n>", vim.cmd.cnewer, opts) -- Open next list.

		-- Preview the file under the cursor in the preview window.
		for _, key in pairs({ "<c-j>", "<down>", "]q" }) do
			k("n", key, mappings.select("next"), opts)
		end
		for _, key in pairs({ "<c-k>", "<up>", "[q" }) do
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

		vim.api.nvim_create_autocmd({ "BufHidden" }, {
			group = augroup,
			buffer = event.buf,
			callback = function()
				-- Always close the preview window when leaving the Quickfix window
				close_preview_window()
			end,
		})
	end,
})
