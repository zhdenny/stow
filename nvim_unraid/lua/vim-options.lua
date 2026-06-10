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
