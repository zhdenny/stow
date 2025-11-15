vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.wo.number = true
vim.wo.relativenumber = true

-- Navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

vim.keymap.set("n", "<leader>h", "<cmd>bp<CR>", { desc = "Buffer Previous" })
vim.keymap.set("n", "<leader>l", "<cmd>bn<CR>", { desc = "Buffer Next" })
vim.keymap.set("n", "<leader>S", ":windo set scrollbind!<CR>", { desc = "Toggle Scroll Lock" })

-- Adjust window sizes
vim.keymap.set("n", "<leader><Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<leader><Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<leader><Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
vim.keymap.set("n", "<leader><Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })

-- I added this
vim.opt.termguicolors = true

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Zach Denny - START EDIT Lines below are used to push neovim clipboard through ssh to host OS

-- Lua 5.1-compatible base64 encoder, exported globally for debugging if needed
function _G.base64_encode(data)
	local b64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	local result = {}
	local len = string.len(data)
	local i = 1

	while i <= len do
		local b1 = string.byte(data, i) or 0
		local b2 = string.byte(data, i + 1) or 0
		local b3 = string.byte(data, i + 2) or 0

		local n = b1 * 65536 + b2 * 256 + b3

		local c1 = math.floor(n / 262144)
		local c2 = math.floor(n / 4096) % 64
		local c3 = math.floor(n / 64) % 64
		local c4 = n % 64

		result[#result + 1] = string.sub(b64chars, c1 + 1, c1 + 1)
		result[#result + 1] = string.sub(b64chars, c2 + 1, c2 + 1)

		if i + 1 > len then
			result[#result + 1] = "="
			result[#result + 1] = "="
		elseif i + 2 > len then
			result[#result + 1] = string.sub(b64chars, c3 + 1, c3 + 1)
			result[#result + 1] = "="
		else
			result[#result + 1] = string.sub(b64chars, c3 + 1, c3 + 1)
			result[#result + 1] = string.sub(b64chars, c4 + 1, c4 + 1)
		end

		i = i + 3
	end

	return table.concat(result)
end

-- Use your known-good tmux-wrapped OSC52 sequence
function _G.osc52_tmux_copy(text)
	if not text or text == "" then
		return
	end
	local b64 = base64_encode(text)
	local seq = string.format("\x1bPtmux;\x1b\x1b]52;c;%s\x07\x1b\\", b64)
	io.write(seq)
	io.flush()
end

-- Autocommand: on every yank, mirror to + and send OSC52 to host
local function copy_on_yank()
	if vim.v.event.operator ~= "y" then
		return
	end

	-- Which register did the yank go into? "" means unnamed (" register)
	local reg = vim.v.event.regname
	if reg == "" then
		reg = '"'
	end

	local text = vim.fn.getreg(reg)
	local regtype = vim.fn.getregtype(reg)

	-- 1) Mirror into + (used for paste inside Neovim)
	vim.fn.setreg("+", text, regtype)

	-- 2) Send to host clipboard via OSC52
	osc52_tmux_copy(text)
end

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = copy_on_yank,
})

-- IMPORTANT: don't use 'unnamedplus' (that asks for a system clipboard provider)
vim.opt.clipboard = ""

-- Make p / P paste from + (which we keep in sync with host clipboard)
vim.keymap.set({ "n", "x" }, "p", '"+p')
vim.keymap.set({ "n", "x" }, "P", '"+P')

-- Zach Denny - END EDIT

-- Save undo history
vim.opt.undofile = true
-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"
-- Decrease update time
vim.opt.updatetime = 250
-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 3000
-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true
-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"
-- Show which line your cursor is on
vim.opt.cursorline = true
-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Info keymaps
vim.keymap.set("n", "<leader>ic", "<cmd>CmpStatus<CR>", { desc = "[C]ompletions Status" })
vim.keymap.set("n", "<leader>il", "<cmd>LspInfo<CR>", { desc = "[L]SP Status" })
vim.keymap.set("n", "<leader>in", "<cmd>NullLsInfo<CR>", { desc = "[N]ull-LS Status" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
