-- Buffer bookmarks
-- https://github.com/ThePrimeagen/harpoon/tree/harpoon2

return {
	"ThePrimeagen/harpoon",
	keys = function()
		local harpoon = require("harpoon")

		local function add_file()
			harpoon:list():add()
		end

		local function toggle_quick_menu()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end

		local function select_file(index)
			return function()
				harpoon:list():select(index)
			end
		end

		local mappings = {
			{ "<leader>ba", add_file, "Add file" },
			{ "<leader>bb", toggle_quick_menu, "Toggle quick menu" },
			{ "<leader>1", select_file(1), "Select file 1" },
			{ "<leader>2", select_file(2), "Select file 2" },
			{ "<leader>3", select_file(3), "Select file 3" },
			{ "<leader>4", select_file(4), "Select file 4" },
			{ "<leader>5", select_file(5), "Select file 5" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Harpoon")
	end,

	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
}
