-- Snippets
-- https://github.com/echasnovski/mini.snippets

return {
	"echasnovski/mini.snippets",
	config = function()
		local ms = require("mini.snippets")
		local gen_loader = ms.gen_loader

		ms.setup({
			snippets = {
				gen_loader.from_lang(),
			},
			mappings = {
				expand = "<c-;>",
				jump_next = "<c-;>",
				jump_prev = "<c-,>",
				stop = "<c-c>",
			},
			expand = {
				insert = function(snippet)
					return ms.default_insert(snippet, {
						empty_tabstop = "",
						empty_tabstop_final = "",
					})
				end,
			},
		})
	end,

	enabled = not vim.g.vscode,
	event = "InsertEnter",
}
