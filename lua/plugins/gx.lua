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
			markdown = {
				-- Markdown links: [text](url)
				name = "markdown",
				filetype = { "markdown", "copilot-chat" },
				handle = function(mode, line, _)
					local pattern = "%[[%a%d%s.,?!:;@_{}~]*%]%((https?://[a-zA-Z0-9_/%-%.~@\\+#=?&]+)%)"
					return require("gx.helper").find(line, mode, pattern)
				end,
			},
			-- Markdown references: [text][path]
			markdown_ref = {
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
			-- Python packages: pkg==version
			python_requirements = {
				name = "python_requirements",
				filename = "requirements.txt",
				handle = function(_, line, _)
					local package = line:match("^([^%s=]+)")
					if package then
						return "https://pypi.org/project/" .. package
					end
				end,
			},
			-- Python imports: from pkg import module / import pkg
			python_imports = {
				name = "python_imports",
				filetype = { "python" },
				handle = function(_, line, _)
					local package = line:match("^from%s+([^%s]+)") or line:match("^import%s+([^%s]+)")
					if package then
						return "https://pypi.org/project/" .. package
					end
				end,
			},
		},
	},
	init = function()
		vim.g.netrw_nogx = 1
	end,

	cmd = { "Browse" },
}
