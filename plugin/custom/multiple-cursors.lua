-- Multiple Cursors
-- http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
-- https://github.com/akinsho/dotfiles/blob/main/.config/nvim/plugin/mappings.lua

local function k(mode, lhs, rhs, opts)
	local options = vim.tbl_extend("force", { noremap = true, unique = true }, opts or {})
	vim.keymap.set(mode, lhs, rhs, options)
end

-- 1. Position the cursor anywhere in the word you wish to change;
-- 2. Or, visually make a selection;
-- 3. Hit cn, type the new word, then go back to Normal mode;
-- 4. Hit `.` n-1 times, where n is the number of replacements.
k("n", "cn", "*``cgn", { desc = "Change multiple words (forward)" })
k("n", "cN", "*``cgN", { desc = "Change multiple words (backward)" })
k("x", "cn", [[g:mc . "``cgn"]], { expr = true, desc = "Change multiple selection (forward)" })
k("x", "cN", [[g:mc . "``cgN"]], { expr = true, desc = "Change multiple selection (backward)" })

-- 1. Position the cursor over a word; alternatively, make a selection.
-- 2. Hit cq to start recording the macro.
-- 3. Once you are done with the macro, go back to normal mode.
-- 4. Hit Enter to repeat the macro over search matches.
function SetupMultipleCursors()
	vim.keymap.set(
		"n",
		"<cr>",
		[[:nnoremap <lt>Enter> n@z<CR>q:<C-u>let @z=strpart(@z,0,strlen(@z)-1)<CR>n@z]],
		{ remap = true }
	)
end

k("n", "cq", [[:\<C-u>call v:lua.SetupMultipleCursors()<cr>*``qz]])
k("n", "cQ", [[:\<C-u>call v:lua.SetupMultipleCursors()<cr>*``qz]])
k("x", "cq", [[":\<C-u>call v:lua.SetupMultipleCursors()<CR>gv" . g:mc . "``qz"]])
k(
	"x",
	"cQ",
	[[":\<C-u>call v:lua.SetupMultipleCursors()<CR>gv" . substitute(g:mc, '/', '?', 'g') . "``qz"]],
	{ expr = true }
)
