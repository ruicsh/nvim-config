-- Command mode keymaps

local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { noremap = true, unique = true }, opts or {})
	vim.keymap.set("c", lhs, rhs, options)
end

-- Use <c-f> to open the commend line window and edit the command `:h c_CTRL-f`

-- Navigate through search matches without leaving command mode
k("<c-n>", "<c-g>") -- `:h c_ctrl-g`
k("<c-p>", "<c-t>") -- `:h c_ctrl-t`

-- Navigate within the command line
k("<c-b>", "<left>") -- Jump character backward `:h c_<Left>`
k("<c-f>", "<right>") -- Jump character forward `:h c_<Right>`
k("<a-b>", "<s-left>") -- Jump word backward `:h c_<S-Left>`
k("<a-f>", "<s-right>") -- Jump word forward `:h c_<S-Right>`
k("<c-a>", "<c-b>") -- Jump to line start `:h c_ctrl-b`
k("<c-e>", "<end>") -- Jump to line end `:h c_end`

-- Editing commands
-- k("<bs>", "<bs>") -- Delete character backward (`:h c_<BS>`)
k("<c-d>", "<del>") -- Delete character forward (`:h c_<Del>`)
-- k("<c-w>", "<c-w>") -- Delete word backward (`:h c_CTRL-W`)
k(
	"<a-d>",
	"<c-\\>estrpart(getcmdline(), 0, getcmdpos()-1)..strpart(getcmdline(), matchend(getcmdline(), '\\S\\+\\s*', getcmdpos()-1))<cr>"
) -- Delete word forward
k("<c-u>", "<c-u>") -- Delete line backward (`:h c_CTRL-U`)
k("<c-k>", "<c-\\>estrpart(getcmdline(), 0, getcmdpos()-1)<cr>") -- Delete line forward
