return {
  "numToStr/Comment.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("Comment").setup({
      mappings = {
        ---Extra mapping; `gco`, `gcO`, `gcA`
        extra = false,
      },
    })
  end,
}
