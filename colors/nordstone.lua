------
-- NordStone
------

----
-- Utilities
----

-- Set highlight group
local function hl(group, color)
	local style = color.style and "gui=" .. color.style or "gui=NONE"
	local fg = color.fg and "guifg=" .. color.fg or "guifg=NONE"
	local bg = color.bg and "guibg=" .. color.bg or "guibg=NONE"
	local sp = color.sp and "guisp=" .. color.sp or ""

	local h = "highlight " .. group .. " " .. style .. " " .. fg .. " " .. bg .. " " .. sp

	vim.cmd(h)
	if color.link then
		vim.cmd("highlight! link " .. group .. " " .. color.link)
	end
end

-- Local a set of colors
local function loadColorSet(colorSet)
	for group, colors in pairs(colorSet) do
		hl(group, colors)
	end
end

--
-- Reset highlighting
--
vim.cmd.highlight("clear")
if vim.fn.exists("syntax_on") then
	vim.cmd.syntax("reset")
end

vim.g.colors_name = "nordstone"

----
-- Colors
----
NordStoneColors = {
	nord0 = "#2e3440",
	nord1 = "#3b4252",
	nord2 = "#434c5e",
	nord3 = "#4c566a",
	nord3_500 = "#616e88",
	nord4 = "#d8dee9",
	nord4_900 = "#b7c2d7",
	nord5 = "#e5e9f0",
	nord6 = "#eceff4",
	nord7 = "#8fbcbb",
	nord8 = "#88c0d0",
	nord9 = "#81a1c1",
	nord10 = "#5e81aC",
	nord11 = "#bf616A",
	nord11_900 = "#3c181c",
	nord12 = "#d08770",
	nord13 = "#ebcb8B",
	nord14 = "#a3be8C",
	nord15 = "#b48eaD",
	neutral_900 = "#171717",
	neutral_800 = "#262626",
}

local c = NordStoneColors

----
-- Editor
----
loadColorSet({
	ColorColumn = { fg = "NONE", bg = "NONE" },
	CommandMode = { fg = c.nord4, bg = "NONE", style = "reverse" },
	Conceal = { fg = c.nord1 },
	CurSearch = { fg = c.nord1, bg = c.nord8 },
	Cursor = { fg = c.nord4, bg = "NONE", style = "reverse" },
	CursorColumn = { fg = "NONE", bg = c.nord0 },
	CursorIM = { fg = c.nord5, bg = "NONE", style = "reverse" },
	CursorLine = { fg = "NONE", bg = c.nord0 },
	CursorLineNr = { fg = c.nord4 },
	DiffAdd = { bg = c.nord0 },
	DiffChange = { bg = c.nord0 },
	DiffDelete = { bg = c.nord11_900 },
	DiffText = { bg = c.nord3 },
	Directory = { fg = c.nord4, bg = "NONE" },
	EndOfBuffer = { fg = c.nord1 },
	ErrorMsg = { fg = "NONE" },
	FloatBorder = { fg = c.nord4, bg = "NONE" },
	FoldColumn = { fg = c.nord7 },
	Folded = { fg = c.nord3_500, bg = "NONE", style = "italic" },
	Function = { fg = c.nord8 },
	IncSearch = { fg = c.nord1, bg = c.nord8 },
	InsertMode = { fg = c.nord14, bg = "NONE", style = "reverse" },
	LineNr = { fg = c.nord3_500 },
	MatchParen = { fg = c.nord15, bg = "NONE", style = "bold" },
	ModeMsg = { fg = c.nord4 },
	MoreMsg = { fg = c.nord4 },
	NonText = { fg = c.nord1 },
	Normal = { fg = c.nord4, bg = c.neutral_900 },
	NormalFloat = { fg = c.nord4, bg = "NONE" },
	NormalMode = { fg = c.nord4, bg = "NONE", style = "reverse" },
	Pmenu = { fg = c.nord4, bg = c.nord2 },
	PmenuSbar = { fg = c.nord4, bg = c.nord2 },
	PmenuSel = { fg = c.nord4, bg = c.nord10 },
	PmenuThumb = { fg = c.nord4, bg = c.nord4 },
	Question = { fg = c.nord14 },
	QuickFixLine = { fg = c.nord4, bg = "NONE", style = "reverse" },
	ReplacelMode = { fg = c.nord11, bg = "NONE", style = "reverse" },
	Search = { fg = c.nord1, bg = c.nord8 },
	SignColumn = { fg = c.nord4, bg = "NONE" },
	Special = { fg = c.nord7 },
	SpecialKey = { fg = c.nord9 },
	SpellBad = { fg = c.nord11, bg = "NONE", style = "italic,undercurl" },
	SpellCap = { fg = c.nord7, bg = "NONE", style = "italic,undercurl" },
	SpellLocal = { fg = c.nord8, bg = "NONE", style = "italic,undercurl" },
	SpellRare = { fg = c.nord9, bg = "NONE", style = "italic,undercurl" },
	StatusLine = { fg = c.nord4, bg = c.nord2 },
	StatusLineNC = { fg = c.nord4, bg = c.nord1 },
	StatusLineTerm = { fg = c.nord4, bg = c.nord2 },
	StatusLineTermNC = { fg = c.nord4, bg = c.nord1 },
	Substitute = { fg = c.nord0, bg = c.nord12 },
	TabLineFill = { fg = c.nord4, bg = "NONE" },
	Tabline = { fg = c.nord4, bg = c.nord1 },
	TablineSel = { fg = c.nord1, bg = c.nord9 },
	Title = { fg = c.nord4, bg = "NONE", style = "bold" },
	ToolbarButton = { fg = c.nord4, bg = "NONE", style = "bold" },
	ToolbarLine = { fg = c.nord4, bg = c.nord1 },
	VertSplit = { fg = c.nord2, bg = "NONE" },
	Visual = { fg = "NONE", bg = c.nord2 },
	VisualMode = { fg = c.nord9, bg = "NONE", style = "reverse" },
	WarningMsg = { fg = c.nord15 },
	Warnings = { fg = c.nord15 },
	WildMenu = { fg = c.nord12, bg = "NONE", style = "bold" },
	WinSeparator = { fg = c.nord2, bg = "NONE" },

	healthError = { fg = c.nord11 },
	healthSuccess = { fg = c.nord14 },
	healthWarning = { fg = c.nord15 },
	qfLineNr = { fg = c.nord4, bg = "NONE", style = "reverse" },
})

