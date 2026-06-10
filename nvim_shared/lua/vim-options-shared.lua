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

vim.opt.termguicolors = true
vim.g.have_nerd_font = true
vim.opt.showmode = false

vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 3000
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "<leader>Ld", function()
	local current_buf = vim.api.nvim_get_current_buf()
	local is_enabled = vim.diagnostic.is_enabled({ bufnr = current_buf })
	vim.diagnostic.enable(not is_enabled, { bufnr = current_buf })
end, { desc = "Toggle [D]iagnostics" })

-- Info keymaps
vim.keymap.set("n", "<leader>ic", "<cmd>CmpStatus<CR>", { desc = "[C]ompletions Status" })
vim.keymap.set("n", "<leader>il", "<cmd>LspInfo<CR>", { desc = "[L]SP Status" })
vim.keymap.set("n", "<leader>in", "<cmd>NullLsInfo<CR>", { desc = "[N]ull-LS Status" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- [[ Basic Autocommands ]]
-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		if vim.hl and vim.hl.hl_op then
			vim.hl.hl_op()
		else
			(vim.hl or vim.highlight).on_yank()
		end
	end,
})
