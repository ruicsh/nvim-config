-- Highlight patterns in text.
-- https://github.com/nvim-mini/mini.hipatterns

return {
	"nvim-mini/mini.hipatterns",
	-- mini.hipatterns scans changed lines in Lua, and the `.*...$` patterns
	-- below are O(n^2) on a single very long line. rest.nvim puts raw response
	-- bodies (large JSON = one huge line) into its result panes, which freezes
	-- Neovim, so opt those buffers out.
	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("ruicsh/mini.hipatterns", { clear = true }),
			pattern = "rest_nvim_result",
			callback = function(args)
				vim.b[args.buf].minihipatterns_disable = true
			end,
		})
	end,
	opts = function()
		local hi = require("mini.hipatterns")

		return {
			highlighters = {
				hex_color = hi.gen_highlighter.hex_color({ priority = 2000 }),
				shorthand = {
					pattern = "()#%x%x%x()%f[^%x%w]",
					group = function(_, _, data)
						local match = data.full_match
						local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
						local hex_color = "#" .. r .. r .. g .. g .. b .. b

						return hi.compute_hex_color_group(hex_color, "bg")
					end,
					extmark_opts = { priority = 2000 },
				},
				debuglog = {
					pattern = "().*ruic%[%d+%].*()$",
					group = "MiniHipatternsDebugStatement",
					extmark_opts = { priority = 2000 },
				},
				cssdebug = {
					pattern = "().*hotpink.*()$",
					group = "MiniHipatternsDebugStatement",
					extmark_opts = { priority = 2000 },
				},
			},
		}
	end,
}
