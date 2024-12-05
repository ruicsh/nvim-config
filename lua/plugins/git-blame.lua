-- Git blame (git-blame.nvim).
-- https://github.com/f-person/git-blame.nvim

return {
	"f-person/git-blame.nvim",
	opts = {
		enabled = true,
		message_template = "<summary> • <date> • <author>",
		date_format = "%r",
		message_when_not_committed = "Not commited yet",
		ignored_filetypes = { "term" },
	},

	event = { "VeryLazy" },
}
