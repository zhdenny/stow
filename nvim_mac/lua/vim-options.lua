local osc52 = require("vim.ui.clipboard.osc52")

local function copy_with_fallback(reg)
	local orig_copy = osc52.copy(reg)
	return function(lines, regtype)
		-- 1. Store internally in Neovim's default unnamed register
		vim.fn.setreg('"', lines, regtype)
		-- 2. Emit OSC 52 escape sequences to update macOS clipboard
		orig_copy(lines, regtype)
	end
end

local function paste_from_internal()
	return {
		vim.fn.split(vim.fn.getreg('"'), "\n"),
		vim.fn.getregtype('"'),
	}
end

vim.g.clipboard = {
	name = "OSC 52 (Write) + Internal (Read)",
	copy = {
		["+"] = copy_with_fallback("+"),
		["*"] = copy_with_fallback("*"),
	},
	paste = {
		["+"] = paste_from_internal,
		["*"] = paste_from_internal,
	},
}

vim.opt.clipboard = "unnamedplus"
