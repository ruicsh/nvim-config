-- TypeScript LSP Code Actions

local augroup = vim.api.nvim_create_augroup("ruicsh/typescript/lsp-code-actions", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	pattern = "*.ts,*.tsx",
	callback = function()
		local function code_action(action)
			return function()
				vim.lsp.buf.code_action({
					context = { only = { action } },
					apply = true,
				})
			end
		end

		local mappings = {
			{ "<leader>im", "source.addMissingImports.ts", "TS: Add Missing Imports" },
			{ "<leader>io", "source.organizeImports.ts", "TS: Organize Imports" },
			{ "<leader>ir", "source.removeUnused.ts", "TS: Remove Unused" },
			{ "<leader>is", "source.sortImports.ts", "TS: Sort Imports" },
			{ "<leader>iu", "source.removeUnusedImports.ts", "TS: Organize Imports" },
		}

		for _, mapping in ipairs(mappings) do
			local key, action, desc = unpack(mapping)
			vim.keymap.set("n", key, code_action(action), { desc = desc, buffer = 0 })
		end
	end,
})