----
-- Terminal
----
vim.g.terminal_color_0 = c.nord1
vim.g.terminal_color_1 = c.nord11
vim.g.terminal_color_2 = c.nord14
vim.g.terminal_color_3 = c.nord13
vim.g.terminal_color_4 = c.nord9
vim.g.terminal_color_5 = c.nord15
vim.g.terminal_color_6 = c.nord8
vim.g.terminal_color_7 = c.nord5
vim.g.terminal_color_8 = c.nord3
vim.g.terminal_color_9 = c.nord11
vim.g.terminal_color_10 = c.nord14
vim.g.terminal_color_11 = c.nord13
vim.g.terminal_color_12 = c.nord9
vim.g.terminal_color_13 = c.nord15
vim.g.terminal_color_14 = c.nord7
vim.g.terminal_color_15 = c.nord6

----
-- Plugins
----

-- LSP
loadColorSet({
	LspDiagnosticsDefaultError = { fg = c.nord11 },
	LspDiagnosticsSignError = { fg = c.nord11 },
	LspDiagnosticsFloatingError = { fg = c.nord11 },
	LspDiagnosticsVirtualTextError = { fg = c.nord11 },
	LspDiagnosticsUnderlineError = { style = "undercurl", sp = c.nord11 },
	LspDiagnosticsDefaultWarning = { fg = c.nord15 },
	LspDiagnosticsSignWarning = { fg = c.nord15 },
	LspDiagnosticsFloatingWarning = { fg = c.nord15 },
	LspDiagnosticsVirtualTextWarning = { fg = c.nord15 },
	LspDiagnosticsUnderlineWarning = { style = "undercurl", sp = c.nord15 },
	LspDiagnosticsDefaultInformation = { fg = c.nord10 },
	LspDiagnosticsSignInformation = { fg = c.nord10 },
	LspDiagnosticsFloatingInformation = { fg = c.nord10 },
	LspDiagnosticsVirtualTextInformation = { fg = c.nord10 },
	LspDiagnosticsUnderlineInformation = { style = "undercurl", sp = c.nord10 },
	LspDiagnosticsDefaultHint = { fg = c.nord9 },
	LspDiagnosticsSignHint = { fg = c.nord9 },
	LspDiagnosticsFloatingHint = { fg = c.nord9 },
	LspDiagnosticsVirtualTextHint = { fg = c.nord9 },
	LspDiagnosticsUnderlineHint = { style = "undercurl", sp = c.nord10 },
	LspReferenceText = { fg = c.nord4, bg = c.nord1 },
	LspReferenceRead = { fg = c.nord4, bg = c.nord1 },
	LspReferenceWrite = { fg = c.nord4, bg = c.nord1 },

	DiagnosticError = { link = "LspDiagnosticsDefaultError" },
	DiagnosticFloatingError = { link = "LspDiagnosticsFloatingError" },
	DiagnosticFloatingHint = { link = "LspDiagnosticsFloatingHint" },
	DiagnosticFloatingInfo = { link = "LspDiagnosticsFloatingInformation" },
	DiagnosticFloatingWarn = { link = "LspDiagnosticsFloatingWarning" },
	DiagnosticHint = { link = "LspDiagnosticsDefaultHint" },
	DiagnosticInfo = { link = "LspDiagnosticsDefaultInformation" },
	DiagnosticSignError = { link = "LspDiagnosticsSignError" },
	DiagnosticSignHint = { link = "LspDiagnosticsSignHint" },
	DiagnosticSignInfo = { link = "LspDiagnosticsSignInformation" },
	DiagnosticSignWarn = { link = "LspDiagnosticsSignWarning" },
	DiagnosticUnderlineError = { link = "LspDiagnosticsUnderlineError" },
	DiagnosticUnderlineHint = { link = "LspDiagnosticsUnderlineHint" },
	DiagnosticUnderlineInfo = { link = "LspDiagnosticsUnderlineInformation" },
	DiagnosticUnderlineWarn = { link = "LspDiagnosticsUnderlineWarning" },
	DiagnosticVirtualTextError = { link = "LspDiagnosticsVirtualTextError" },
	DiagnosticVirtualTextHint = { link = "LspDiagnosticsVirtualTextHint" },
	DiagnosticVirtualTextInfo = { link = "LspDiagnosticsVirtualTextInformation" },
	DiagnosticVirtualTextWarn = { link = "LspDiagnosticsVirtualTextWarning" },
	DiagnosticWarn = { link = "LspDiagnosticsDefaultWarning" },
})

