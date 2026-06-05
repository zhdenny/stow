return {
	"numToStr/Comment.nvim",
	event = { "BufReadPost", "BufNewFile" },
	lazy = false,
	config = function()
		require("Comment").setup({
			mappings = {
				---Extra mapping; `gco`, `gcO`, `gcA`
				extra = false,
			},
			pre_hook = function(ctx)
				local bufname = vim.api.nvim_buf_get_name(0)
				if bufname:match("%.env$") or bufname:match("%.env%.") or vim.bo.commentstring == "" or vim.bo.commentstring == nil then
					return "# %s"
				end
			end,
		})
	end,
}
