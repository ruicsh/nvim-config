-- Terminal buffers

local T = require("lib")

local augroup = vim.api.nvim_create_augroup("ruicsh/filetypes/terminal", { clear = true })

-- Pick a `path:line[:col]` printed by the tool running in the terminal.
local function open_refs()
	local items = T.file_refs.collect(0)

	if #items == 0 then
		vim.notify("No file references in terminal buffer", vim.log.levels.INFO)
		return
	end

	require("snacks").picker("file_refs", { items = items })
end

vim.api.nvim_create_autocmd("TermOpen", {
	group = augroup,
	callback = function()
		vim.opt_local.signcolumn = "yes" -- Shows left padding on the window

		-- opencode uses <esc> to cancel actions, map it when not in a sidekick terminal
		if vim.bo.filetype ~= "sidekick_terminal" then
			vim.keymap.set("t", "<c-[>", [[<c-\><c-n>]], { desc = "Exit terminal mode", buffer = true })
		end

		vim.keymap.set({ "n", "t" }, "<c-g>", open_refs, { buffer = true, desc = "Open file reference" })
	end,
})
