if not vim.g.vscode then
	return
end

local k = vim.keymap.set

-- Run vscode action
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
k("n", "gO", ac("workbench.action.gotoSymbol"))
k("n", "[r", ac("editor.action.wordHighlight.prev"))
k("n", "]r", ac("editor.action.wordHighlight.next"))

-- Folds
k("n", "<tab>", ac("editor.toggleFold"))

-- Git
k({ "n", "x" }, "<leader>hh", ac("workbench.view.scm"))
