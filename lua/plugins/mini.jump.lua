-- Jump to next/previous single character
-- https://github.com/nvim-mini/mini.jump

return {
	"nvim-mini/mini.jump",
	opts = {
		mappings = {
			forward = "f",
			backward = "F",
			forward_till = "t",
			backward_till = "T",
			repeat_jump = ";",
		},
		delay = {
			highlight = 10000000,
			idle_stop = 2000,
		},
	},
}
