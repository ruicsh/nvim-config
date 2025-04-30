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
				expand = "<c-e>",
				jump_next = "",
				jump_prev = "",
				stop = "<c-c>",
			},
		})
	end,

	event = "InsertEnter",
}
