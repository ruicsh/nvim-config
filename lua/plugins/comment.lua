-- Comments.
-- https://github.com/numToStr/Comment.nvim

return {
	"numToStr/Comment.nvim",
	config = function()
		require("Comment").setup({
			pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
		})
	end,

	dependencies = {
		{
			-- Treesitter based commentstring.
			-- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
	},
}
