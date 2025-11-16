return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		dashboard = {
			enabled = true,
			preset = {
				header = [[
    ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
    ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
    ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
    ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
    ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
    ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
				-- stylua: ignore
				---@type snacks.dashboard.Item[]
				keys = {
					{ icon = " ", key = "h", desc = "HOME - Picker", action = function() vim.cmd("cd /root_unraid/") Snacks.picker.files() end },
					{ icon = " ", key = "d", desc = "Docker compose dir - Picker", action = function() vim.cmd("cd /boot/config/plugins/compose.manager/") Snacks.picker.grep() end },
					{ icon = " ", key = "u", desc = "Userscripts - Picker", action = function() vim.cmd("cd /boot/config/plugins/user.scripts/scripts/") Snacks.picker.files() end },
					{ icon = " ", key = "a", desc = "APPDATA - Picker", action = function() vim.cmd("cd /mnt/cache/appdata/") Snacks.picker.files() end },
					{ icon = "󰱼 ", key = "g", desc = "GREP DIR", action = function() Snacks.picker.grep() end },
					{ icon = " ", key = "r", desc = "Recent", action = function() Snacks.picker.recent() end },
					{ icon = "󱌣 ", key = "m", desc = "Mason", action = ":Mason" },
					{ icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
					{ icon = "󰂖 ", key = "U", desc = "Update plugins", action = function() require("lazy").sync() end },
					{ icon = " ", key = "q", desc = "Quit NVIM", action = ":qa" },
				},
			},
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
				{ section = "startup" },
			},
		},
		picker = {
			enabled = true,
			-- Use telescope preset for horizontal layout
			layout = {
				preset = "telescope",
				fullscren = true,
			},
			-- Format to show filename first, then path (similar to telescope)
			formatters = {
				file = {
					filename_first = true,
				},
			},
			-- Custom prompt icons
			icons = {
				prompt = "   ",
				caret = "󰼛 ",
			},
			-- Default picker configuration
			sources = {
				files = {
					hidden = true,
					follow = true,
					-- Exclude patterns similar to telescope rg configuration
					-- cmd = "rg",
				},
			},
		},
	},
	keys = {
		-- File pickers
		{
			"<C-p>",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>sf",
			function()
				Snacks.picker.files()
			end,
			desc = "[S]earch [F]iles",
		},
		{
			"<leader>s.",
			function()
				Snacks.picker.recent()
			end,
			desc = '[S]earch Recent Files ("." for repeat)',
		},

		-- Directory-specific file pickers
		{
			"<leader>ta",
			function()
				vim.cmd("cd /mnt/cache/appdata/")
				Snacks.picker.files()
			end,
			desc = "[T]elescope appdata",
		},
		{
			"<leader>tu",
			function()
				vim.cmd("cd /mnt/user/unraid_scripts/")
				Snacks.picker.files()
			end,
			desc = "[T]elescope unraid_scripts",
		},
		{
			"<leader>td",
			function()
				vim.cmd("cd /boot/config/plugins/compose.manager/projects/")
				Snacks.picker.files()
			end,
			desc = "[T]elescope docker compose",
		},
		{
			"<leader>tU",
			function()
				vim.cmd("cd /boot/config/plugins/user.scripts/scripts/")
				Snacks.picker.files()
			end,
			desc = "[T]elescope Userscripts",
		},
		{
			"<leader>th",
			function()
				vim.cmd("cd /root_unraid/")
				Snacks.picker.files()
			end,
			desc = "[T]elescope Home",
		},

		-- Grep/Search pickers
		{
			"<leader>sg",
			function()
				Snacks.picker.grep()
			end,
			desc = "[S]earch by [G]rep",
		},
		{
			"<leader>sw",
			function()
				Snacks.picker.grep_word()
			end,
			desc = "[S]earch current [W]ord",
		},
		{
			"<leader>sG",
			function()
				Snacks.picker.grep({
					grep_open_files = true,
				})
			end,
			desc = "[S]earch [G]rep open files",
		},
		{
			"<leader>sb",
			function()
				Snacks.picker.lines()
			end,
			desc = "[S]earch [B]uffer",
		},

		-- Buffer and navigation pickers
		{
			"<leader><leader>",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Find existing buffers",
		},

		-- Help and documentation pickers
		{
			"<leader>sh",
			function()
				Snacks.picker.help()
			end,
			desc = "[S]earch [H]elp",
		},
		{
			"<leader>sk",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "[S]earch [K]eymaps",
		},

		-- LSP and diagnostics pickers
		{
			"<leader>sd",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "[S]earch [D]iagnostics",
		},

		-- Resume last picker
		{
			"<leader>sr",
			function()
				Snacks.picker.resume()
			end,
			desc = "[S]earch [R]esume",
		},

		-- Git pickers (bonus - snacks has these if you use git)
		{
			"<leader>sgc",
			function()
				Snacks.picker.git_log()
			end,
			desc = "[S]earch [G]it [C]ommits",
		},
		{
			"<leader>sgs",
			function()
				Snacks.picker.git_status()
			end,
			desc = "[S]earch [G]it [S]tatus",
		},

		-- Other keymaps that were in telescope.lua
		{ "<leader>n", "<cmd>NoiceDismiss<CR>", desc = "Dismiss Noice Message" },
		{ "<leader>?", "<cmd>Cheatsheet<CR>", desc = "Cheatsheet" },
	},
	config = function(_, opts)
		require("snacks").setup(opts)

		-- Optional: Create a custom colorscheme picker using snacks
		-- This provides similar functionality to telescope's colorscheme picker
		vim.api.nvim_create_user_command("SnacksColorscheme", function()
			local colorschemes = vim.fn.getcompletion("", "color")
			Snacks.picker.pick({
				prompt = "Select Colorscheme",
				items = colorschemes,
				format = function(item)
					return item
				end,
				confirm = function(item)
					vim.cmd("colorscheme " .. item)
				end,
				preview = function(item)
					-- Apply colorscheme preview
					vim.cmd("colorscheme " .. item)
				end,
			})
		end, { desc = "Pick colorscheme with preview" })
	end,
}
