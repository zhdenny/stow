return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPost", "BufNewFile" },
	main = "ibl",
	opts = {},
	config = function()
		local highlight = {
			"RainbowRed",
			"RainbowYellow",
			"RainbowBlue",
			"RainbowOrange",
			"RainbowGreen",
			"RainbowViolet",
			"RainbowCyan",
		}

		local hooks = require("ibl.hooks")
		-- line below just hides the first tab indent
		hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
		-- create the highlight groups in the highlight setup hook, so they are reset
		-- every time the colorscheme changes
		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#f38ba8" })
			vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#f9e2af" })
			vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#89b4fa" })
			vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#fab387" })
			vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#a6e3a1" })
			vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#cba6f7" })
			vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#94e2d5" })
		end)

		require("ibl").setup({ indent = { highlight = highlight } })
	end,
}
