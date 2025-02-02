-- Small QoL plugins.
-- https://github.com/folke/snacks.nvim

return {
	"folke/snacks.nvim",
	keys = function()
		local snacks = require("snacks")

		local function jump_to_previous_reference()
			snacks.words.jump(-1, true)
		end

		local function jump_to_next_reference()
			snacks.words.jump(1, true)
		end

		local search_word = function()
			local word = vim.fn.expand("<cword>")
			snacks.picker.grep({ search = word })
		end

		local dirs_to_exclude_from_search = {
			".git",
			".requests",
			".turbo",
			"__data__",
			"node_modules",
		}

		local search_directory = function()
			local conditions = {}
			local gitignore_dirs = vim.fn.systemlist("git ls-files --others --ignored --exclude-standard --directory")
			for _, dir in ipairs(gitignore_dirs) do
				-- anwywhere in the path
				table.insert(conditions, "-path '*" .. dir .. "*'")
			end
			for _, dir in ipairs(dirs_to_exclude_from_search) do
				-- exclude by name, exact match
				table.insert(conditions, "-name " .. dir)
			end
			local exclude = table.concat(conditions, " -o ")
			local cmd = "find . -type d \\( " .. exclude .. " \\) -prune -o -type d -print | sort"
			local dirs = vim.fn.systemlist(cmd)

			snacks.picker.select(dirs, {
				prompt = "Select a directory",
				format_item = function(item)
					return item
				end,
			}, function(choice)
				snacks.picker.grep({ dirs = { choice } })
			end)
		end

		local mappings = {
			{ "<leader><leader>", snacks.picker.files, "Search: Files" },
			{ "<leader>ff", snacks.picker.grep, "Search: Workspace" },
			{ "<leader>fw", search_word, "Search: Word under cursor" },
			{ "<leader>fd", search_directory, "Search: Directory" },
			{ "<leader>,", snacks.picker.buffers, "Search: Buffers" },
			{ "<leader>j", snacks.picker.jumps, "Search: Jumplist" },
			{ "<leader>nh", snacks.picker.help, "Search: Help" },
			{ "<leader>nc", snacks.picker.commands, "Search: Commands" },
			{ "<leader>nk", snacks.picker.keymaps, "Search: Keymaps" },
			{ "<leader>no", snacks.notifier.show_history, "Notifications: Show history" },
			{ "[r", jump_to_previous_reference, "LSP: Jump to previous reference" },
			{ "]r", jump_to_next_reference, "LSP: Jump to next reference" },
		}
		return vim.fn.getlazykeysconf(mappings)
	end,
	opts = {
		-- https://github.com/folke/snacks.nvim/blob/main/docs/bufdelete.md
		bufdelete = {
			enabled = true,
		},
		-- https://github.com/folke/snacks.nvim/blob/main/docs/indent.md
		indent = {
			animate = {
				enabled = false,
			},
			scope = {
				only_current = true,
			},
		},
		-- https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md
		notifier = {
			enabled = true,
			level = vim.log.levels.ERROR,
		},
		-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
		picker = {
			enabled = true,
			formatters = {
				file = {
					filename_first = true,
				},
			},
			win = {
				input = {
					keys = {
						["<c-]>"] = { "close", mode = { "n", "i" } },
					},
				},
			},
			sources = {
				buffers = {
					win = {
						input = {
							keys = {
								["<c-d>"] = { "bufdelete", mode = { "n", "i" } },
							},
						},
						list = {
							keys = {
								["<c-d>"] = "bufdelete",
							},
						},
					},
				},
			},
		},
		-- https://github.com/folke/snacks.nvim/blob/main/docs/statuscolumn.md
		statuscolumn = {
			left = { "sign", "git" },
			right = { "mark", "fold" },
		},
		-- https://github.com/folke/snacks.nvim/blob/main/docs/words.md
		words = {
			enabled = true,
		},
	},

	lazy = false,
}
