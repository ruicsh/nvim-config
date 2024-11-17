-- Leader key
vim.g.mapleader = " " -- Set leader key to space.
vim.g.maplocalleader = " " -- Set local leader key to space.

-- App
vim.opt.backup = false -- Do not create backup files.
vim.opt.swapfile = false -- Stop creating swp files.

-- GUI
vim.opt.guifont = "JetBrainsMono Nerd Font:h12" -- Font family and size.
vim.opt.linespace = 0 -- Line height.
vim.opt.mouse = "a" -- Enable mouse support.
vim.opt.splitbelow = true -- Open a new horizontal split below.
vim.opt.splitright = true -- Open a new vertical split to the right.
vim.opt.termguicolors = true -- Enable true colors.

-- Editor
vim.opt.cursorline = true -- Highlight current line.
vim.opt.fillchars:append({ diff = "╱" }) -- Diffview deleted lines marker.
vim.opt.fillchars:append({ eob = " " }) -- End of buffer marker.
vim.opt.scrolloff = 8 -- Number of lines to keep above and below the cursor.
vim.opt.showmatch = false -- Do not show matching brackets.
vim.opt.showtabline = 2 -- Always show tabline.
vim.opt.updatetime = 250 -- Time in milliseconds to wait for CursorHold event.
vim.opt.wrap = false -- Do not automatically wrap texts.

-- Indents/tabstops
vim.opt.expandtab = true -- In insert mode, use the correct number of spaces to insert a tab.
vim.opt.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent.
vim.opt.smartindent = true -- Smart indent.
vim.opt.softtabstop = 2 -- Number of spaces that a <Tab> key in the file counts for.
vim.opt.tabstop = 2 -- Number of spaces that a <Tab> in the file counts for.

-- Search
vim.opt.ignorecase = true -- Ignore case on search patterns.
vim.opt.inccommand = "nosplit" -- Show live preview of substitution.
vim.opt.smartcase = true -- Use case sensitive if keyword contains capital letters.

-- Gutter column
vim.opt.number = true -- Show line numbers.
vim.opt.numberwidth = 5 -- More space on the gutter column.
vim.opt.relativenumber = true -- Show relative line numbers.
vim.opt.signcolumn = "yes" -- Always showe to prevent the screen from jumping.

-- Cleaner statusline
vim.opt.laststatus = 3 -- Always show global statusline.
vim.opt.ruler = false -- Do not show the line and column number of the cursor position.
vim.opt.shortmess = "AIWcCsSF" -- Don't show messages.
vim.opt.showcmd = false -- Do not show command on last line.
vim.opt.showmode = false -- Do not show mode on last line.

-- Folds
-- see: https://github.com/kevinhwang91/nvim-ufo#minimal-configuration
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.foldcolumn = "0"
vim.opt.foldnestmax = 5
vim.opt.foldtext = ""

-- Disable netrw in favor of neo-tree/oil.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Clipboard (so that yank goes to OS clipboard)
-- Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

-- [[ VSCODE ]]
if vim.g.vscode then
	-- https://stackoverflow.com/questions/78611905/turn-off-neovim-messages-in-vscode
	vim.opt.cmdheight = 1
end

-- [[ WINDOWS ]]
local OS = vim.uv.os_uname().sysname
if OS:find("Windows") then
	-- https://github.com/akinsho/toggleterm.nvim/wiki/Tips-and-Tricks#windows
	local powershell_options = {
		shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell",
		shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
		shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
		shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
		shellquote = "",
		shellxquote = "",
	}

	for option, value in pairs(powershell_options) do
		vim.opt[option] = value
	end
end

-- [[ NEOVIDE ]]
if vim.g.neovide then
	-- Turn off all animations.
	vim.g.neovide_cursor_animate_command_line = false
	vim.g.neovide_cursor_animate_in_insert_mode = false
	vim.g.neovide_cursor_animation_length = 0.00
	vim.g.neovide_cursor_trail_size = 0
	vim.g.neovide_position_animation_length = 0
	vim.g.neovide_scroll_animation_far_lines = 0
	vim.g.neovide_scroll_animation_length = 0.00
end
