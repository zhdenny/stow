-- LSP settings
-- Ensure sign column is always visible to show diagnostic icons
vim.opt.signcolumn = "yes"

-- Define diagnostic signs for compatibility
local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "💡" },
  { name = "DiagnosticSignInfo", text = "" }
}

-- Set the signs for compatibility
for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

-- Enhanced diagnostic configuration
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "💡",
    },
  },
  virtual_text = {
    prefix = "●",
    source = "if_many",
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
    max_width = 80,
    max_height = 20,
  },
})

