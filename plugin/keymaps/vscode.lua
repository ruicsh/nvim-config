if not vim.g.vscode then
	return
end

local k = vim.keymap.set

-- run vscode action
local function ac(action)
	return function()
		require("vscode").action(action)
	end
end

-- Explorer
k("n", "<leader><space>", ac("workbench.action.quickOpen"))
k("n", "<leader>ee", ac("workbench.files.action.focusFilesExplorer"))

-- Search
k("n", "<leader>ff", ac("workbench.action.findInFiles"))

-- Buffers
k("n", "[b", ac("workbench.action.previousEditorInGroup"))
k("n", "]b", ac("workbench.action.nextEditorInGroup"))
k("n", "<bs>", ac("workbench.action.openPreviousRecentlyUsedEditor"))
k("n", "<s-bs>", ac("workbench.action.openNextRecentlyUsedEditor"))
k("n", "<leader>,", ac("workbench.action.showAllEditors"))

-- Splits
k("n", "|", ac("workbench.action.focusNextGroup"))
k("n", "<c-w>|", ac("workbench.action.toggleMaximizeEditorGroup"))
k("n", "<c-w>[", ac("workbench.action.moveEditorToLeftGroup"))
k("n", "<c-w>]", ac("workbench.action.moveEditorToRightGroup"))

-- LSP
k("n", "<cr>", ac("editor.action.revealDefinition"))
k("n", "grt", ac("editor.action.goToTypeDefinition"))
k("n", "grr", ac("references-view.findReferences"))
k("n", "gy", ac("workbench.action.gotoSymbol"))
k("n", "gO", ac("workbench.action.showAllSymbols"))
k("n", "[r", ac("editor.action.wordHighlight.prev"))
k("n", "]r", ac("editor.action.wordHighlight.next"))

-- Folds
k("n", "<tab>", ac("editor.toggleFold"))

-- Git
k({ "n", "x" }, "<leader>hh", ac("workbench.view.scm"))

-- Copilot
k("n", "<leader>aa", ac("workbench.action.openQuickChat"))
k("v", "<leader>ae", ac("github.copilot.chat.explain"))
k("v", "<leader>af", ac("github.copilot.chat.fix"))
k("v", "<leader>ar", ac("github.copilot.chat.review"))
k("v", "<leader>ar", ac("github.copilot.chat.generateTests"))
