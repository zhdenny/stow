return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false, -- The new main branch explicitly states it should not be lazy-loaded
	branch = "main",
	build = ":TSUpdate",
	init = function()
		-- Enable modern native treesitter features using Neovim's built-in engine
		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				-- Safely start treesitter highlighting
				pcall(vim.treesitter.start)
				-- Enable modern indentation engine
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
	config = function()
		-- Setup is now minimal
		require("nvim-treesitter").setup({})

		-- Handle your standard parsers using the modern installation API
		local ensure_installed = {
			"lua",
			"bash",
			"dockerfile",
			"html",
			"ini",
			"jq",
			"json",
			"make",
			"markdown",
			"markdown_inline",
			"matlab",
			"php",
			"python",
			"regex",
			"sql",
			"typescript",
			"xml",
			"yaml",
			"vim",
			"vimdoc",
		}

		local installed = require("nvim-treesitter.config").get_installed()
		local to_install = {}
		for _, parser in ipairs(ensure_installed) do
			if not vim.tbl_contains(installed, parser) then
				table.insert(to_install, parser)
			end
		end

		if #to_install > 0 then
			require("nvim-treesitter").install(to_install)
		end
	end,
}
