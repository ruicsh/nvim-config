-- Insert log statements
-- https://github.com/Goose97/timber.nvim

local templates_js = {
	log_templates = {
		default = [[console.warn("%print_tag: %log_target=", %log_target)]],
		plain = [[console.warn("%print_tag: (%after %snippet)")]],
	},
	batch = {
		default = [[console.warn("%print_tag", { %repeat<"%log_target": %log_target><, > })]],
	},
}

return {
	"Goose97/timber.nvim",
	opts = {
		keymaps = {
			insert_log_below = "glv",
			insert_log_above = "glV",
			insert_plain_log_below = "glp",
			insert_plain_log_above = "glP",
			add_log_targets_to_batch = "gla",
			insert_batch_log = "glb",
		},
		template_placeholders = {
			print_tag = "ruic",
			snippet = function()
				return vim.trim(vim.fn.getline(".")):gsub('"', ""):sub(1, 50)
			end,
			placement = function(ctx)
				return ctx.log_position == "above" and "before" or "after"
			end,
		},
		log_templates = {
			default = {
				javascript = templates_js.log_templates.default,
				jsx = templates_js.log_templates.default,
				lua = [[print("%print_tag: %filename:%line_number %log_target=" .. vim.inspect(%log_target))]],
				tsx = templates_js.log_templates.default,
				typescript = templates_js.log_templates.default,
				typescriptreact = templates_js.log_templates.default,
			},
			plain = {
				javascript = templates_js.log_templates.plain,
				jsx = templates_js.log_templates.plain,
				lua = [[print("%print_tag: %filename:%line_number (%placement %snippet)")]],
				tsx = templates_js.log_templates.plain,
				typescript = templates_js.log_templates.plain,
				typescriptreact = templates_js.log_templates.plain,
			},
		},
		batch_log_templates = {
			default = {
				javascript = templates_js.batch.default,
				typescript = templates_js.batch.default,
				jsx = templates_js.batch.default,
				tsx = templates_js.batch.default,
				lua = [[print("%print_tag: " .. vim.inspect({ %repeat<["%log_target"] = vim.inspect(%log_target)><, > }))]],
			},
		},
	},

	event = { "VeryLazy" },
}
