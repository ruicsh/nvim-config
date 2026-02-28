-- Options organized by sections on :options

local o = vim.opt

-- 2 moving around, searching and patterns {{{
o.jumpoptions = { -- `:h 'jumpoptions'`
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
	foldclose = "›", -- Closed fold.
	foldopen = "", -- Opened fold.
	foldsep = " ", -- Open fold middle marker
}
o.messagesopt = "wait:500,history:1000" -- Option settings for outputting messages. `:h 'messagesopt'`
o.number = true -- Show line numbers. `:h 'number'`
o.numberwidth = 5 -- More space on the gutter column. `:h 'numberwidth'`
o.relativenumber = true -- Show relative line numbers. `:h 'relativenumber'`
o.scrolloff = 5 -- Number of lines to keep above/below the cursor. `:h 'scrolloff'`
o.sidescrolloff = 10 -- Number of columns to keep left/right of the cursor. `:h 'sidescrolloff'`
o.wrap = false -- Do not automatically wrap texts. `:h 'wrap'`
-- }}}

-- 5 syntax, highlighting, and spelling {{{
o.cursorline = true -- Highlight current line.`:h 'cursorline'`
o.cursorlineopt = "screenline,number" -- Highlight the screen line and line number. `:h 'cursorlineopt'`
o.hlsearch = true -- Highlight search matches. `:h 'hlsearch'`
o.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add" -- Custom spellfile. `:h 'spellfile'`
o.spelloptions = "camel" -- Recognize camel case words. `:h 'spelloptions'`
-- }}}

-- 6 multiple windows {{{
o.equalalways = false -- Do not resize windows when opening a new one. `:h 'equalalways'`
o.laststatus = 3 -- Always show global statusline. `:h 'laststatus'`
o.splitbelow = true -- Open a new horizontal split below. `:h 'splitbelow'`
o.splitkeep = "cursor" -- Keep text on the same screen line when splitting. `:h 'splitkeep'`
o.splitright = true -- Open a new vertical split to the right. `:h 'splitright'`
o.statusline = "%!v:lua._G.statusline()" -- statusline format `h 'statusline'`
o.winbar = "%!v:lua._G.winbar()" -- winbar format `h 'winbar'`
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

-- Use `win32yank.exe` on Windows
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
	vim.g.clipboard = {
		name = "win32yank-wsl",
		copy = {
			["+"] = "win32yank.exe -i --crlf",
			["*"] = "win32yank.exe -i --crlf",
		},
		paste = {
			["+"] = "win32yank.exe -o --lf",
			["*"] = "win32yank.exe -o --lf",
		},
		cache_enabled = 1,
	}
-- Use xclip on WSL `:h clipboard-wsl`
elseif vim.fn.getenv("WSL_DISTRO_NAME") ~= vim.NIL or vim.fn.getenv("WSL_INTEROP") ~= vim.NIL then
	vim.g.clipboard = {
		name = "xclip",
		copy = {
			["+"] = "xclip -selection clipboard",
			["*"] = "xclip -selection primary",
		},
		paste = {
			["+"] = "xclip -selection clipboard -o",
			["*"] = "xclip -selection primary -o",
		},
		cache_enabled = 1,
	}
end

o.clipboard = "unnamedplus" -- Use system clipboard. `:h 'clipboard'`
-- }}}

-- 12 editing text {{{
o.complete = ".,]" -- How keyword completion works. `h 'complete'`
o.completeopt = "menu,menuone,noinsert,preview" -- Disable native autocompletion (using nvim-cmp). `:h 'completeopt'`
o.infercase = true -- Adjust case of match for keyword completion. `:h 'infercase'`
o.formatoptions = table.concat({ -- `:h 'formatoptions'`
	"/", -- Only when // is at the start of the line. `:h fo-/`
	"1", -- Do not break a line after a one-letter word. `:h fo-1`
	"b", -- Auto-wrap comments using textwidth, but do not break lines. `:h fo-b`
	"c", -- Auto-wrap comments using textwidth. `:h fo-c`
	"j", -- Remove comment leader when joining lines. `:h fo-j`
	"n", -- Recognize numbered lists. `:h fo-n`
	"p", -- Do not break lines after a punctuation character. `:h fo-p`
	"q", -- Allow formatting of comments with `gq`. `:h fo-q`
	"t", -- Auto-wrap text using textwidth. `:h fo-t`
}, "")
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
o.foldmethod = "expr" -- Use indent to determine fold level. `:h 'foldmethod'`
o.foldopen = "insert,mark,search,tag" -- Which commands open folds if the cursor moves into a closed fold. `:h 'foldopen'`
o.foldtext = "v:lua.custom_fold_text()" -- What to display on fold line. `:h 'foldtext'`
-- }}}

