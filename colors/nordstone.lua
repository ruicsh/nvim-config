local vim = vim

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

-- Load a set of colours
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

-- COLOURS

local NordStoneColors = {
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
	nord10 = "#5e81ac",
	nord11 = "#bf616a",
	nord11_900 = "#3c181c",
	nord12 = "#d08770",
	nord13 = "#ebcb8b",
	nord14 = "#a3be8c",
	nord14_800 = "#202a18",
	nord15 = "#b48ead",
	neutral_900 = "#171717",
	neutral_880 = "#181818",
	neutral_850 = "#1a1a1a",
	neutral_800 = "#262626",
	neutral_700 = "#404040",
	neutral_600 = "#525252",
	neutral_500 = "#71717a",
	neutral_400 = "#a1a1aa",
}

local c = NordStoneColors

-- Make colours available globally for external access
vim.g.nordstone_colors = NordStoneColors

-- EDITOR
loadColorSet({
	ColorColumn = { fg = "NONE", bg = "NONE" },
	CommandMode = { fg = c.nord4, bg = "NONE", style = "reverse" },
	Conceal = { fg = c.nord1 },
	CurSearch = { fg = c.nord1, bg = c.nord9 },
	Cursor = { fg = c.nord4, bg = "NONE", style = "reverse" },
	CursorColumn = { fg = "NONE", bg = c.nord0 },
	CursorIM = { fg = c.nord5, bg = "NONE", style = "reverse" },
	CursorLine = { bg = c.neutral_800 },
	CursorLineNr = { fg = c.nord4 },
	Directory = { fg = c.nord9 },
	EndOfBuffer = { fg = c.nord1 },
	ErrorMsg = { fg = "NONE" },
	FloatBorder = { fg = c.neutral_600, bg = "NONE" },
	FloatTitle = { fg = c.nord4, bg = "NONE" },
	FoldColumn = { fg = c.nord3_500 },
	Folded = { fg = c.nord9 },
	IncSearch = { link = "CurSearch" },
	InsertMode = { fg = c.nord14, bg = "NONE", style = "reverse" },
	LineNr = { fg = c.neutral_500 },
	MatchParen = { fg = c.nord13, bg = "NONE", style = "bold" },
	ModeMsg = { fg = c.nord4 },
	MoreMsg = { fg = c.nord4 },
	NonText = { fg = c.nord1 },
	Normal = { fg = c.nord4, bg = "NONE" },
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
	WinSeparator = { fg = c.neutral_600, bg = "NONE" },
	healthError = { fg = c.nord11 },
	healthSuccess = { fg = c.nord14 },
	healthWarning = { fg = c.nord15 },
	-- diff
	Added = { fg = c.nord14, bg = "NONE" },
	DiffAdd = { bg = c.nord14_800 },
	DiffChange = { bg = c.neutral_850 },
	DiffDelete = { bg = c.nord11_900 },
	DiffText = { bg = c.nord0 },
	Removed = { fg = c.nord11, bg = "NONE" },
})

