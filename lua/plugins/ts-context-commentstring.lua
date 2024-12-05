-- Comments on embbeded languages (ex: html inside ts, css inside html)
-- https://github.com/JoosepAlviste/nvim-ts-context-commentstring

return {
	"JoosepAlviste/nvim-ts-context-commentstring",
	config = function()
		local comment = require("ts_context_commentstring")
		comment.setup({
			enable_autocmd = false,
			languages = {
				typescript = {
					template_string = "<!-- %s -->", -- angular's inline templates
				},
			},
		})

		local original_get_option = vim.filetype.get_option
		vim.filetype.get_option = function(filetype, option)
			return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
				or original_get_option(filetype, option)
		end
	end,

	event = { "VeryLazy" },
}