-- GitSigns
loadColorSet({
	GitSignsAdd = { fg = c.nord14 },
	GitSignsAddNr = { fg = c.nord14 },
	GitSignsAddLn = { fg = c.nord14 },
	GitSignsChange = { fg = c.nord13 },
	GitSignsChangeNr = { fg = c.nord13 },
	GitSignsChangeLn = { fg = c.nord13 },
	GitSignsDelete = { fg = c.nord11 },
	GitSignsDeleteNr = { fg = c.nord11 },
	GitSignsDeleteLn = { fg = c.nord11 },
	GitSignsCurrentLineBlame = { fg = c.nord3_500, style = "bold" },
})

-- Fugitive
loadColorSet({
	fugitiveUnmergedHeading = { fg = c.nord13 },
	fugitiveUntrackedHeading = { fg = c.nord11 },
	fugitiveStagedHeading = { fg = c.nord14 },
	fugitiveStashedHeading = { fg = c.nord12 },
	fugitiveRemoteHeading = { fg = c.nord9 },
	fugitiveMergedHeading = { fg = c.nord8 },
	fugitiveIgnoredHeading = { fg = c.nord3 },
	fugitiveUnstagedHeading = { fg = c.nord13 },
})

-- Telescope
loadColorSet({
	TelescopePromptBorder = { fg = c.nord4 },
	TelescopeResultsBorder = { fg = c.nord4 },
	TelescopePreviewBorder = { fg = c.nord4 },
	TelescopeSelectionCaret = { fg = c.nord9 },
	TelescopeSelection = { fg = c.nord6, bg = c.nord2 },
	TelescopeMatching = { link = "Search" },
})

-- WhichKey
loadColorSet({
	WhichKey = { fg = c.nord8, style = "bold" },
	WhichKeyGroup = { fg = c.nord5 },
	WhichKeyDesc = { fg = c.nord7, style = "italic" },
	WhichKeySeperator = { fg = c.nord9 },
	WhichKeyFloating = { bg = c.nord1 },
	WhichKeyFloat = { bg = c.nord1 },
	WhichKeyValue = { fg = c.nord7 },
})

