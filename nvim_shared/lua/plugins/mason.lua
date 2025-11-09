return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗"
					}
				}
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"bashls",
					"dockerls",
					"docker_compose_language_service",
					"jsonls",
					"pyright",
					"yamlls",
					"ruff",
					"matlab_ls",
				},
				automatic_installation = true,
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- Linters
					"yamllint",
					"shellcheck",
					"luacheck",
					"markdownlint",
					"jsonlint",
					-- Formatters
					"stylua",
					"prettier",
					"black",
					"shfmt",
				},
				auto_update = false,
				run_on_start = true,
			})
		end,
	},
}
