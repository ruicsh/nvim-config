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
			search = false,
			vim_help = {
				name = "vim_help",
				handle = function(_, line, _)
					-- Match :h or :help followed by help tag
					local help_tag = line:match(":h%s+([%w_%-%.%:']+)") or line:match(":help%s+([%w_%-%.%:']+)")
					if help_tag then
						vim.cmd("help " .. help_tag)
						return true
					end

					-- Match standalone help tags like |i_ctrl-a|
					local tag = line:match("|([%w_%-%.%:']+)|")
					if tag then
						vim.cmd("help " .. help_tag)
						return true
					end

					return false
				end,
			},
		},
	},
	config = function(_, opts)
		local gx = require("gx")

		-- We're probably running in a Windows environment or in a WSL environment
		if vim.fn.env_get("USE_BROWSER") == "edge" then
			local is_wsl = os.getenv("WSL_DISTRO_NAME") ~= nil
			local is_windows = vim.fn.has("win32") == 1 and not is_wsl
			-- Needs full path when running on CommandPrompt
			local browser_app = is_windows and "C:\\Windows\\System32\\cmd.exe" or "cmd.exe"
			opts.open_browser_app = browser_app
			opts.open_browser_args = { "/C", "start", 'microsoft-edge:"%s"' }
		end

		gx.setup(opts)
	end,
	init = function()
		vim.g.netrw_nogx = 1
	end,

	cmd = { "Browse" },
}
