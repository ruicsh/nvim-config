-- Visual mode keymaps `:h visual-index`

local T = require("lib")

-- Setup {{{
--
local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { unique = true }, opts or {})
	vim.keymap.set("x", lhs, rhs, options)
end

-- Remove any delay for these keys
local disable_keys = { "<space>", "<leader>", "s" }
for _, key in ipairs(disable_keys) do
	k(key, "<nop>", { unique = false })
end
--
-- }}}

-- Navigation {{{
--
-- More deterministic short distance jumps
-- https://nanotipsforvim.prose.sh/vertical-navigation-%E2%80%93-without-relative-line-numbers
k("{", "6k")
k("}", "6j")

-- Use visual lines. `:h gk`
k("k", [[ v:count > 0 ? 'k' : 'gk' ]], { expr = true })
k("j", [[ v:count > 0 ? 'j' : 'gj' ]], { expr = true })

--
-- }}}

-- Editing {{{
--
k("Y", "y$") -- Make Y behave like normal mode

-- Save file
k("<c-s>", "<cmd>silent! update | redraw<cr>", { desc = "Save" })

-- Indent/dedent selection
k(">", ">gv") -- Reselect after indent
k("<", "<gv") -- Reselect after dedent

-- http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
local function replace_selection(direction)
	vim.g.mc = vim.api.nvim_replace_termcodes("y/\\V<c-r>=escape(@\", '/')<cr><cr>", true, true, true)
	return function()
		return vim.g.mc .. "``cg" .. direction
	end
end
k("cn", replace_selection("n"), { expr = true, desc = "Change selection (forward)" })
k("cN", replace_selection("N"), { expr = true, desc = "Change selection (backward)" })

-- Same behaviour for `I`/`A` as in normal mode
-- https://www.reddit.com/r/neovim/comments/1k4efz8/comment/moelhto/
k("<s-i>", function()
	return vim.fn.mode() == "V" and "^<c-v><s-i>" or "<s-i>"
end, { expr = true })
k("<s-a>", function()
	return vim.fn.mode() == "V" and "$<c-v><s-a>" or "<s-a>"
end, { expr = true })

-- Repeat last change across visual selection
k(".", "<cmd>normal .<cr>", { desc = "Repeat last change" }) -- `:h .`

--
-- }}}

-- Search {{{
--
-- Search current selection
k("g/", function()
	local selection = vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"), { type = vim.fn.mode() })
	local text = vim.trim(table.concat(selection, " "))
	local escaped = vim.fn.escape(text, [[\/.*$^~[]])
	return "<esc>/" .. escaped .. "<cr>N"
end, { desc = "Search selection", expr = true })

-- Search current selection in the workspace
k("<leader>g/", require("snacks.picker").grep_word, { desc = "Search selection in workspace" })

-- Search inside visual selection
k("/", "<esc>/\\%V", { desc = "Search inside selection" }) -- `:h /\%V`

-- Web search selection
k("gw/", function()
	local selection = vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"), { type = vim.fn.mode() })
	local query = vim.trim(table.concat(selection, " "))
	local encoded = T.fn.urlencode(query)
	local url = ("https://google.com/search?q=%s"):format(encoded)
	vim.cmd("Browse " .. url)
	vim.api.nvim_input("<esc>")
end)

-- Replace selection
k("gr/", '"hy:%s/\\<<c-r>h\\>//g<left><left>', { desc = "Replace selection" })
--
-- }}}

-- vim: foldmethod=marker:foldmarker={{{,}}}:foldlevel=0
