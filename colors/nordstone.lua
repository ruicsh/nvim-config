-- NordStone theme

-- UTILITIES

-- Set highlight group
local function hl(group, color)
	local style = color.style and "gui=" .. color.style or "gui=NONE"
	local fg = color.fg and "guifg=" .. color.fg or "guifg=NONE"
	local bg = color.bg and "guibg=" .. color.bg or "guibg=NONE"
	local sp = color.sp and "guisp=" .. color.sp or ""

	local h = table.concat({
		"highlight",
		group,
		style,
		fg,
		bg,
		sp,
	}, " ")

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

-- Reset highlighting
vim.cmd.highlight("clear")
if vim.fn.exists("syntax_on") then
	vim.cmd.syntax("reset")
end

vim.g.colors_name = "nordstone"

-- COLORS

_G.NordStoneColors = {
	nord0 = "#2e3440",
	nord1 = "#3b4252",
	nord2 = "#434c5e",
	nord3 = "#4c566a",
	nord3_500 = "#616e88",
	nord3_700 = "#8c97ad",
	nord3_900 = "#b7becb",
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
	neutral_700 = "#404040",
	neutral_600 = "#525252",
	neutral_500 = "#71717a",
	neutral_400 = "#a1a1aa",
}

local c = _G.NordStoneColors

-- EDITOR
loadColorSet({
	ColorColumn = { fg = "NONE", bg = "NONE" },
	CommandMode = { fg = c.nord4, bg = "NONE", style = "reverse" },
	Conceal = { fg = c.nord1 },
	CurSearch = { fg = c.nord1, bg = c.nord9 },
	Cursor = { fg = c.nord4, bg = "NONE", style = "reverse" },
	CursorColumn = { fg = "NONE", bg = c.nord0 },
	CursorIM = { fg = c.nord5, bg = "NONE", style = "reverse" },
	CursorLine = { bg = c.nord0 },
	CursorLineNr = { fg = c.nord4 },
	DiffAdd = { bg = c.nord0 },
	DiffChange = { bg = c.nord0 },
	DiffDelete = { bg = c.nord11_900 },
	DiffText = { bg = c.nord3 },
	Directory = { fg = c.nord9 },
	EndOfBuffer = { fg = c.nord1 },
	ErrorMsg = { fg = "NONE" },
	FloatBorder = { fg = c.nord3_700, bg = "NONE" },
	FoldColumn = { fg = c.nord3_500 },
	Folded = { fg = c.nord9, style = "italic" },
	Function = { fg = c.nord8 },
	IncSearch = { link = "CurSearch" },
	InsertMode = { fg = c.nord14, bg = "NONE", style = "reverse" },
	LineNr = { fg = c.nord3_500 },
	MatchParen = { fg = c.nord15, bg = "NONE", style = "bold" },
	ModeMsg = { fg = c.nord4 },
	MoreMsg = { fg = c.nord4 },
	NonText = { fg = c.nord1 },
	Normal = { fg = c.nord4, bg = c.neutral_900 },
	NormalFloat = { fg = c.nord4, bg = "NONE" },
	NormalMode = { fg = c.nord4, bg = "NONE", style = "reverse" },
	Pmenu = { fg = c.nord4, bg = "NONE" },
	PmenuExtra = { fg = c.nord8 },
	PmenuExtraSel = { fg = c.nord1, bg = c.nord9 },
	PmenuKindSel = { fg = c.nord1, bg = c.nord9 },
	PmenuSbar = { bg = c.nord0 },
	PmenuSel = { fg = c.nord0, bg = c.nord9 },
	PmenuThumb = { bg = c.nord3_500 },
	Question = { fg = c.nord14 },
	QuickFixLine = {},
	ReplacelMode = { fg = c.nord11, bg = "NONE", style = "reverse" },
	Search = { bg = c.nord2 },
	SignColumn = { fg = c.nord4, bg = "NONE" },
	Special = { fg = c.nord7 },
	SpecialKey = { fg = c.nord9 },
	SpellBad = { fg = c.nord12, style = "undercurl" },
	SpellCap = { fg = c.nord7, bg = "NONE", style = "undercurl" },
	SpellLocal = { fg = c.nord8, bg = "NONE", style = "undercurl" },
	SpellRare = { fg = c.nord9, bg = "NONE", style = "undercurl" },
	StatusLine = { fg = c.nord4, bg = "NONE" },
	StatusLineNC = { fg = c.nord4, bg = "NONE" },
	StatusLineTerm = { fg = c.nord4, bg = "NONE" },
	StatusLineTermNC = { fg = c.nord4, bg = "NONE" },
	Substitute = { fg = c.nord0, bg = c.nord12 },
	TabLine = { fg = c.nord3_900 },
	TabLineFill = {},
	TabLineSel = { fg = c.nord3_900 },
	Title = { fg = c.nord4, bg = "NONE", style = "bold" },
	ToolbarButton = { fg = c.nord4, bg = "NONE", style = "bold" },
	ToolbarLine = { fg = c.nord4, bg = c.nord1 },
	VertSplit = { fg = c.nord2, bg = "NONE" },
	Visual = { fg = c.nord4, bg = c.nord1 },
	VisualMode = { fg = c.nord0, bg = c.nord9 },
	WarningMsg = { fg = c.nord15 },
	Warnings = { fg = c.nord15 },
	WildMenu = { fg = c.nord12, bg = "NONE", style = "bold" },
	WinSeparator = { fg = c.nord2, bg = "NONE" },
	healthError = { fg = c.nord11 },
	healthSuccess = { fg = c.nord14 },
	healthWarning = { fg = c.nord15 },
})