-- Diff
loadColorSet({
	diffAdded = { fg = c.nord14 },
	diffRemoved = { fg = c.nord11 },
	diffChanged = { fg = c.nord15 },
	diffOldFile = { fg = c.nord13 },
	diffNewFile = { fg = c.nord12 },
	diffFile = { fg = c.nord7 },
	diffLine = { fg = c.nord3 },
	diffIndexLine = { fg = c.nord9 },
})

-- NeoTree
loadColorSet({
	NeoTreeGitDirty = { fg = c.nord13 },
	NeoTreeGitStaged = { fg = c.nord14 },
	NeoTreeGitMerge = { fg = c.nord8 },
	NeoTreeGitRenamed = { fg = c.nord12 },
	NeoTreeGitNew = { fg = c.nord14 },
	NeoTreeGitUntracked = { fg = c.nord14 },
})

-- hlsearch
loadColorSet({
	HlSearchLensNear = { fg = c.nord3_500, bg = "NONE" },
	HlSearchLens = { fg = c.nord3_500, bg = "NONE" },
})

-- avante
loadColorSet({
	AvanteInlineHint = { fg = c.nord3 },
})

-- vim-iluminate
loadColorSet({
	IlluminatedWordText = { bg = c.nord2 },
	IlluminatedWordRead = { bg = c.nord2 },
	IlluminatedWordWrite = { bg = c.nord2 },
})

-- barbecue.nvim
loadColorSet({
	BarbecueNormal = { fg = c.nord4_900 },
	BarbecueEllipsis = { fg = c.nord4_900 },
	BarbecueSeparator = { fg = c.nord4_900 },
	BarbecueBasename = { fg = c.nord4 },
	BarbecueDirname = { fg = c.nord4_900 },
})

-- yanky.nvim
loadColorSet({
	YankyPut = { link = "IncSearch" },
	YankyYanked = { link = "IncSearch" },
})

-- nvim-dap
loadColorSet({
	DapBreakpoint = { fg = c.nord14 },
	DapBreakpointCondition = {},
	DapBreakpointRejected = {},
	DapLogPoint = {},
	DapStopped = { bg = "#ff0000" },
})

-- nvim-dap-ui
loadColorSet({
	DapUIBreakpointsCurrentLine = { fg = c.nord8, style = "bold" },
	DapUIBreakpointsDisabledLine = {},
	DapUIBreakpointsInfo = { fg = c.nord8 },
	DapUIBreakpointsLine = { fg = c.nord8 },
	DapUIBreakpointsPath = { fg = c.nord8, bg = "NONE" },
	DapUICurrentFrameName = { link = "DapUIBreakpointsCurrentLine" },
	DapUIDecoration = { fg = c.nord8 },
	DapUIEndofBuffer = { link = "EndofBuffer" },
	DapUIFloatBorder = { link = "FloatBorder" },
	DapUIFloatNormal = { link = "NormalFloat" },
	DapUIFrameName = { fg = c.nord4 },
	DapUILineNumber = { fg = c.nord8 },
	DapUIModifiedValue = { fg = c.nord8, style = "bold" },
	DapUINormal = { link = "Normal" },
	DapUIPlayPause = { fg = c.nord14 },
	DapUIRestart = { fg = c.nord14 },
	DapUIScope = { fg = c.nord8 },
	DapUISource = { fg = c.nord9 },
	DapUIStepBack = { fg = c.nord8 },
	DapUIStepInto = { fg = c.nord8 },
	DapUIStepOut = { fg = c.nord8 },
	DapUIStepOver = { fg = c.nord8 },
	DapUIStop = { fg = c.nord11 },
	DapUIStoppedThread = { fg = c.nord8 },
	DapUIThread = { fg = c.nord8 },
	DapUIType = { fg = c.nord9 },
	DapUIUnavailable = { fg = c.nord3 },
	DapUIValue = { fg = c.nord4 },
	DapUIVariable = { fg = c.nord4 },
	DapUIWatchesEmpty = { fg = c.nord3 },
	DapUIWatchesError = { fg = c.nord11 },
	DapUIWatchesValue = { fg = c.nord8 },
	DapUIWinSelect = { fg = c.nord8, style = "bold" },
})

