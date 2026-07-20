-- Open alternative files for the current buffer
-- https://github.com/rgroli/other.nvim

return {
	"rgroli/other.nvim",
	keys = {
		{ "==", "<cmd>Other<cr>", desc = "Alternate: Open alternate file" },
		{ "=<space>", "<cmd>Other source<cr>", desc = "Alternate: Open source file" },
		{ "=s", "<cmd>Other style<cr>", desc = "Alternate: Open style file" },
		{ "=b", "<cmd>Other test<cr>", desc = "Alternate: Open test file" },
		{ "=m", "<cmd>Other template<cr>", desc = "Alternate: Open template file" },
		{ "=y", "<cmd>Other story<cr>", desc = "Alternate: Open story file" },
	},
	opts = {
		mappings = {
			{ -- angular (source)
				pattern = "(.*).component.ts$",
				target = {
					{ target = "%1.component.html", context = "template" },
					{ target = "%1.component.scss", context = "style" },
					{ target = "%1.component.test.ts", context = "test" },
					{ target = "%1.component.spec.ts", context = "test" },
				},
			},
			{ -- angular (style)
				pattern = "(.*).component.scss$",
				target = {
					{ target = "%1.component.ts", context = "source" },
					{ target = "%1.component.html", context = "template" },
					{ target = "%1.component.test.ts", context = "test" },
					{ target = "%1.component.spec.ts", context = "test" },
				},
			},
			{ -- angular (template)
				pattern = "(.*).component.html$",
				target = {
					{ target = "%1.component.ts", context = "source" },
					{ target = "%1.component.scss", context = "style" },
					{ target = "%1.component.test.ts", context = "test" },
					{ target = "%1.component.spec.ts", context = "test" },
				},
			},
			{ -- typescript (test/spec)
				pattern = function(file)
					local base = file:match("(.*)%.test%.ts$")
					if base then return { base } end
					base = file:match("(.*)%.spec%.ts$")
					if base then return { base } end
					return nil
				end,
				target = {
					{ target = "%1.ts", context = "source" },
					{ target = "%1.tsx", context = "source" },
					{ target = "%1.test.ts", context = "test" },
					{ target = "%1.spec.ts", context = "test" },
					{ target = "%1.test.tsx", context = "test" },
					{ target = "%1.spec.tsx", context = "test" },
				},
			},
			{ -- typescript
				pattern = "(.*).ts$",
				target = {
					{ target = "%1.test.ts", context = "test" },
					{ target = "%1.test.tsx", context = "test" },
					{ target = "%1.spec.ts", context = "test" },
					{ target = "%1.spec.tsx", context = "test" },
				},
			},
			{ -- react (test/spec)
				pattern = function(file)
					local base = file:match("(.*)%.test%.tsx$")
					if base then return { base } end
					base = file:match("(.*)%.spec%.tsx$")
					if base then return { base } end
					return nil
				end,
				target = {
					{ target = "%1.tsx", context = "source" },
					{ target = "%1.ts", context = "source" },
					{ target = "%1.test.tsx", context = "test" },
					{ target = "%1.spec.tsx", context = "test" },
					{ target = "%1.module.scss", context = "style" },
					{ target = "%1.scss", context = "style" },
					{ target = "%1.stories.tsx", context = "story" },
				},
			},
			{ -- react (story)
				pattern = "(.*).stories.tsx$",
				target = {
					{ target = "%1.tsx", context = "source" },
					{ target = "%1.test.tsx", context = "test" },
					{ target = "%1.spec.tsx", context = "test" },
					{ target = "%1.module.scss", context = "style" },
					{ target = "%1.scss", context = "style" },
				},
			},
			{ -- react/css.modules (style)
				pattern = "(.*).module.scss$",
				target = {
					{ target = "%1.tsx", context = "source" },
					{ target = "%1.test.tsx", context = "test" },
					{ target = "%1.spec.tsx", context = "test" },
					{ target = "%1.story.tsx", context = "story" },
				},
			},
			{ -- react/scss (style)
				pattern = "(.*).scss$",
				target = {
					{ target = "%1.tsx", context = "source" },
					{ target = "%1.test.tsx", context = "test" },
					{ target = "%1.spec.tsx", context = "test" },
					{ target = "%1.stories.tsx", context = "story" },
				},
			},
			{ -- react (source)
				pattern = "(.*).tsx$",
				target = {
					{ target = "%1.module.scss", context = "style" },
					{ target = "styles.module.scss", context = "style" },
					{ target = "%1.scss", context = "style" },
					{ target = "%1.test.tsx", context = "test" },
					{ target = "%1.spec.tsx", context = "test" },
					{ target = "%1.stories.tsx", context = "story" },
				},
			},
		},
		showMissingFiles = false,
		style = {
			border = "rounded",
		},
	},

	main = "other-nvim",
}
