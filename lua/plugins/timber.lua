-- Insert log statements
-- https://github.com/Goose97/timber.nvim

local templates_js = {
	log = {
		default = [[console.log("%print_tag: %log_target=", %log_target)]],
		plain = [[console.log("%print_tag: (%placement %snippet)")]],
		time = [[console.log(new Date().toISOString())]],
	},
	batch = {
		default = [[console.log("%print_tag", { %repeat<"%log_target": %log_target><, > })]],
	},
}

local counter = 0

return {
	"Goose97/timber.nvim",
	keys = function()
		local actions = require("timber.actions")

		local function insert_time_log(position)
			return function()
				local template = position == "surround" and "default" or "time"
				local templates = position == "surround" and { before = "time", after = "time" } or {}

				actions.insert_log({
					template = template,
					templates = templates,
					position = position,
				})
			end
		end

		local function insert_breakpoint(position)
			return function()
				actions.insert_log({
					template = "breakpoint",
					position = position,
				})
			end
		end

		local mappings = {
			{ "glk", insert_breakpoint("below"), "Insert debugger statement (below)" },
			{ "glK", insert_breakpoint("above"), "Insert debugger statement (above)" },
			{ "glt", insert_time_log("below"), "Timestamp below" },
			{ "glT", insert_time_log("above"), "Timestamp above" },
			{ "<leader>glt", insert_time_log("surround"), "Timestamp above/below" },
		}

		return vim.fn.get_lazy_keys_config(mappings, "Logs")
	end,
	opts = {
		keymaps = {
			add_log_targets_to_batch = "gla",
			add_log_targets_to_batch_operator = "g<s-l>a",
			insert_batch_log = "glb",
			insert_batch_log_operator = "g<s-l>b",
			insert_log_above = "glV",
			insert_log_above_operator = "glO",
			insert_log_below = "glv",
			insert_log_below_operator = "glo",
			insert_plain_log_above = "glP",
			insert_plain_log_below = "glp",
		},
		template_placeholders = {
			print_tag = function()
				counter = counter + 1
				return "ruic[" .. counter .. "]"
			end,
			snippet = function()
				return vim.trim(vim.fn.getline(".")):gsub('"', ""):gsub("'", ""):gsub("\\", ""):sub(1, 50)
			end,
			placement = function(ctx)
				return ctx.log_position == "above" and "before" or "after"
			end,
		},
		log_templates = {
			breakpoint = {
				javascript = "debugger;",
				jsx = "debugger;",
				python = "import pdb; pdb.set_trace()",
				rust = "std::intrinsics::breakpoint();",
				tsx = "debugger;",
				typescript = "debugger;",
				typescriptreact = "debugger;",
			},
			default = {
				javascript = templates_js.log.default,
				jsx = templates_js.log.default,
				lua = [[print("%print_tag: %filename:%line_number %log_target=" .. vim.inspect(%log_target))]],
				python = [[print(f"%print_tag: {%log_target=}")]],
				rust = [[println!("%print_tag: %log_target: {:#?}", %log_target);]],
				tsx = templates_js.log.default,
				typescript = templates_js.log.default,
				typescriptreact = templates_js.log.default,
			},
			plain = {
				javascript = templates_js.log.plain,
				jsx = templates_js.log.plain,
				lua = [[print("%print_tag: %filename:%line_number (%placement %snippet)")]],
				python = [[print(f"%print_tag: %filename:%line_number (%placement %snippet)")]],
				rust = [[println!("%print_tag: %filename:%line_number (%placement %snippet)");]],
				tsx = templates_js.log.plain,
				typescript = templates_js.log.plain,
				typescriptreact = templates_js.log.plain,
			},
			time = {
				javascript = templates_js.log.time,
				jsx = templates_js.log.time,
				lua = [[print(os.date("!%Y-%m-%dT%H:%M:%SZ"))]],
				tsx = templates_js.log.time,
				typescript = templates_js.log.time,
				typescriptreact = templates_js.log.time,
			},
		},
		batch_log_templates = {
			default = {
				javascript = templates_js.batch.default,
				jsx = templates_js.batch.default,
				lua = [[print("%print_tag: " .. vim.inspect({ %repeat<["%log_target"] = vim.inspect(%log_target)><, > }))]],
				python = [[print(f"%print_tag: %repeat<{%log_target=}><, >")]],
				rust = [[println!("%print_tag: %repeat<%log_target: {:#?}><, >", %log_target);]],
				tsx = templates_js.batch.default,
				typescript = templates_js.batch.default,
				typescriptreact = templates_js.batch.default,
			},
		},
	},
}
