-- Override deprecated vim.validate table signature to suppress warnings from plugins
local original_validate = vim.validate
vim.validate = function(...)
	local args = { ... }
	if #args == 1 and type(args[1]) == "table" then
		for name, spec in pairs(args[1]) do
			if type(spec) == "table" then
				original_validate(name, spec[1], spec[2], spec[3])
			end
		end
	else
		original_validate(...)
	end
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local opts = {}

require("vim-options-shared")
require("vim-options")
require("lazy").setup("plugins")
require("lsp-settings")

-- General/Global LSP Configuration
local api = vim.api
local lsp = vim.lsp

local make_client_capabilities = lsp.protocol.make_client_capabilities
function lsp.protocol.make_client_capabilities()
        local caps = make_client_capabilities()
        if not (caps.workspace or {}).didChangeWatchedFiles then
                vim.notify("lsp capability didChangeWatchedFiles is already disabled", vim.log.levels.WARN)
        else
                caps.workspace.didChangeWatchedFiles = nil
        end

        return caps
end

