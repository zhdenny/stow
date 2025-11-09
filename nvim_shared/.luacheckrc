-- Luacheck configuration for Neovim
-- This file tells luacheck about global variables that should be recognized

-- Neovim global variables
globals = {
	"vim",
}

-- Allow unused self parameters (common in OOP-style functions)
self = false

-- Allow unused arguments (common when implementing interfaces)
unused_args = false

-- Ignore warning about accessing undefined field of a global variable
-- This is common with vim.* APIs where the structure is dynamic
ignore = {
	"122", -- setting read-only field of global variable
	"131", -- unused variable
}

-- Standard library compatibility
std = "lua51"

-- Enable colors if supported
color = true

-- Maximum line length (optional, adjust as needed)
max_line_length = 120
