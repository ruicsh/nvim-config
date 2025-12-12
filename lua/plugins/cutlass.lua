-- Cut operation (separate from 'delete').
-- https://github.com/gbprod/cutlass.nvim

return {
	"gbprod/cutlass.nvim",
	opts = {
		cut_key = "x",
		override_del = nil,
		exclude = {},
		registers = {
			select = "_",
			delete = "_",
			change = "_",
		},
	},
}
