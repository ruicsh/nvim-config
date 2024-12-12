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

-- [[ NORMAL MODE ]]

-- Native
k("n", "<leader>vb", ac("workbench.action.toggleSidebarVisibility"))
k("n", "<c-\\>", ac("workbench.action.terminal.new"))
k("n", "<leader>nc", ac("workbench.action.showCommands"))

-- Explorer
k("n", "\\", ac("workbench.files.action.focusFilesExplorer"))
k("n", "<leader><leader>", ac("workbench.action.quickOpen"))

-- Settings
k("n", "<leader>nk", ac("workbench.action.openGlobalKeybindings"))
k("n", "<leader>nK", ac("workbench.action.openGlobalKeybindingsFile"))
k("n", "<leader>n,", ac("workbench.action.openGlobalSettings"))
k("n", "<leader>n<", ac("workbench.action.openSettingsJson"))

-- Search
k("n", "<leader>sr", ac("actions.find"))
k("n", "<leader>f", ac("workbench.action.findInFiles"))

-- Opened files
k("n", "[b", ac("workbench.action.previousEditorInGroup"))
k("n", "]b", ac("workbench.action.nextEditorInGroup"))
k("n", "<bs>", ac("workbench.action.openPreviousRecentlyUsedEditor"))
k("n", "<s-bs>", ac("workbench.action.openNextRecentlyUsedEditor"))
k("n", "§", ac("workbench.action.showAllEditors"))
k("n", "<leader>bc", ac("workbench.action.closeActiveEditor"))
k("n", "<leader>bC", ac("workbench.action.closeAllEditors"))
k("n", "<leader>bo", ac("workbench.action.closeOtherEditors"))

-- Splits
k("n", "|", ac("workbench.action.focusNextGroup"))
k("n", "<c-w>v", ac("workbench.action.splitEditorRight"))
k("n", "<c-w>|", ac("workbench.action.splitEditorRight"))
k("n", "<c-w>s", ac("workbench.action.splitEditorDown"))
k("n", "<c-w>m", ac("workbench.action.toggleMaximizeEditorGroup"))
k("n", "<c-w>[", ac("workbench.action.moveEditorToLeftGroup"))
k("n", "<c-w>]", ac("workbench.action.moveEditorToRightGroup"))

-- LSP
k("n", "go", ac("editor.action.goToTypeDefinition"))
k("n", "gr", ac("references-view.findReferences"))
k("n", "gy", ac("workbench.action.gotoSymbol"))
k("n", "gY", ac("workbench.action.showAllSymbols"))
k("n", "[r", ac("editor.action.wordHighlight.prev"))
k("n", "]r", ac("editor.action.wordHighlight.next"))

-- LSP - TypeScript
k("n", "<leader>to", ac("editor.action.organizeImports"))
k("n", "<leader>ts", ac("typescript.sortImports"))
k("n", "<leader>tu", ac("typescript.removeUnusedImports"))
k("n", "<leader>td", ac("typescript.goToSourceDefinition"))

-- Syntax
k({ "n", "x" }, "[n", ac("editor.action.smartSelect.expand"))
k({ "n", "x" }, "]n", ac("editor.action.smartSelect.shrink"))

-- Folds
k("n", "za", ac("editor.toggleFold"))
k("n", "zA", ac("editor.toggleFoldRecursively"))
k("n", "zC", ac("editor.foldRecursively"))
k("n", "zM", ac("editor.foldAll"))
k("n", "zO", ac("editor.unfoldRecursively"))
k("n", "zR", ac("editor.unfoldAll"))
k("n", "zc", ac("editor.fold"))
k("n", "zo", ac("editor.unfold"))
k("n", "[z", ac("editor.gotoParentFold"))
k("n", "zk", ac("editor.gotoPreviousFold"))
k("n", "zj", ac("editor.gotoNextFold"))

-- Pinned tabs
k("n", "§1", ac("vscode-harpoon.gotoEditor1"))
k("n", "$2", ac("vscode-harpoon.gotoEditor2"))
k("n", "$3", ac("vscode-harpoon.gotoEditor3"))
k("n", "$4", ac("vscode-harpoon.gotoEditor4"))
k("n", "$5", ac("vscode-harpoon.gotoEditor5"))
k("n", "$6", ac("vscode-harpoon.gotoEditor6"))
k("n", "$7", ac("vscode-harpoon.gotoEditor7"))
k("n", "$8", ac("vscode-harpoon.gotoEditor8"))
k("n", "$9", ac("vscode-harpoon.gotoEditor9"))
k("n", "<leader>ja", ac("vscode-harpoon.addEditor"))
k("n", "<leader>jh", ac("vscode-harpoon.editEditors"))
k("n", "<leader>jn", ac("vscode-harpoon.navigateNextEditor"))
k("n", "<leader>jp", ac("vscode-harpoon.navigatePreviousEditor"))

-- Git
k({ "n", "x" }, "<leader>hh", ac("workbench.view.scm"))
k({ "n", "x" }, "<leader>hs", ac("git.stageSelectedRanges"))
k({ "n", "x" }, "<leader>hu", ac("git.unstageSelectedRanges"))
k({ "n", "x" }, "<leader>hr", ac("git.revertSelectedRanges"))
k("n", "<leader>hS", ac("git.stage"))
k("n", "<leader>hU", ac("git.unstage"))
k("n", "<leader>hR", ac("workbench.action.files.revert"))
k("n", "<leader>hb", ac("gitlens.toggleFileBlame"))
k("n", "<leader>hv", ac("git.openChange"))
k("n", "[c", ac("workbench.action.editor.previousChange"))
k("n", "]c", ac("workbench.action.editor.nextChange"))

-- [[ VISUAL MODE ]]

-- Native
k("x", "<leader>so", ac("editor.action.sortLinesAscending"))
k("x", "<leader>sr", ac("actions.find"))
