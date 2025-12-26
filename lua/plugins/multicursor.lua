-- Multiple cursors.
-- https://github.com/jake-stewart/multicursor.nvim

return {
	"jake-stewart/multicursor.nvim",
	keys = function()
		local mc = require("multicursor-nvim")

		local function lineAddCursor(direction)
			return function()
				mc.lineAddCursor(direction)
			end
		end

		local function lineSkipCursor(direction)
			return function()
				mc.lineSkipCursor(direction)
			end
		end

		return {
			-- Add or skip cursor above/below the main cursor.
			{ "<s-up>", lineAddCursor(-1), desc = "Cursor: Add above", mode = { "n", "x" } },
			{ "<s-down>", lineAddCursor(1), desc = "Cursor: Add below", mode = { "n", "x" } },
			{ "<leader><s-up>", lineSkipCursor(-1), desc = "Cursor: Skip above", mode = { "n", "x" } },
			{ "<leader><s-down>", lineSkipCursor(1), desc = "Cursor: Skip below", mode = { "n", "x" } },
		}
	end,
	config = function()
		local mc = require("multicursor-nvim")
		mc.setup()

		-- Mappings defined in a keymap layer only apply when there are
		-- multiple cursors. This lets you have overlapping mappings.
		mc.addKeymapLayer(function(layerSet)
			-- Select a different cursor as the main one.
			layerSet({ "n", "x" }, "<left>", mc.prevCursor)
			layerSet({ "n", "x" }, "<right>", mc.nextCursor)

			-- Delete the main cursor.
			layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

			-- Enable and clear cursors using escape.
			layerSet("n", "<esc>", function()
				if not mc.cursorsEnabled() then
					mc.enableCursors()
				else
					mc.clearCursors()
				end
			end)
		end)
	end,
}
