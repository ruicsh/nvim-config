-- Open alternative files for the current buffer
-- https://github.com/rgroli/other.nvim

return {
	"rgroli/other.nvim",
	keys = function()
		local mappings = {
			{ "==", "<cmd>:Other<cr>", "" },
			{ "=c", "<cmd>:Other component<cr>", "" },
			{ "=s", "<cmd>:Other style<cr>", "" },
			{ "=t", "<cmd>:Other test<cr>", "" },
			{ "=h", "<cmd>:Other html<cr>", "" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Alternate")
	end,
	opts = {
		mappings = {
			{ -- react
				pattern = "(.*).tsx$",
				target = {
					{ target = "%1.module.scss", context = "style" },
					{ target = "%1.module.less", context = "style" },
					{ target = "%1.module.css", context = "style" },
					{ target = "%1.test.tsx", context = "test" },
					{ target = "%1.spec.tsx", context = "test" },
				},
			},
			{ -- css modules
				pattern = "(.*).module.scss$",
				target = {
					{ target = "%1.tsx", context = "component" },
					{ target = "%1.ts", context = "component" },
					{ target = "%1.test.tsx", context = "test" },
					{ target = "%1.spec.tsx", context = "test" },
				},
			},
			{ -- typescript
				pattern = "(.*).ts$",
				target = {
					{ target = "%1.test.ts", context = "test" },
					{ target = "%1.spec.ts", context = "test" },
				},
			},
			{ -- angular (component)
				pattern = "(.*).component.ts$",
				target = {
					{ target = "%1.component.html", context = "html" },
					{ target = "%1.component.scss", context = "style" },
					{ target = "%1.component.less", context = "style" },
					{ target = "%1.component.css", context = "style" },
					{ target = "%1.component.spec.ts", context = "test" },
					{ target = "%1.component.test.ts", context = "test" },
				},
			},
			{ -- angular (style)
				pattern = "(.*).component.scss$",
				target = {
					{ target = "%1.component.html", context = "template" },
					{ target = "%1.component.ts", context = "component" },
					{ target = "%1.component.spec.ts", context = "test" },
					{ target = "%1.component.test.ts", context = "test" },
				},
			},
			{ -- angular (html)
				pattern = "(.*).component.html$",
				target = {
					{ target = "%1.component.scss", context = "style" },
					{ target = "%1.component.ts", context = "component" },
					{ target = "%1.component.spec.ts", context = "test" },
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
