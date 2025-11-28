-- Jump to references within the current buffer

local augroup = vim.api.nvim_create_augroup("ruicsh/custom/lsp-jump-to-references", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	pattern = "*",
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end

		local methods = vim.lsp.protocol.Methods

		if not client:supports_method(methods.textDocument_references) then
			return
		end

		local k = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
		end

		-- Cache the current word and references list
		local current_word = nil
		local cache_items = nil

		local function find_ajdacent_reference(items, direction)
			if direction == "first" then
				return 1
			end

			if direction == "last" then
				return #items
			end

			-- Find the current reference based on cursor position
			local current_ref = 1
			local lnum = vim.fn.line(".")
			local col = vim.fn.col(".")
			for i, item in ipairs(items) do
				if item.lnum == lnum and item.col == col then
					current_ref = i
					break
				end
			end

			-- Calculate the adjacent reference based on direction
			local adjacent_ref = current_ref
			local delta = direction == "next" and 1 or -1
			adjacent_ref = math.min(#items, current_ref + delta)
			if adjacent_ref < 1 then
				adjacent_ref = 1
			end

			return adjacent_ref
		end

		local function jump_to_reference(direction)
			return function()
				-- Make sure we're at the beginning of the current word
				vim.cmd("normal! eb")

				-- If we are jumping on the same word, we can use the cached list
				if current_word == vim.fn.expand("<cword>") then
					local adjacent_ref = find_ajdacent_reference(cache_items, direction)
					vim.cmd("ll " .. adjacent_ref)
					return
				end

				vim.lsp.buf.references(nil, {
					on_list = function(options)
						-- Filter out references that are not in the current buffer
						local current_filename = vim.api.nvim_buf_get_name(0):lower()
						if vim.fn.has("win32") == 1 then
							current_filename = current_filename:gsub("/", "\\")
						end
						local items = vim.tbl_filter(function(item)
							return item.filename:lower() == current_filename
						end, options.items)

						-- No references found in the current buffer
						if #items == 0 then
							vim.notify("No references found", vim.log.levels.WARN)
							vim.fn.setloclist(0, {}, "r", { items = {} })
							current_word = nil
							cache_items = nil
							return
						end

						-- Cache the current word and items for later use
						current_word = vim.fn.expand("<cword>")
						cache_items = items

						-- Set the quickfix list and jump to the adjacent reference
						vim.fn.setloclist(0, {}, "r", { items = items })
						local adjacent_ref = find_ajdacent_reference(cache_items, direction)
						vim.cmd("ll " .. adjacent_ref)
					end,
				})
			end
		end

		k("[r", jump_to_reference("prev"), "Jump to previous reference")
		k("]r", jump_to_reference("next"), "Jump to next reference")
		k("[R", jump_to_reference("first"), "Jump to first reference")
		k("]R", jump_to_reference("last"), "Jump to last reference")
	end,
})
