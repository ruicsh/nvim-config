-- Jump to next/previous single character
-- https://github.com/echasnovski/mini.jump

return {
	"echasnovski/mini.jump",
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
