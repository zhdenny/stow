return {
	-- Autocompletion plugin
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- source for neovim builtin LSP client
			"hrsh7th/cmp-path", -- completion source for paths
			"hrsh7th/cmp-buffer", -- completion source for buffer words
			"ray-x/cmp-treesitter", -- treesitter completion source
			"onsails/lspkind-nvim", -- icons for lsp functions
		},
		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			cmp.setup({
				formatting = {
					format = function(entry, vim_item)
						-- fancy icons and a name of kind
						vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind
						-- set a name for each source
						vim_item.menu = ({
							buffer = "[Buffer]",
							nvim_lsp = "[LSP]",
							nvim_lua = "[Lua]",
							look = "[Look]",
							path = "[Path]",
							spell = "[Spell]",
							calc = "[Calc]",
							emoji = "[Emoji]",
						})[entry.source.name]
						return vim_item
					end,
				},
				mapping = {
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.close(),
					["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
					["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end,
					["<S-Tab>"] = function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end,
				},
				sources = {
					{ name = "nvim_lsp", max_item_count = 10 },
					{ name = "treesitter", max_item_count = 10 },
					{ name = "buffer", max_item_count = 10 },
					{ name = "path", max_item_count = 10 },
				},
			})
		end,
	},

	-- Formatter
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")

			local function setFormat(filetypes, formatter)
				local config = {}
				for _, filetype in ipairs(filetypes) do
					config[filetype] = { formatter }
				end
				return config
			end

			local config = {
				go = { "gofmt" },
				python = { { "ruff_format", "black" } },
				lua = { "stylua" },
				shell = { "shfmt" },
			}

			config = vim.tbl_extend(
				"keep",
				config,
				setFormat({
					"javascript",
					"javascriptreact",
					"html",
					"json",
					"markdown",
					"toml",
					"typescript",
					"typescriptreact",
					"yaml",
				}, "prettier")
			)
			conform.setup({
				formatters_by_ft = config,
				format_on_save = {
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				},
				log_level = vim.log.levels.ERROR,
				notify_on_error = true,
			})
		end,
	},

	-- Linter
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"rshkarin/mason-nvim-lint",
		},
		config = function()
			local lint = require("lint")

			-- Configure luacheck for Neovim
			lint.linters.luacheck.args = {
				"--globals",
				"vim",
				"--read-globals",
				"jit",
				"--formatter",
				"plain",
				"--codes",
				"--ranges",
				"-",
			}

			lint.linters_by_ft = {
				go = { "golangcilint" },
				javascript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				json = { "jsonlint" },
				lua = { "luacheck" },
				markdown = { "markdownlint" },
				python = { "ruff" },
				sh = { "shellcheck" },
				typescript = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				yaml = { "yamllint" },
			}

			-- Setup mason-nvim-lint to automatically configure linter paths
			require("mason-nvim-lint").setup({
				ensure_installed = {
					"yamllint",
					"shellcheck",
					"luacheck",
					"markdownlint",
					"jsonlint",
				},
				automatic_installation = true,
			})

			-- nvim-lint activate linting
			vim.api.nvim_create_autocmd({ "InsertLeave", "BufNewFile", "BufRead" }, {
				callback = function()
					local lint_status, lint_module = pcall(require, "lint")
					if lint_status then
						lint_module.try_lint()
					end
				end,
			})
		end,
	},
}
