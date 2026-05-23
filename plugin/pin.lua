-- Pin plugins based on discovery-time aging for supply chain security
-- Usage:
--   :PinPlugins       Pin to commits discovered at least 30 days ago
--   :PinPlugins 14    Pin to commits discovered at least 14 days ago
--   :PinPlugins!      Force fetch to discover newest commits before pinning
--
-- Note: This uses a local registry (~/.local/share/nvim/pin-discovery.json)
-- to track when each remote commit was first seen. Updates only graduate
-- to your _pins.lua after they have "aged" for the specified number of days.

vim.api.nvim_create_user_command("PinPlugins", function(opts)
	local days = tonumber(opts.args) or 30
	local force_fetch = opts.bang

	require("lib.pin").pin_plugins({
		days = days,
		force_fetch = force_fetch,
	})
end, {
	nargs = "?",
	bang = true,
	desc = "Pin plugins based on discovery-time aging",
})

vim.api.nvim_create_user_command("PinReview", function()
	require("lib.pin").show_review()
end, {
	desc = "Review graduating plugin updates",
})
