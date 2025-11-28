-- Prevents LSP and Treesitter attaching to a very large buffer.
-- https://github.com/folke/snacks.nvim/blob/main/docs/bigfile.md

return {
	"folke/snacks.nvim",
	opts = {
		bigfile = {
			enabled = false,
			notify = true,
			size = 100 * 1024, -- 100 KB
			line_length = 1000,
			setup = function(ctx)
				if vim.fn.exists(":NoMatchParen") ~= 0 then
					vim.cmd([[NoMatchParen]])
				end

				Snacks.util.wo(0, {
					foldenable = false,
					statuscolumn = "",
					conceallevel = 0,
				})

				vim.b.completion = false
				vim.b.minihipatterns_disable = true

				vim.schedule(function()
					if vim.api.nvim_buf_is_valid(ctx.buf) then
						vim.bo[ctx.buf].syntax = ctx.ft
					end
				end)
			end,
		},
	},
}
