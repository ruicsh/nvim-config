-- Options organized by sections on :options

local o = vim.opt

-- 2 moving around, searching and patterns {{{
o.jumpoptions = { "stack" } -- https://www.reddit.com/r/neovim/comments/16nead7/comment/k1e1nj5/?context=3
o.ignorecase = true -- Ignore case on search patterns.
o.inccommand = "nosplit" -- Show live preview of substitution.
o.path:append("**") -- Enable searching for files on subdirectories.
o.smartcase = true -- Use case sensitive if keyword contains capital letters.
o.startofline = true -- Move cursor to the first non-blank character.
-- }}}

-- 3 tags {{{
o.tagstack = true -- Enable tagstack.
-- }}}

-- 4 displaying text {{{
o.cmdheight = 1 -- Show command line on 1 line.
o.fillchars = {
	eob = " ", -- End of buffer marker.
	diff = vim.fn.is_windows() and "╱" or "⣿", -- Diffview deleted lines marker.
	foldopen = "", -- Beggining of a fold.
	foldclose = "", -- Closed fold.
	fold = " ", -- Filling foldtext.
	foldsep = " ", -- Open fold middle marker
}
o.number = true -- Show line numbers.
o.numberwidth = 5 -- More space on the gutter column.
o.relativenumber = true -- Show relative line numbers.
o.scrolloff = math.floor(vim.fn.winheight(0) / 2) -- Always center the current line.
o.sidescrolloff = 10 -- Number of columns to keep left/right of the cursor.
o.wrap = false -- Do not automatically wrap texts.
-- }}}

-- 5 syntax, highlighting and spelling {{{
o.cursorline = true -- Highlight current line.
o.termguicolors = true -- Enable true colors.
-- }}}

-- 6 multiple windows {{{
o.laststatus = 3 -- Always show global statusline.
o.splitbelow = true -- Open a new horizontal split below.
o.splitright = true -- Open a new vertical split to the right.
o.statusline = "%!v:lua._G.status_line()" -- statusline format
-- }}}

-- 7 multiple tab pages {{{
o.showtabline = 0 -- Never show tabline (tabs are shown on the statusline).
-- }}}

-- 8 terminal {{{
o.title = true -- Show info in the window title
o.titlelen = 0 -- No limit on title length
o.titlestring = "%f" -- Show relative path in terminal title
-- }}}

-- 9 using the mouse {{{
o.mouse = "nic" -- Don't enable mouse on Visual mode.
o.mousescroll = "ver:1,hor:0" -- Disable horizonal scroll.
-- }}}

-- 10 messages and info {{{
o.belloff = "all" -- Do not ring the bell for any event.
o.report = 9999 -- Don't report number of changed lines.
o.ruler = false -- Do not show the line and column number of the cursor position.
o.shortmess:append({ -- Don't show messages:
	A = true, -- When a swap file is found.
	C = true, -- When scanning for ins-completion items.
	F = true, -- File info when editing a file.
	I = true, -- Skip intro message.
	S = true, -- Search messages, using nvim-hlslens instead.
	W = true, -- When writing a file.
	a = true, -- use abbreviations
	c = true, -- ins-completion-menu messages.
	s = true, -- Search hit BOTTOM/TOP messages.
})
o.showcmd = false -- Do not show command on last line.
o.showmode = false -- Do not show mode on last line.
-- }}}

-- 11 selecting text {{{
o.clipboard = "unnamedplus" -- Use system clipboard.
-- }}}

-- 12 editing text {{{
o.complete = ".,t" -- How keyword completion works.
o.completeopt = "menu,menuone,noinsert,preview" -- Disable native autocompletion (using nvim-cmp).
o.pumblend = 5 -- Opaque completion menu background.
o.pumheight = 5 -- Maximum height of popup menu.
o.showmatch = false -- Do not jump to matching brackets.
o.undofile = true -- Automatically save and restore undo history.
-- }}}

-- 13 tabs and editing {{{
o.expandtab = true -- In insert mode, use the correct number of spaces to insert a tab.
o.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent.
o.smartindent = true -- Smart indent.
o.softtabstop = 2 -- Number of spaces that a <Tab> key in the file counts for.
o.tabstop = 2 -- Number of spaces that a <Tab> in the file counts for.
-- }}}

-- 14 folding {{{
o.foldenable = true -- Enable folding.
o.foldcolumn = "1" -- Show folding signs.
o.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Use treesitter for folding.
o.foldlevel = 0 -- Close all folds.
o.foldlevelstart = 0 -- Start with all folds closed.
o.foldmethod = "expr" -- Use expr to determine fold level.
o.foldopen = "" -- Which commands open folds if the cursor moves into a closed fold.
o.foldtext = "v:lua.custom_fold_text()" -- What to display on fold
-- }}}

-- 15 diff mode {{{
o.diffopt = "filler,internal,closeoff,algorithm:histogram,context:5,linematch:60"
-- }}}

-- 16 mapping {{{
o.timeout = true -- Wait for mapped key sequence to be received
o.timeoutlen = 350 -- Don't wait 1sec for a possible new key
-- }}}

-- 17 reading and writing files {{{
o.backup = false -- Do not create backup files.
-- }}}

-- 18 the swap file {{{
o.swapfile = false -- Stop creating swp files.
o.updatetime = 250 -- Time in milliseconds to wait for CursorHold event.
-- }}}

-- 19 command line editing {{{
o.wildignore:append({ -- Ignore on file name completion.
	".DS_store",
	"**/node_modules/**",
})
-- }}}

-- 24 various {{{
o.conceallevel = 0 -- Text is shown normally.
o.gdefault = true -- Use g flag for ":substitute".
o.shada = {
	'"50', -- Max number of lines saved for each register.
	"'50", -- Remember marks for the last 10 edited files.
	"/50", -- Max number of items in the search pattern.
	":50", -- Max number of items in the command-line history.
	"<50", -- Max number of lines saved for each register.
	"@50", -- Max number of items in the input-line history.
	"f1", -- Save all file marks
	"h", -- Disable the effect of hlsearch when loading the shada file.
}
-- https://www.reddit.com/r/neovim/comments/1hkpgar/a_per_project_shadafile/
o.shadafile = (function() -- Per project shadafile
	local data = tostring(vim.fn.stdpath("data"))
	local cwd = vim.git.root() or vim.fn.getcwd()
	local cwd_b64 = vim.base64.encode(cwd)
	local file = vim.fs.joinpath(data, "project_shada", cwd_b64)
	vim.fn.mkdir(vim.fs.dirname(file), "p")
	return file
end)()
o.signcolumn = "yes" -- Always showed to prevent the screen from jumping.
o.viewoptions = "cursor,folds" -- Save cursor position and folds.
o.winborder = "single" -- Use single border for floating windows.
-- }}}
