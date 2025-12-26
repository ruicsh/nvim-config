-- Time tracking
-- https://github.com/wakatime/vim-wakatime

local T = require("lib")

return {
	"wakatime/vim-wakatime",
	enabled = T.env.get_bool("TIME_TRACKING_ENABLED"),

	lazy = false,
}
