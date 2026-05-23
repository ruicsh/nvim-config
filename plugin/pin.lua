-- Pin plugins to specific commits for supply chain security
-- Usage:
--   :PinPlugins       Pin to commits older than 30 days
--   :PinPlugins 14    Pin to commits older than 14 days
--   :PinPlugins!      Force fetch before pinning
--
-- Note: This is a mitigation, not a complete solution.
-- It protects against supply chain attacks during subsequent syncs.
-- On first-time installation, lazy.nvim is bootstrapped to a pinned commit
-- in init.lua, and all plugins are constrained by lazy-lock.json and _pins.lua.
-- This significantly reduces the window for malicious code execution.

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
	desc = "Pin plugins to older commits for security",
})
