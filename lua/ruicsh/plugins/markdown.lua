return {
	{ -- Mardown editing (render-markdown.nvim)
		-- https://github.com/MeanderingProgrammer/render-markdown.nvim
		"meanderingprogrammer/render-markdown.nvim",
		opts = {
			heading = {
				backgrounds = {},
			},
		},

		ft = { "markdown" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},

	{ -- Markdown preview (markdown-preview.nvim)
		-- https://github.com/iamcco/markdown-preview.nvim
		"iamcco/markdown-preview.nvim",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,

		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && npm install",
		ft = { "markdown" },
	},
}