-- SYNTAX
loadColorSet({
	Boolean = { fg = c.nord9 }, -- a boolean constant: TRUE, false
	Character = { fg = c.nord14 }, -- a character constant: 'c', '\n'
	Comment = { fg = c.nord3_500 }, -- any comment
	Conditional = { fg = c.nord9 }, -- if, then, else, endif, switch, etc.
	Constant = { fg = c.nord13 }, -- (preferred) any constant
	Debug = { fg = c.nord4 }, -- debugging statements
	Define = { fg = c.nord9 }, -- preprocessor #define
	Delimiter = { fg = c.nord6 }, -- character that needs attention
	Error = { fg = c.nord11 }, -- (preferred) any erroneous construct
	Exception = { fg = c.nord9 }, -- try, catch, throw
	Float = { fg = c.nord15 }, -- a floating point constant: 2.3e10
	Function = { fg = c.nord8 }, -- function name (also: methods for classes)
	Identifier = { fg = c.nord9 }, -- (preferred) any variable name
	Include = { fg = c.nord9 }, -- preprocessor #include
	Keyword = { fg = c.nord9 }, -- any other keyword
	Label = { fg = c.nord9 }, -- case, default, etc.
	Macro = { link = "Define" }, -- same as Define
	Number = { fg = c.nord15 }, -- a number constant: 234, 0xff
	Operator = { fg = c.nord9 }, -- "sizeof", "+", "*", etc.
	PreCondit = { link = "PreProc" }, -- preprocessor #if, #else, #endif, etc.
	PreProc = { fg = c.nord9 }, -- (preferred) generic Preprocessor
	Repeat = { fg = c.nord9 }, -- for, do, while, etc.
	Special = { fg = c.nord4 }, -- (preferred) any special symbol
	SpecialChar = { fg = c.nord13 }, -- special character in a constant
	SpecialComment = { fg = c.nord8 }, -- special things inside a comment
	Statement = { fg = c.nord9 }, -- (preferred) any statement
	StorageClass = { fg = c.nord9 }, -- static, register, volatile, etc.
	String = { fg = c.nord14 }, -- a string constant: "this is a string"
	Structure = { fg = c.nord9 }, -- struct, union, enum, etc.
	Tag = { fg = c.nord4 }, -- you can use CTRL-] on this
	Title = { fg = c.nord9 },
	Todo = { fg = c.nord13, bg = "NONE" }, -- (preferred) anything that needs extra attention; mostly the keywords TODO FIXME and XXX
	Type = { fg = c.nord8 }, -- (preferred) int, long, char, etc.
	Typedef = { fg = c.nord9 }, -- A typedef

	-- attributes
	Bold = { style = "bold" }, -- (preferred) bold text
	Italic = { style = "italic" }, -- (preferred) italic text
	Underlined = { style = "underline" }, -- (preferred) text that stands out, HTML links

	-- Angular
	["@tag.attribute.angular"] = { link = "htmlArg" },
	["@tag.delimiter.angular"] = { link = "htmlTag" },
	["@tag.angular"] = { link = "htmlTag" },

	-- CSS
	["@keyword.directive.css"] = { fg = c.nord12 },
	["@property.css"] = { fg = c.nord4 },
	["@string.css"] = { fg = c.nord9 },
	["@variable.css"] = { fg = c.nord7 },
	cssAttr = { link = "@string.css" },
	cssProp = { link = "@property.css" },
	cssUnitDecorators = { link = "@string.css" },

	-- gitcommit
	["@markup.heading.gitcommit"] = { link = "Normal" },

	-- HTML
	["@tag.delimiter"] = { link = "Statement" },
	["@tag.html"] = { link = "Statement" },
	htmlArg = { fg = c.nord7 },
	htmlTag = { fg = c.nord9 },
	htmlTagN = { fg = c.nord8 },

	-- JSON
	["@constant.builtin.json"] = { link = "Boolean" },
	jsonNull = { link = "Boolean" },

	-- Lua
	["@constructor.lua"] = { fg = c.nord8 },
	["@property.lua"] = { fg = c.nord4 },
	["@lsp.type.property.lua"] = { link = "@property.lua" },

	-- Markdown
	["@markup.heading.1.markdown"] = { fg = c.nord9 },
	["@markup.heading.2.markdown"] = { fg = c.nord9 },
	["@markup.heading.3.markdown"] = { fg = c.nord9 },
	["@markup.heading.4.markdown"] = { fg = c.nord9 },
	["@markup.heading.5.markdown"] = { fg = c.nord9 },
	["@markup.heading.6.markdown"] = { fg = c.nord9 },
	["@markup.link.label.markdown_inline"] = { link = "String" },
	["@markup.link.markdown"] = { fg = c.nord4 },
	["@markup.raw.block.markdown"] = { fg = c.nord7 },
	["@markup.raw.markdown_inline"] = { fg = c.nord7 },
	["@punctuation.special.markdown"] = { fg = c.nord3 },
	markdownCode = { link = "@markup.raw.block.markdown" },
	markdownCodeBlock = { link = "markdownCode" },
	markdownDelimiter = { link = "Title" },
	markdownHeadingDelimiter = { link = "Title" },
	markdownLinkText = { link = "@markup.link.label.markdown_inline" },
	markdownUrl = { link = "@markup.link.markdown" },

	-- Sass
	["@keyword.directive.scss"] = { link = "@keyword.directive.css" },
	["@property.scss"] = { link = "@property.css" },
	["@variable.scss"] = { link = "@variable.css" },
	["@string.scss"] = { link = "@string.css" },
	sassMedia = { link = "@keyword.directive.css" },

	-- TSX
	["@tag.attribute.tsx"] = { link = "htmlArg" },
	["@tag.builtin.tsx"] = { link = "htmlTag" },
	["@tag.delimiter.tsx"] = { link = "htmlTag" },
	["@tag.tsx"] = { link = "htmlTagN" },
	["@type.builtin.tsx"] = { link = "Type" },

	-- TypeScript
	typescriptEnum = { link = "Type" },
	typescriptExport = { link = "Keyword" },
	typescriptIdentifierName = { link = "Constant" },
	typescriptImport = { link = "Keyword" },
	typescriptImportType = { link = "Keyword" },
	typescriptMember = { link = "Identifier" },
	typescriptTypeReference = { link = "Type" },
})

