-- Open alternative files for the current buffer
-- https://github.com/rgroli/other.nvim

return {
	"rgroli/other.nvim",
	keys = function()
		local mappings = {
			{ "==", "<cmd>:Other<cr>", "" },
			{ "=<space>", "<cmd>:Other source<cr>", "" },
			{ "=s", "<cmd>:Other style<cr>", "" },
			{ "=b", "<cmd>:Other test<cr>", "" },
			{ "=m", "<cmd>:Other template<cr>", "" },
			{ "=y", "<cmd>:Other story<cr>", "" },
		}

		return vim.fn.get_lazy_keys_config(mappings, "Alternate")
	end,
	opts = {
		mappings = {
			{ -- react (source)
				pattern = "(.*).tsx$",
				target = {
					{ target = "%1.module.scss", context = "style" },
					{ target = "styles.module.scss", context = "style" },
					{ target = "%1.scss", context = "style" },
					{ target = "%1.test.tsx", context = "test" },
					{ target = "%1.stories.tsx", context = "story" },
				},
			},
			{ -- react (test)
				pattern = "(.*).test.tsx$",
				target = {
					{ target = "%1.tsx", context = "source" },
					{ target = "%1.ts", context = "source" },
					{ target = "%1.module.scss", context = "style" },
					{ target = "%1.scss", context = "style" },
					{ target = "%1.stories.tsx", context = "story" },
				},
			},
			{ -- react/scss (style)
				pattern = "(.*).scss$",
				target = {
					{ target = "%1.tsx", context = "source" },
					{ target = "%1.test.tsx", context = "test" },
					{ target = "%1.stories.tsx", context = "story" },
				},
			},
			{ -- react/css.modules (style)
				pattern = "(.*).module.scss$",
				target = {
					{ target = "%1.tsx", context = "source" },
					{ target = "%1.test.tsx", context = "test" },
					{ target = "%1.story.tsx", context = "story" },
				},
			},
			{ -- react (story)
				pattern = "(.*).stories.tsx$",
				target = {
					{ target = "%1.tsx", context = "source" },
					{ target = "%1.test.tsx", context = "test" },
					{ target = "%1.module.scss", context = "style" },
					{ target = "%1.scss", context = "style" },
				},
			},
			{ -- typescript
				pattern = "(.*).ts$",
				target = {
					{ target = "%1.test.ts", context = "test" },
					{ target = "%1.test.tsx", context = "test" },
				},
			},
			{ -- typescript (test)
				pattern = "(.*).test.ts$",
				target = {
					{ target = "%1.ts", context = "source" },
					{ target = "%1.tsx", context = "source" },
				},
			},
			{ -- angular (source)
				pattern = "(.*).component.ts$",
				target = {
					{ target = "%1.component.html", context = "template" },
					{ target = "%1.component.scss", context = "style" },
					{ target = "%1.component.test.ts", context = "test" },
				},
			},
			{ -- angular (style)
				pattern = "(.*).component.scss$",
				target = {
					{ target = "%1.component.ts", context = "source" },
					{ target = "%1.component.html", context = "template" },
					{ target = "%1.component.test.ts", context = "test" },
				},
			},
			{ -- angular (template)
				pattern = "(.*).component.html$",
				target = {
					{ target = "%1.component.ts", context = "source" },
					{ target = "%1.component.scss", context = "style" },
					{ target = "%1.component.test.ts", context = "test" },
				},
			},
		},
		showMissingFiles = false,
		style = {
			border = "rounded",
		},
	},

	main = "other-nvim",
	cmd = "Other",
}
