-- package.json dependency versions
-- https://github.com/vuki656/package-info.nvim

return {
	"vuki656/package-info.nvim",
	opts = {
		hide_up_to_date = true,
		icons = {
			enable = false,
		},
	},

	event = "BufEnter package.json",
}
