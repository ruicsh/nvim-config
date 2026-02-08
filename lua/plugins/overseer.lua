-- Task runner and job management
-- https://github.com/stevearc/overseer.nvim/

return {
	"stevearc/overseer.nvim",
	keys = {
		{ "<leader>oo", "<cmd>OverseerToggle<cr>", desc = "Task list" },
		{ "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run task" },
		{ "<leader>os", "<cmd>OverseerShell<cr>", desc = "Shell" },
		{ "<leader>ot", "<cmd>OverseerTaskAction<cr>", desc = "Task action" },
	},
	opts = {},
	cmd = {
		"OverseerToggle",
		"OverseerRun",
		"OverseerShell",
		"OverseerTaskAction",
	},
}
