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
k("n", "-", ac("workbench.files.action.focusFilesExplorer"))

-- Search
k("n", "<leader>/", ac("workbench.action.findInFiles"))

-- Buffers
k("n", "<bs>", ac("workbench.action.openPreviousRecentlyUsedEditorInGroup"))
k("n", "<s-bs>", ac("workbench.action.openNextRecentlyUsedEditorInGroup"))
k("n", "<leader>,", ac("workbench.action.showAllEditors"))

-- Splits
k("n", "|", ac("workbench.action.focusNextGroup"))
k("n", "<c-w>=", ac("workbench.action.toggleMaximizeEditorGroup"))
k("n", "<c-w>q", ac("workbench.action.closeActiveEditor"))
k("n", "<c-w>r", ac("workbench.action.moveEditorToNextGroup"))
k("n", "<c-w>s", ac("workbench.action.splitEditorDown"))
k("n", "<c-w>v", ac("workbench.action.splitEditorRight"))
k("n", "<c-w>w", ac("workbench.action.focusNextGroup"))
k("n", "<c-w>|", ac("workbench.action.toggleMaximizeEditorGroup"))

-- LSP
k("n", "<c-]>", ac("editor.action.revealDefinition"))
k("n", "grt", ac("editor.action.goToTypeDefinition"))
k("n", "grr", ac("references-view.findReferences"))
k("n", "gO", ac("workbench.action.gotoSymbol"))
k("n", "[r", ac("editor.action.wordHighlight.prev"))
k("n", "]r", ac("editor.action.wordHighlight.next"))

-- Folds
k("n", "<tab>", ac("editor.toggleFold"))

-- Git
k({ "n", "x" }, "<leader>hh", ac("workbench.view.scm"))
k("n", "[h", ac("workbench.action.editor.previousChange"))
k("n", "]h", ac("workbench.action.editor.nextChange"))
k("n", "ghh", ac("git.stageSelectedRanges"))
k("n", "gHh", ac("git.revertSelectedRanges"))

-- Extension
k("n", "<c-l>", ac("vscode-neovim.restart"))
