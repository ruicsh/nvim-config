-- Options organized by sections on :options

local o = vim.opt

-- 2 moving around, searching and patterns {{{
o.jumpoptions = { -- `:h 'jumpoptions'`
	"stack", -- https://www.reddit.com/r/neovim/comments/16nead7/comment/k1e1nj5/?context=3
	"view", -- https://www.reddit.com/r/neovim/comments/1kfcrfx/how_can_lazyvim_mark_also_save_the_scroll_position/
}
o.ignorecase = true -- Ignore case on search patterns. `:h 'ignorecase'`
o.inccommand = "nosplit" -- Show live preview of substitution. `:h 'inccommand'`
o.path:append("**") -- Enable searching for files on subdirectories. `:h 'path'`
o.smartcase = true -- Use case-sensitive if keyword contains capital letters. `:h 'smartcase'`
o.startofline = true -- Move cursor to the first non-blank character. `:h 'startofline'`
o.whichwrap = "b,s,<,>,[,]" -- Move cursor left/right to move to previous/next lines `:h 'whichwrap'`
-- }}}

-- 3 tags {{{
o.tagstack = true -- Enable tagstack. `:h 'tagstack'`
-- }}}

-- 4 displaying text {{{
o.breakindent = true -- Wrapped lines will continue visually indented `:h 'breakindent'`
o.cmdheight = 1 -- Show command line on 1 line. `:h 'cmdheight'`
o.fillchars = { -- `:h 'fillchars'`
	diff = " ", -- Diff deleted lines marker.
	eob = " ", -- End of buffer marker.
	fold = " ", -- Filling foldtext.
	foldclose = "", -- Closed fold.
	foldopen = "", -- Beggining of a fold.
	foldsep = " ", -- Open fold middle marker
}
o.lazyredraw = true -- Don't redraw when executing macros. `:h 'lazyredraw'`
o.messagesopt = "wait:500,history:1000" -- Option settings for outputting messages. `:h 'messagesopt'`
o.number = true -- Show line numbers. `:h 'number'`
o.numberwidth = 5 -- More space on the gutter column. `:h 'numberwidth'`
o.relativenumber = true -- Show relative line numbers. `:h 'relativenumber'`
o.scrolloff = 5 -- Number of lines to keep above/below the cursor. `:h 'scrolloff'`
o.sidescrolloff = 10 -- Number of columns to keep left/right of the cursor. `:h 'sidescrolloff'`
o.wrap = false -- Do not automatically wrap texts. `:h 'wrap'`
-- }}}

-- 5 syntax, highlighting and spelling {{{
o.cursorline = true -- Highlight current line.`:h 'cursorline'`
o.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add" -- Custom spellfile. `:h 'spellfile'`
o.termguicolors = true -- Enable true colours. `:h 'termguicolors'`
-- }}}

-- 6 multiple windows {{{
o.equalalways = false -- Do not resize windows when opening a new one. `:h 'equalalways'`
o.laststatus = 3 -- Always show global statusline. `:h 'laststatus'`
o.splitbelow = true -- Open a new horizontal split below. `:h 'splitbelow'`
o.splitright = true -- Open a new vertical split to the right. `:h 'splitright'`
o.statusline = "%!v:lua._G.status_line()" -- statusline format `h 'statusline'`
-- }}}

-- 7 multiple tab pages {{{
o.showtabline = 0 -- Never show tabline (tabs are shown on the statusline). `:h 'showtabline'`
o.tabclose = "uselast" -- Close tab and go to last used tab. `:h 'tabclose'`
-- }}}

-- 8 terminal {{{
o.title = false -- Show info in the window title. `:h 'title'`
o.titlelen = 1 -- No limit on title length. `:h 'titlelen'`
o.titlestring = "" -- Show relative path in terminal title. `:h 'titlestring'`
-- }}}

-- 9 using the mouse {{{
o.mouse = "nic" -- Don't enable mouse on Visual mode. `:h 'mouse'`
o.mousescroll = "ver:1,hor:0" -- Disable horizonal scroll. `:h 'mousescroll'`
-- }}}

-- 10 messages and info {{{
o.belloff = "all" -- Do not ring the bell for any event. `:h 'belloff'`
o.report = 9999 -- Don't report number of changed lines. `:h 'report'`
o.ruler = false -- Do not show the line and column number of the cursor position. `:h 'ruler'`
o.shortmess:append({ -- Don't show messages: `h 'shortmess'`
	A = true, -- When a swap file is found.
	C = true, -- When scanning for `ins-completion` items.
	F = true, -- File info when editing a file.
	I = true, -- Skip intro message.
	S = true, -- Search messages, using nvim-hlslens instead.
	W = true, -- When writing a file.
	a = true, -- Use abbreviations
	c = true, -- 'ins-completion-menu' messages.
	s = true, -- Search hit BOTTOM/TOP messages.
})
o.showcmd = false -- Do not show command on last line. `:h 'showcmd'`
o.showmode = false -- Do not show mode on last line. `:h 'showmode'`
-- }}}

