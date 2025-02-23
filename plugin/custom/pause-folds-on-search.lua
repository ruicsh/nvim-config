-- https://github.com/chrisgrieser/nvim-origami/blob/main/lua/origami/pause-folds-on-search.lua

local ns = vim.api.nvim_create_namespace("ruicsh/custom/pause-folds-on-search")

vim.on_key(function(char)
	local key = vim.fn.keytrans(char)
	local isCmdlineSearch = vim.fn.getcmdtype():find("[/?]") ~= nil
	local isNormalMode = vim.api.nvim_get_mode().mode == "n"

	local searchStarted = (key == "/" or key == "?") and isNormalMode
	local searchConfirmed = (key == "<CR>" and isCmdlineSearch)
	local searchCancelled = (key == "<Esc>" and isCmdlineSearch)
	if not (searchStarted or searchConfirmed or searchCancelled or isNormalMode) then
		return
	end

	local foldsArePaused = not (vim.opt.foldenable:get())
	local searchMovement = vim.tbl_contains({ "n", "N", "*", "#" }, key)

	local pauseFold = (searchConfirmed or searchStarted or searchMovement) and not foldsArePaused
	local unpauseFold = foldsArePaused and (searchCancelled or not searchMovement)

	if pauseFold then
		vim.opt_local.foldenable = false
	elseif unpauseFold then
		vim.opt_local.foldenable = true
		pcall(vim.cmd.foldopen, { bang = true }) -- after closing folds, keep the *current* fold open
	end
end, ns)
