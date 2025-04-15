-- Folds

if vim.g.vscode then
	return
end

local augroup = vim.api.nvim_create_augroup("ruicsh/custom/folds", { clear = true })

local IGNORE_FILETYPES = {
	"DiffviewFileHistory",
	"DiffviewFiles",
	"copilot-chat",
	"diff",
	"fugitive",
	"gitcommit",
	"gitrebase",
	"help",
	"neo-tree",
	"oil",
	"qf",
	"svg",
}

local function is_ignored()
	if vim.g.vscode then
		return true
	end

	if vim.tbl_contains(IGNORE_FILETYPES, vim.bo.ft) or vim.bo.buftype ~= "" or not vim.bo.modifiable then
		return true
	end

	return false
end

-- Command to delete the saved view file
vim.api.nvim_create_user_command("ResetView", function()
	-- Get the correct view directory from Neovim's viewdir option
	-- '~=+dotfiles=+.config=+nvim=+plugin=+autocmds=+save-load-folds.lua='
	local view_dir = vim.fn.fnamemodify(vim.o.viewdir, ":p"):gsub("/$", "")
	local current_file = vim.fn.expand("%:p:~"):gsub("/", "=+")
	local view_file = view_dir .. current_file .. "="

	-- Remove existing view file if it exists
	if vim.fn.filereadable(view_file) == 1 then
		vim.fn.delete(view_file)
	end

	-- Reset all fold settings to default
	local o = vim.opt
	o.foldenable = true
	o.foldcolumn = "1"
	o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	o.foldlevel = 99
	o.foldlevelstart = 99
	o.foldmethod = "expr"
	o.foldopen = ""
	o.foldtext = "v:lua.custom_fold_text()"

	-- Create a new view
	vim.cmd("mkview")
end, {})

--- Some files have special folding rules
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	pattern = "*/plugin/options.lua",
	callback = function()
		vim.wo.foldmethod = "marker" -- Use {{{-}}} to create folds
		vim.wo.foldexpr = "" -- Disable treesitter folding
		vim.wo.foldmarker = "{{{,}}}" -- Set the fold markers
	end,
})

-- Save view when leaving buffer
vim.api.nvim_create_autocmd({ "BufWinLeave", "BufWritePost", "WinLeave" }, {
	group = augroup,
	callback = function(args)
		if is_ignored() then
			return
		end

		if vim.b[args.buf].view_activated then
			vim.cmd.mkview({ mods = { emsg_silent = true } })
		end
	end,
})

-- Load view if available and enable view saving for real files
vim.api.nvim_create_autocmd("BufWinEnter", {
	group = augroup,
	callback = function(args)
		if is_ignored() then
			return
		end

		if not vim.b[args.buf].view_activated then
			vim.b[args.buf].view_activated = true
			vim.cmd.loadview({ mods = { emsg_silent = true } })
		end
	end,
})

-- Pause folds on search
-- https://github.com/chrisgrieser/nvim-origami/blob/main/lua/origami/features/pause-folds-on-search.lua
vim.on_key(function(char)
	local key = vim.fn.keytrans(char)
	local isCmdlineSearch = vim.fn.getcmdtype():find("[/?]") ~= nil
	local isNormalMode = vim.api.nvim_get_mode().mode == "n"

	local searchStarted = (key == "/" or key == "?") and isNormalMode
	local searchConfirmed = (key == "<CR>" and isCmdlineSearch)
	local searchCancelled = (key == "<Esc>" and isCmdlineSearch)
	if not (searchStarted or searchConfirmed or searchCancelled or isNormalMode) then
		return
	end

	local foldsArePaused = not (vim.opt.foldenable:get())
	local searchMovement = vim.tbl_contains({ "n", "N", "*", "#" }, key)

	local pauseFold = (searchConfirmed or searchStarted or searchMovement) and not foldsArePaused
	local unpauseFold = foldsArePaused and (searchCancelled or not searchMovement)

	if pauseFold then
		vim.opt_local.foldenable = false
	elseif unpauseFold then
		vim.opt_local.foldenable = true
		pcall(vim.cmd.foldopen, { bang = true }) -- After closing folds, keep the *current* fold open
	end
end, ns)

