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

