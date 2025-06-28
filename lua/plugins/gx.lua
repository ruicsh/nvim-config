-- Implementation of gx without the need of netrw
-- https://github.com/chrishrb/gx.nvim

return {
	"chrishrb/gx.nvim",
	keys = function()
		local mappings = {
			{ "gx", "<cmd>Browse<cr>", "Open file/url at cursor", mode = { "n", "x" } },
		}

		return vim.fn.get_lazy_keys_conf(mappings)
	end,
	opts = {
		handlers = {
			js_imports = {
				-- JavaScript imports: import { foo } from 'package_name'
				name = "js_imports",
				filetype = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
				handle = function(_, line, _)
					local package_pattern = "[\"']([^\"']+)"
					local import_patterns = {
						-- import * as foobar from 'package_name'
						"^import%s*%*%s*as%s*%w+%s*from%s*" .. package_pattern,
						-- import { foobar } from 'package_name'
						"^import%s*{[^}]*}%s*from%s*" .. package_pattern,
						-- import Foobar from 'package_name'
						"^import%s*%w+%s*from%s*" .. package_pattern,
						-- import 'package_name'
						"^import%s*" .. package_pattern,
					}

					for _, pattern in ipairs(import_patterns) do
						local package_name = line:match(pattern)
						if package_name then
							if package_name:match("^[.]/") then
								-- The package is a local file
								local current_file = vim.fn.expand("%:p")
								local current_dir = vim.fn.fnamemodify(current_file, ":h")
								local path = current_dir .. "/" .. package_name
								local file = vim.fn.fnameescape(path)

								-- The file is already there
								if vim.fn.filereadable(file) == 1 then
									vim.cmd("edit " .. file)
									return true
								end

								-- Try out these extensions: .js, .ts, .jsx, .tsx
								local extensions = { ".js", ".ts", ".jsx", ".tsx" }
								for _, ext in ipairs(extensions) do
									if vim.fn.filereadable(file .. ext) == 1 then
										file = file .. ext
										break
									end
								end

								vim.cmd("edit " .. file)
								return true
							else
								return "https://www.npmjs.com/package/" .. package_name
							end
						end
					end
					return false
				end,
			},
			markdown_link = {
				-- Markdown links: [text](url)
				name = "markdown_link",
				filetype = { "markdown", "copilot-chat" },
				handle = function(mode, line, _)
					local pattern = "%[[%a%d%s.,?!:;@_{}~]*%]%((https?://[a-zA-Z0-9_/%-%.~@\\+#=?&]+)%)"
					return require("gx.helper").find(line, mode, pattern)
				end,
			},
			markdown_ref = {
				-- Markdown references: [text][path]
				name = "markdown_ref",
				filetype = { "markdown", "copilot-chat" },
				handle = function(_, line, _)
					local text, path = line:match("%[([^%]]+)%]%[([^%]]+)%]")
					if text and path then
						local expanded_path = vim.fn.expand(path)
						vim.cmd("edit " .. vim.fn.fnameescape(expanded_path))
						return true
					end
				end,
			},
			python_imports = {
				-- Python imports: from pkg import module / import pkg
				name = "python_imports",
				filetype = { "python" },
				handle = function(_, line, _)
					local package = line:match("^from%s+([^%s]+)") or line:match("^import%s+([^%s]+)")
					if package then
						return "https://pypi.org/project/" .. package
					end
				end,
			},
			python_requirements = {
				-- Python packages: pkg==version
				name = "python_requirements",
				filename = "requirements.txt",
				handle = function(_, line, _)
					local package = line:match("^([^%s=]+)")
					if package then
						return "https://pypi.org/project/" .. package
					end
				end,
			},
		},
	},
	config = function(_, opts)
		local gx = require("gx")

		if vim.fn.env_get("USE_EDGE_BROWSER") == "true" then
			opts.open_browser_app = "cmd.exe"
			opts.open_browser_args = { "/C", "start", 'microsoft-edge:"%s"' }
		end

		gx.setup(opts)
	end,
	init = function()
		vim.g.netrw_nogx = 1
	end,
}