-- TERMINAL
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

-- CUSTOM

-- inline-search-count
loadColorSet({
	InlineSearchCount = { fg = c.nord3_700, bg = c.nord0 },
})

-- folds
loadColorSet({
	FoldedHeading = { fg = c.nord4 },
})

-- quickfix
loadColorSet({
	qfDirectory = { fg = c.nord9 },
	qfFileName = { fg = c.nord4 },
	qfSnippet = { fg = c.nord3_900 },
})

-- LSP
loadColorSet({
	LspDiagnosticsDefaultError = { fg = c.nord11 },
	LspDiagnosticsDefaultHint = { fg = c.nord9 },
	LspDiagnosticsDefaultInformation = { fg = c.nord10 },
	LspDiagnosticsDefaultWarning = { fg = c.nord15 },
	LspDiagnosticsFloatingError = { fg = c.nord11 },
	LspDiagnosticsFloatingHint = { fg = c.nord9 },
	LspDiagnosticsFloatingInformation = { fg = c.nord10 },
	LspDiagnosticsFloatingWarning = { fg = c.nord15 },
	LspDiagnosticsSignError = { fg = c.nord11 },
	LspDiagnosticsSignHint = { fg = c.nord9 },
	LspDiagnosticsSignInformation = { fg = c.nord10 },
	LspDiagnosticsSignWarning = { fg = c.nord15 },
	LspDiagnosticsUnderlineError = { style = "undercurl", sp = c.nord11 },
	LspDiagnosticsUnderlineHint = { style = "undercurl", sp = c.nord10 },
	LspDiagnosticsUnderlineInformation = { style = "undercurl", sp = c.nord10 },
	LspDiagnosticsUnderlineWarning = { style = "undercurl", sp = c.nord15 },
	LspDiagnosticsVirtualTextError = { fg = c.nord11 },
	LspDiagnosticsVirtualTextHint = { fg = c.nord9 },
	LspDiagnosticsVirtualTextInformation = { fg = c.nord10 },
	LspDiagnosticsVirtualTextWarning = { fg = c.nord15 },
	LspInlayHint = { fg = c.nord3_500 },
	LspReferenceRead = { bg = c.nord2 },
	LspReferenceText = { bg = c.nord2 },
	LspReferenceWrite = { bg = c.nord2 },
	LspSignatureActiveParameter = { fg = c.nord4, bg = c.nord1 },

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

-- status-line (mode)
local cmode = {
	c = c.nord14, -- #a3be8c
	i = c.nord4, -- #d8dee9
	n = c.nord8, -- #88c0d0
	o = c.nord12, -- #d08770
	x = c.nord13, -- #ebcb8b
	_ = c.nord11, -- #bf616a
}

-- status-line
loadColorSet({
	StatusLineModeCommand = { bg = cmode.c },
	StatusLineModeCommandText = { fg = cmode.c },
	StatusLineModeInsert = { bg = cmode.i },
	StatusLineModeInsertText = { fg = cmode.i },
	StatusLineModeNormal = { bg = cmode.n },
	StatusLineModeNormalText = { fg = cmode.n },
	StatusLineModeOther = { bg = cmode._ },
	StatusLineModeOtherText = { fg = cmode._ },
	StatusLineModePending = { bg = cmode.o },
	StatusLineModePendingText = { fg = cmode.o },
	StatusLineModeVisual = { bg = cmode.x },
	StatusLineModeVisualText = { fg = cmode.x },
	StatusLineSeparator = { fg = c.nord3 },
})

-- PLUGINS

-- blink.cmp
loadColorSet({
	BlinkCmpMenuBorder = { fg = c.nord3_500 },
	BlinkCmpDocBorder = { link = "BlinkCmpMenuBorder" },
	BlinkCmpSignatureHelpBorder = { link = "BlinkCmpMenuBorder" },
})

-- CopilotChat.nvim
loadColorSet({
	CopilotChatSelection = { bg = c.nord0 },
})

-- csvview.nvim
loadColorSet({
	CsvViewDelimiter = { fg = c.nord1 },
})

-- diffview
loadColorSet({
	diffFile = { fg = c.nord7 },
	diffIndexLine = { fg = c.nord9 },
	diffLine = { fg = c.nord3 },
	diffNewFile = { fg = c.nord12 },
	diffOldFile = { fg = c.nord13 },
	diffSubname = { fg = c.nord3_900, style = "bold" },
})

-- flash.nvim
loadColorSet({
	FlashLabel = { fg = c.nord0, bg = c.nord12 },
})

-- Fugitive
loadColorSet({
	diffAdded = { fg = c.nord14 },
	diffChanged = { fg = c.nord15 },
	diffRemoved = { fg = c.nord11 },
	fugitiveHunk = { fg = c.nord3_900 },
	fugitiveIgnoredHeading = { fg = c.nord3 },
	fugitiveMergedHeading = { fg = c.nord8 },
	fugitiveRemoteHeading = { fg = c.nord9 },
	fugitiveStagedHeading = { fg = c.nord14 },
	fugitiveStashedHeading = { fg = c.nord12 },
	fugitiveSymbolicRef = { fg = c.nord9 },
	fugitiveUnmergedHeading = { fg = c.nord13 },
	fugitiveUnstagedHeading = { fg = c.nord13 },
	fugitiveUntrackedHeading = { fg = c.nord11 },
})

-- mini.diff
loadColorSet({
	MiniDiffSignAdd = { fg = c.nord14 },
	MiniDiffSignChange = { fg = c.nord13 },
	MiniDiffSignDelete = { fg = c.nord11 },
})

-- neo-tree.nvim
loadColorSet({
	NeoTreeGitDirty = { fg = c.nord13 },
	NeoTreeGitStaged = { fg = c.nord14 },
	NeoTreeGitMerge = { fg = c.nord8 },
	NeoTreeGitRenamed = { fg = c.nord12 },
	NeoTreeGitNew = { fg = c.nord14 },
	NeoTreeGitUntracked = { fg = c.nord14 },
})

-- nvim-dap
loadColorSet({
	DapBreakpoint = { fg = c.nord12 },
	DapBreakpointLineNr = { link = "DapBreakpoint" },
	DapStopped = { fg = c.nord13 },
	DapStoppedLine = { bg = c.nord2 },
	DapStoppedLineNr = { link = "DapStopped" },
})

--nvim-dap-ui
loadColorSet({
	DapUIBreakpointsCurrentLine = { fg = c.nord8 },
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

-- snacks.nvim
loadColorSet({
	SnacksIndentScope = { fg = c.nord3_500 },
	SnacksPickerDir = { fg = c.nord3_500 },
	SnacksPickerMatch = { fg = c.nord4, bg = c.nord3 },
})

-- treesitter-context
loadColorSet({
	TreesitterContextLineNumber = { fg = c.nord2 },
	TreesitterContextSeparator = { fg = c.nord2 },
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

-- SYNTAX
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
	["@diff.delta"] = { link = "diffChanged" },
	["@diff.minus"] = { link = "diffRemoved" },
	["@diff.plus"] = { link = "diffAdded" },
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
	["@markup"] = { fg = c.nord10 },
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

	-- markdown
	["@markup.heading.1.markdown"] = { fg = c.nord9 },
	["@markup.heading.2.markdown"] = { fg = c.nord9 },
	["@markup.heading.3.markdown"] = { fg = c.nord9 },
	["@markup.heading.4.markdown"] = { fg = c.nord9 },
	["@markup.heading.5.markdown"] = { fg = c.nord9 },
	["@markup.heading.6.markdown"] = { fg = c.nord9 },
	["@punctuation.special.markdown"] = { fg = c.nord3 },
	["@markup.raw.block.markdown"] = { fg = c.nord3_900 },

	-- markdown_inline
	["@markup.link.label.markdown_inline"] = { fg = c.nord8 },
	["@markup.link.url.markdown_inline"] = { fg = c.nord3_700 },
	["@markup.link.markdown_inline"] = { fg = c.nord3_700 },
	["@conceal.markdown_inline"] = { fg = c.nord3 },

	-- diff
	["@attribute.diff"] = { fg = c.nord13 },
	["@string.special.path.diff"] = { fg = c.nord3_900 },
	["@constant.diff"] = { fg = c.nord3_500 },

	-- scss
	["@keyword.import.scss"] = { link = "@keyword.import.css" },
	["@string.scss"] = { link = "@string.css" },
	["@type.scss"] = { link = "@type.css" },

	-- vue
	["@none.vue"] = { fg = c.nord4 },

	["markdownLinkText"] = { link = "@markup.link.label.markdown_inline" },
	["markdownLinkDelimiter"] = { link = "@markup.link.markdown_inline" },
	["markdownLinkUrl"] = { link = "@markup.link.url.markdown_inline" },
})
