-- Git client
-- https://github.com/tpope/vim-fugitive

local T = require("lib")

return {
	"tpope/vim-fugitive",
	keys = function()
		local function git_status()
			vim.cmd("tabnew")
			vim.cmd("vertical Git")
			vim.cmd("only")
		end

		local function git_diff_file()
			local line_content = vim.api.nvim_get_current_line()
			local cmd = "Git diff HEAD %"

			T.ui.open_side_panel({ cmd = cmd, mode = "replace" })

			-- Escape special chars for search
			local pattern = vim.fn.escape(line_content, [[\/.*$^~[]])
			-- Search for the line content in the diff buffer
			vim.fn.search(pattern, "w")
		end

		local function open_gdiff_tab(ref)
			vim.cmd("tabedit %")
			vim.cmd("Gdiff" .. (ref and " " .. ref or ""))
			for i = 1, vim.fn.winnr("$") do
				vim.api.nvim_win_call(vim.fn.win_getid(i), function()
					vim.keymap.set("n", "q", ":tabclose<CR>", { buffer = true, silent = true })
					local bufname = vim.api.nvim_buf_get_name(0)
					if vim.startswith(bufname, "fugitive://") then
						vim.lsp.stop_client(vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() }))
					end
				end)
			end
		end

		local function git_diff_default_branch()
			local ref = T.git.default_branch()
			if not ref then
				vim.notify("Could not determine default branch", vim.log.levels.WARN)
				return
			end
			open_gdiff_tab(ref)
		end

		local function show_range_history()
			local start_line = vim.fn.line("v")
			local end_line = vim.fn.line(".")
			local file_path = vim.fn.expand("%")
			local range = string.format("%s,%s", start_line, end_line)
			local cmd = string.format("Git log -L %s:%s", range, file_path)

			T.ui.open_side_panel({ cmd = cmd, mode = "replace" })
		end

		return {
			{ "<leader>hd", open_gdiff_tab, desc = "Git: Gdiff" },
			{ "<leader>hb", git_diff_default_branch, desc = "Git: Diff file vs default branch" },
			{ "<leader>h%", git_diff_file, desc = "Git: Diff file vs HEAD" },
			{ "<leader>hh", git_status, desc = "Git: Status" },
			{ "<leader>hl", show_range_history, mode = "v", desc = "Git: Show range history" },
		}
	end,
}
