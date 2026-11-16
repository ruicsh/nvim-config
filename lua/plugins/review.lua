-- Code review annotations over codediff
-- https://github.com/georgeguimaraes/review.nvim

return {
	"georgeguimaraes/review.nvim",
	opts = {
		comment_types = {
			note = { icon = "☷" },
			suggestion = { icon = "☳" },
			issue = { icon = "☵" },
			praise = { icon = "☰" },
		},
		export = {
			header = "I reviewed your code and have the following comments. Please address them.\nLines prefixed with `~` refer to the old side of the diff.",
		},
	},

	event = "VeryLazy",
	version = "*",
	dependencies = {
		"esmuellert/codediff.nvim",
		"MunifTanjim/nui.nvim",
	},
}