-- 15 diff mode {{{
o.diffopt = { -- `:h 'diffopt'`
	"algorithm:histogram", -- Better algorithm for diffs.
	"closeoff", -- Close a diff window when it's the only window in the tab.
	"context:5", -- Number of context lines.
	"filler", -- Show filler lines to keep text aligned.
	"indent-heuristic", -- Better indent matching.
	"internal", -- Use internal diff library.
	"linematch:60", -- Better line matching.
	"vertical", -- Show diffs in vertical splits.
}
-- }}}

-- 16 mapping {{{
o.timeout = true -- Enable mapped sequences. `:h 'timeout'`
o.timeoutlen = 500 -- Wait time for a possible new key `:h 'timeoutlen'`
o.ttimeoutlen = 50 -- Wait time for a key code sequence to complete. `:h 'ttimeoutlen'`
-- }}}

-- 17 reading and writing files {{{
o.autoread = true -- Automatically reload files changed outside of Vim. `:h 'autoread'`
o.backup = false -- Do not create backup files. `:h 'backup'`
-- }}}

-- 18 the swap file {{{
o.swapfile = false -- Stop creating swp files. `:h 'swapfile'`
o.updatetime = 100 -- Faster CursorHold. `:h 'updatetime'`
-- }}}

-- 19 command line editing {{{
o.cedit = "<c-F>" -- Key to enter command-line window. `:h 'cedit'`
o.history = 200 -- Number of command and search history to keep. `:h 'history'`
o.wildignore:append({ -- Ignore on filename completion. `:h 'wildignore'`
	".DS_store",
	"**/node_modules/**",
})
-- }}}

-- 20 executing external commands {{{
local nu_path = vim.fn.exepath("nu")
if nu_path ~= "" then
	o.shell = nu_path -- Resolves to full path if "nushell" is in $PATH
end
-- }}}

-- 22 language specific {{{
o.iskeyword = "@,48-57,_,192-255,-" -- Treat dash as `word` textobject part. `:h 'iskeyword'`
-- }}}

-- 24 various {{{
o.conceallevel = 0 -- Text is shown normally. `:h 'conceallevel'`
o.exrc = false -- Disable project-local config files (use .nvim.env). `:h 'exrc'`
o.gdefault = true -- Use g flag for ':substitute'. `:h 'gdefault'`
o.guicursor = { -- `:h 'guicursor'`
	"n-v-c:block", -- Normal, visual, command-line: block cursor
	"i-ci-ve:ver25", -- Insert, command-line insert, visual-exclude: vertical bar cursor with 25% width
	"r-cr:hor20", -- Replace, command-line replace: horizontal bar cursor with 20% height
	"o:hor50", -- Operator-pending: horizontal bar cursor with 50% height
}
o.sessionoptions = { -- `:h 'sessionoptions'`
	"buffers", -- Save all buffers.
	"curdir", -- Save current directory.
	"folds", -- Save folds.
	"globals", -- Save global variables.
	"tabpages", -- Save tab pages.
	"winpos", -- Save window positions.
	"winsize", -- Save window sizes.
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
	local git_root = vim.fs.root(0, ".git")
	local cwd = git_root or vim.fn.getcwd()
	local cwd_b64 = vim.base64.encode(cwd)
	local file = vim.fs.joinpath(data, "project_shada", cwd_b64)
	vim.fn.mkdir(vim.fs.dirname(file), "p")
	return file
end)()
o.signcolumn = "yes" -- Always showed to prevent the screen from jumping. `:h 'signcolumn'`
o.winborder = "rounded" -- Use rounded borders for floating windows. `:h 'winborder'`
-- }}}

-- vim: foldmethod=marker:foldmarker={{{,}}}:foldlevel=0