-- TERMINAL
-- `h: terminal_config`
local terminal_colors = {
	c.nord1,
	c.nord11,
	c.nord14,
	c.nord13,
	c.nord9,
	c.nord15,
	c.nord8,
	c.nord5,
	c.nord3,
	c.nord11,
	c.nord14,
	c.nord13,
	c.nord9,
	c.nord15,
	c.nord7,
	c.nord6,
}
for i, color in ipairs(terminal_colors) do
	vim.g["terminal_color_" .. (i - 1)] = color
end

-- CUSTOM

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
	LspReferenceRead = { bg = c.nord1 },
	LspReferenceText = { link = "LspReferenceRead" },
	LspReferenceWrite = { link = "LspReferenceRead" },
	LspSignatureActiveParameter = { fg = c.nord4, bg = c.nord1 },

	DiagnosticError = { link = "LspDiagnosticsDefaultError" },
	DiagnosticFloatingError = { link = "LspDiagnosticsFloatingError" },
	DiagnosticFloatingHint = { link = "LspDiagnosticsFloatingHint" },
	DiagnosticFloatingInfo = { link = "LspDiagnosticsFloatingInformation" },
	DiagnosticFloatingWarn = { link = "LspDiagnosticsFloatingWarning" },
	DiagnosticHint = { link = "LspDiagnosticsDefaultHint" },
	DiagnosticInfo = { link = "LspDiagnosticsDefaultInformation" },
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
	c = c.nord14, -- `#a3be8c`
	i = c.nord4, -- `#d8dee9`
	n = c.nord8, -- `#88c0d0`
	o = c.nord12, -- `#d08770`
	x = c.nord13, -- `#ebcb8b`
	_ = c.nord11, -- `#bf616a`
}

-- status-line
loadColorSet({
	StatusLineBookmark = { fg = c.nord13 },
	StatusLineFileChanged = { fg = c.nord8 },
	StatusLineGitStatus = { fg = c.nord4 },
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
	StatusLineProject = { fg = c.nord4 },
	StatusLineSeparator = { fg = c.nord3 },
})

-- PLUGINS

-- blink.cmp
loadColorSet({
	BlinkCmpDocBorder = { link = "FloatBorder" },
	BlinkCmpDocSeparator = { link = "FloatBorder" },
	BlinkCmpMenu = { bg = c.neutral_850 },
	BlinkCmpMenuBorder = { link = "FloatBorder" },
	BlinkCmpSignatureHelpBorder = { link = "FloatBorder" },
})

-- CopilotChat.nvim
loadColorSet({
	CopilotChatHeader = { fg = c.nord14 },
	CopilotChatSelection = { bg = c.nord0 },
	CopilotChatSeparator = { fg = c.neutral_700 },
})