-- 11 selecting text {{{
vim.schedule(function() -- Schedule the setting after `UiEnter` because it can increase startup-time.
	o.clipboard = "unnamedplus" -- Use system clipboard. `:h 'clipboard'`
end)
-- }}}

-- 12 editing text {{{
o.complete = ".,]" -- How keyword completion works. `h 'complete'`
o.completeopt = "menu,menuone,noinsert,preview" -- Disable native autocompletion (using nvim-cmp). `:h 'completeopt'`
o.pumblend = 5 -- Opaque completion menu background. `h 'pumblend'`
o.pumheight = 5 -- Maximum height of pop-up menu. `:h 'pumheight'`
o.showmatch = false -- Do not jump to matching brackets. `:h 'showmatch'`
o.undofile = true -- Automatically save and restore undo history. `:h 'undofile'`
-- }}}

-- 13 tabs and editing {{{
o.expandtab = true -- In insert mode, use the correct number of spaces to insert a tab. `:h 'expandtab'`
o.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent. `:h 'shiftwidth'`
o.smartindent = true -- Smart indent. `:h 'smartindent'`
o.softtabstop = 2 -- Number of spaces that a <Tab> key in the file counts for. `:h 'softtabstop'`
o.tabstop = 2 -- Number of spaces that a <Tab> in the file counts for. `:h 'tabstop'`
-- }}}

-- 14 folding {{{
o.foldcolumn = "1" -- Show folding signs. `:h 'foldcolumn'`
o.foldenable = true -- Enable folding. `:h 'foldenable'`
o.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Use treesitter for folding. `:h 'foldexpr'`
o.foldlevel = 999 -- Close all folds. `:h 'foldlevel'`
o.foldlevelstart = 99 -- Start with all folds closed. `:h 'foldlevelstart'`
o.foldmethod = "indent" -- Use indent to determine fold level. `:h 'foldmethod'`
o.foldopen = "insert,mark,search,tag" -- Which commands open folds if the cursor moves into a closed fold. `:h 'foldopen'`
o.foldtext = "v:lua.custom_fold_text()" -- What to display on fold line. `:h 'foldtext'`
-- }}}

-- 15 diff mode {{{
o.diffopt = "vertical,filler,internal,closeoff,algorithm:histogram,context:5,linematch:60" -- `:h 'diffopt'`
-- }}}

-- 16 mapping {{{
o.timeout = true -- Enable mapped sequences. `:h 'timeout'`
o.timeoutlen = 500 -- Wait time for a possible new key `:h 'timeoutlen'`
o.ttimeoutlen = 10 -- Wait time for a key code sequence to complete. `:h 'ttimeoutlen'`
-- }}}

-- 17 reading and writing files {{{
o.autoread = true -- Automatically reload files changed outside of Vim. `:h 'autoread'`
o.backup = false -- Do not create backup files. `:h 'backup'`
-- }}}

-- 18 the swap file {{{
o.swapfile = false -- Stop creating swp files. `:h 'swapfile'`
-- }}}

-- 19 command line editing {{{
o.wildignore:append({ -- Ignore on filename completion. `:h 'wildignore'`
	".DS_store",
	"**/node_modules/**",
})
-- }}}

-- 24 various {{{
o.conceallevel = 0 -- Text is shown normally. `:h 'conceallevel'`
o.gdefault = true -- Use g flag for ':substitute'. `:h 'gdefault'`
o.guicursor = { -- `:h 'guicursor'`
	"n-v-c:block", -- Normal, visual, command-line: block cursor
	"i-ci-ve:ver25", -- Insert, command-line insert, visual-exclude: vertical bar cursor with 25% width
	"r-cr:hor20", -- Replace, command-line replace: horizontal bar cursor with 20% height
	"o:hor50", -- Operator-pending: horizontal bar cursor with 50% height
}
o.shada = { -- `:h 'shada'`
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
o.shadafile = (function() -- Per project shadafile `:h 'shadafile'`
	local data = tostring(vim.fn.stdpath("data"))
	local git_root = require("snacks.git").get_root()
	local cwd = git_root or vim.fn.getcwd()
	local cwd_b64 = vim.base64.encode(cwd)
	local file = vim.fs.joinpath(data, "project_shada", cwd_b64)
	vim.fn.mkdir(vim.fs.dirname(file), "p")
	return file
end)()
o.signcolumn = "yes" -- Always showed to prevent the screen from jumping. `:h 'signcolumn'`
o.viewoptions = "cursor,folds" -- Save cursor position and folds. `:h 'viewoptions'`
o.winborder = "rounded" -- Use rounded borders for floating windows. `:h 'winborder'`
-- }}}

-- vim: foldmethod=marker:foldmarker={{{,}}}:foldlevel=0