----
-- Syntax
----
loadColorSet({
	["@Special"] = { fg = c.nord13 },

	["@attribute"] = { fg = c.nord7 },
	["@boolean"] = { fg = c.nord9 },
	["@character"] = { fg = c.nord14 },
	["@comment"] = { fg = c.nord3_500 },
	["@conditional"] = { fg = c.nord9 },
	["@constant"] = { fg = c.nord13 },
	["@constant.builtin"] = { fg = c.nord7 },
	["@constant.macro"] = { fg = c.nord7 },
	["@constructor"] = { fg = c.nord7 },
	["@diff.delta"] = { link = "DiffChange" },
	["@diff.minus"] = { link = "DiffDelete" },
	["@diff.plus"] = { link = "DiffAdd" },
	["@error"] = { fg = c.nord11 },
	["@exception"] = { fg = c.nord15 },
	["@field"] = { fg = c.nord4 },
	["@float"] = { fg = c.nord15 },
	["@function"] = { fg = c.nord8 },
	["@function.builtin"] = { fg = c.nord7 },
	["@funtion.macro"] = { fg = c.nord7 },
	["@include"] = { fg = c.nord9 },
	["@keyword"] = { fg = c.nord9 },
	["@keyword.function"] = { fg = c.nord9 },
	["@keyword.operator"] = { fg = c.nord9 },
	["@keyword.return"] = { fg = c.nord9 },
	["@label"] = { fg = c.nord15 },
	["@markup"] = { fg = c.nord9 },
	["@markup.heading.html"] = { fg = c.nord4 },
	["@method"] = { fg = c.nord8 },
	["@namespace"] = { fg = c.nord4 },
	["@none"] = { fg = c.nord9 },
	["@none.html"] = { fg = c.nord4 },
	["@none.tsx"] = { link = "@none.html" },
	["@number"] = { fg = c.nord15 },
	["@operator"] = { fg = c.nord9 },
	["@parameter"] = { fg = c.nord10 },
	["@property"] = { fg = c.nord4 },
	["@punctuation.bracket"] = { fg = c.nord8 },
	["@punctuation.delimiter"] = { fg = c.nord8 },
	["@punctuation.special"] = { fg = c.nord8 },
	["@repeat"] = { fg = c.nord9 },
	["@string"] = { fg = c.nord14 },
	["@string.escape"] = { fg = c.nord15 },
	["@string.regex"] = { fg = c.nord7 },
	["@symbol"] = { fg = c.nord15 },
	["@tag"] = { fg = c.nord9 },
	["@tag.attribute"] = { fg = c.nord7 },
	["@tag.builtin.tsx"] = { link = "@type.builtin" },
	["@tag.delimiter"] = { fg = c.nord9 },
	["@text"] = { fg = c.nord4 },
	["@text.emphasis"] = { fg = c.nord10 },
	["@text.literal"] = { fg = c.nord4 },
	["@text.math"] = { fg = c.nord7 },
	["@text.reference"] = { fg = c.nord15 },
	["@text.strike"] = { fg = c.nord4, style = "strikethrough" },
	["@text.strong"] = { fg = c.nord10, bg = "NONE" },
	["@text.title"] = { fg = c.nord10, bg = "NONE" },
	["@text.underline"] = { fg = c.nord4, bg = "NONE", style = "underline" },
	["@text.uri"] = { fg = c.nord14, style = "underline" },
	["@type"] = { fg = c.nord4 },
	["@type.builtin"] = { fg = c.nord7 },
	["@variable"] = { fg = c.nord4 },

	["@lsp.type.class.typescript"] = { fg = c.nord7 },
	["@lsp.type.interface.typescript"] = { fg = c.nord7 },

	["@attribute.typescript"] = { fg = c.nord11 },
	["@variable.builtin.typescript"] = { fg = c.nord9 },

	-- angular
	["@function.angular"] = { fg = c.nord12 },
	["@keyword.angular"] = { fg = c.nord7 },
	["@variable.angular"] = { fg = c.nord12 },
	["@none.angular"] = { fg = c.nord4 },

	-- css
	["@keyword.import.css"] = { fg = c.nord7 },
	["@string.css"] = { fg = c.nord9 },
	["@type.css"] = { fg = c.nord7 },

	-- scss
	["@keyword.import.scss"] = { fg = c.nord7 },
	["@string.scss"] = { fg = c.nord9 },
	["@type.scss"] = { fg = c.nord7 },

	-- vue
	["@none.vue"] = { fg = c.nord4 },
})
