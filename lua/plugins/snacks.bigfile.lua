-- Prevents LSP and Treesitter attaching to a very large buffer.
-- https://github.com/folke/snacks.nvim/blob/main/docs/bigfile.md

return {
	"folke/snacks.nvim",
	opts = {
		bigfile = {
			enabled = true,
			notify = false,
			size = 1.5 * 1024 * 1024,
			line_length = 1000,
			setup = function(ctx)
				vim.schedule(function()
					Snacks.util.wo(0, {
						foldenable = false,
						statuscolumn = "",
						conceallevel = 0,
					})
					if vim.api.nvim_buf_is_valid(ctx.buf) then
						vim.bo[ctx.buf].syntax = ctx.ft
					end
				end)
			end,
		},
	},
}