-- Diffview.nvim
loadColorSet({
	DiffviewDiffDeleteDim = { bg = c.neutral_880 },
	DiffviewFilePanelCounter = { fg = c.nord8 },
	DiffviewSecondary = { fg = c.nord14 },
})

-- flash.nvim
loadColorSet({
	FlashLabel = { fg = c.nord13, bg = "NONE" },
})

-- Fugitive
loadColorSet({
	-- git status
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
	-- diff
	diffAdded = { link = "Added" },
	diffChanged = { fg = c.nord13, bg = "NONE" },
	diffFile = { fg = c.nord7 },
	diffIndexLine = { fg = c.nord9 },
	diffLine = { fg = c.nord9 },
	diffNewFile = { fg = c.nord9 },
	diffOldFile = { fg = c.nord9 },
	diffRemoved = { link = "Removed" },
	diffSubname = { fg = c.nord3_900, style = "bold" },
	-- git show
	gitDiff = { fg = c.nord4 },
	-- git log
	gitDate = { fg = c.nord9 },
	gitDateHeader = { fg = c.nord3_700 },
	gitEmail = { fg = c.nord9 },
	gitHash = { fg = c.nord9 },
	gitHashAbbrev = { fg = c.nord9 },
	gitIdentity = { fg = c.nord9 },
	gitIdentityHeader = { fg = c.nord3_700 },
	gitIdentityKeyword = { fg = c.nord3_700 },
	gitKeyword = { fg = c.nord3_700 },
})

-- gitsigns.nvim
loadColorSet({
	GitSignsAdd = { fg = c.nord14 },
	GitSignsAddInline = { link = "GitSignsBlank" },
	GitSignsBlank = { fg = "NONE", bg = "NONE" },
	GitSignsChange = { fg = c.nord13 },
	GitSignsCurrentLineBlame = { fg = c.nord3 },
	GitSignsDelete = { fg = c.nord11 },
	GitSignsDeleteInline = { link = "GitSignsBlank" },
})

-- incline.nvim
loadColorSet({
	InclineNormal = { fg = c.nord4, bg = "NONE" },
	InclineNormalNC = { fg = c.nord4, bg = "NONE" },
	InclineGrapple = { fg = c.nord13, bg = "NONE" },
})

-- mini.hipatterns
loadColorSet({
	MiniHipatternsDebugStatement = { fg = c.nord12 },
})

-- filetypes/oil.lua
loadColorSet({
	OilGitAdded = { fg = c.nord14, bg = "NONE" },
	OilGitModified = { fg = c.nord13, bg = "NONE" },
	OilGitDeleted = { fg = c.nord11, bg = "NONE" },
	OilGitRenamed = { fg = c.nord13, bg = "NONE" },
	OilGitUntracked = { fg = c.nord14, bg = "NONE" },
	OilGitIgnored = { fg = c.nord3_500, bg = "NONE" },
})

-- hlslens.nvim
loadColorSet({
	HlSearchLens = { fg = c.nord3_700, bg = "NONE" },
	HlSearchLensNear = { fg = c.nord13, bg = "NONE" },
})

-- portal.nvim
loadColorSet({
	PortalLabel = { fg = c.nord0, bg = c.nord8 },
})

-- other.nvim
loadColorSet({
	OtherUnderlined = { fg = c.nord12, bg = c.neutral_900 },
})

-- snacks.nvim
loadColorSet({
	SnacksIndentScope = { fg = c.nord3_500 },
	SnacksPickerDir = { fg = c.nord3_500 },
	SnacksPickerMatch = { fg = c.nord4, bg = c.nord3 },
})

-- treesitter-context
loadColorSet({
	TreesitterContextSeparator = { fg = c.neutral_800 },
})

-- visual-whitespace.nvim
loadColorSet({
	VisualNonText = { fg = c.nord3_700, bg = c.nord1 },
})

-- winshift.nvim
loadColorSet({
	WinShiftFocused = { bg = c.neutral_800 },
	WinShiftWindowPicker = { fg = c.nord0, bg = c.nord9 },
})

-- yanky
loadColorSet({
	YankyPut = { link = "IncSearch" },
	YankyYanked = { link = "IncSearch" },
})