local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { unique = true }, opts or {})
	vim.keymap.set("n", lhs, rhs, options)
end

-- Reset view
k(vim.fn.is_windows() and "<c-Z>" or "<c-s-z>", ":ResetView<cr>", { desc = "Folds: Reset saved view" })

-- Toggle fold
k("<tab>", function()
	local linenr = vim.fn.line(".")
	-- If there's no fold to be opened/closed, do nothing.
	if vim.fn.foldlevel(linenr) == 0 then
		return
	end

	-- Open if closed, close if open.
	local cmd = vim.fn.foldclosed(linenr) == -1 and "zc" or "zO"
	vim.cmd("normal! " .. cmd)
end, { noremap = true, silent = true, desc = "Folds: Toggle" })

-- Close all other folds
k("<s-tab>", function()
	local linenr = vim.fn.line(".")
	if vim.fn.foldlevel(linenr) == 0 then
		return "<s-tab>"
	end

	vim.cmd("normal! mt") -- Save the current position
	vim.cmd("normal! zM") -- Close all folds
	vim.cmd("normal! `t") -- Return to original position
	vim.cmd("normal! zO") -- Open all folds
	vim.cmd("delmarks t") -- Delete the mark
end, { expr = true, silent = true, desc = "Folds: Close all other" })

-- Toggle fold (one foldlevel)
k("<leader><tab>", function()
	local linenr = vim.fn.line(".")
	local current_fold_level = vim.fn.foldlevel(linenr)
	-- If there's no fold to be opened/closed, do nothing.
	if current_fold_level == 0 then
		return
	end

	-- Open fold if closed (1 level only).
	local is_open = vim.fn.foldclosed(linenr) == -1
	if not is_open then
		vim.cmd("normal! zo")
		return
	end

	-- Close all direct children folds.
	local next_line = linenr + 1
	while next_line <= vim.fn.line("$") do
		local next_foldlevel = vim.fn.foldlevel(next_line)

		if next_foldlevel < current_fold_level then
			return
		elseif next_foldlevel > current_fold_level and vim.fn.foldclosed(next_line) == -1 then
			vim.cmd(next_line .. "," .. next_line .. "foldclose")
			next_line = vim.fn.foldclosedend(next_line) + 1
		else
			next_line = next_line + 1
		end
	end
end, { silent = true, desc = "Folds: Toggle (one foldlevel)" })

-- Jump to previous fold
k("[z", function()
	local line = vim.fn.line(".")
	local currentFoldLevel = vim.fn.foldlevel(line)
	local foldStart = -1

	-- Search backward for a fold start of the same level
	for i = line - 1, 1, -1 do
		local prevLevel = vim.fn.foldlevel(i - 1)
		local thisLevel = vim.fn.foldlevel(i)

		-- Look for a position where fold level increases to the same level as current
		if thisLevel > prevLevel and thisLevel == currentFoldLevel then
			foldStart = i
			break
		end
	end

	-- Jump to the previous fold if found
	if foldStart > 0 then
		vim.api.nvim_win_set_cursor(0, { foldStart, 0 })
	end
end, { desc = "Folds: Jump to previous" })

-- Jump to next fold
k("]z", function()
	local line = vim.fn.line(".")
	local lastLine = vim.fn.line("$")
	local currentFoldLevel = vim.fn.foldlevel(line)
	local foldStart = -1

	-- Search forward for a fold start of the same level
	for i = line + 1, lastLine do
		local prevLevel = vim.fn.foldlevel(i - 1)
		local thisLevel = vim.fn.foldlevel(i)

		-- Look for a position where fold level increases to the same level as current
		if thisLevel > prevLevel and thisLevel == currentFoldLevel then
			foldStart = i
			break
		end
	end

	-- Jump to the next fold if found
	if foldStart > 0 then
		vim.api.nvim_win_set_cursor(0, { foldStart, 0 })
	end
end, { desc = "Folds: Jump to next" })
