return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Enhanced capabilities for better completion
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { "documentation", "detail", "additionalTextEdits" }
      }
      -- Add folding range capability (verified for 0.11.2)
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }

      -- Debounce didChange notifications for performance
      vim.lsp.handlers["textDocument/didChange"] = vim.lsp.with(
        vim.lsp.handlers["textDocument/didChange"], {
          debounce_text_changes = 150,
        }
      )

      -- Improve LSP UI with responsive sizing
      local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
      function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or "rounded"
        opts.max_width = opts.max_width or math.min(80, vim.o.columns - 4)
        opts.max_height = opts.max_height or math.min(20, vim.o.lines - 4)
        opts.wrap = true
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
      end

      -- Configure all LSP servers with their specific settings using modern API
      local server_configs = {
        lua_ls = {
          capabilities = capabilities,
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { 
                globals = { "vim" },
                disable = { "missing-fields" }
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
                maxPreload = 100000,
                preloadFileSize = 10000,
              },
              telemetry = { enable = false },
              completion = { callSnippet = "Replace" },
              hint = { enable = true }, -- Enable inlay hints
              format = { enable = false }, -- Use stylua instead
            },
          },
        },
        bashls = { capabilities = capabilities },
        dockerls = { capabilities = capabilities },
        docker_compose_language_service = { capabilities = capabilities },
        jsonls = {
          capabilities = capabilities,
          settings = {
            json = {
              -- Safe schemastore integration with error handling
              schemas = (function()
                local ok, schemastore = pcall(require, "schemastore")
                return ok and schemastore.json.schemas() or {}
              end)(),
              validate = { enable = true },
            },
          },
        },
        pyright = {
          capabilities = capabilities,
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoImportCompletions = true,
                useLibraryCodeForTypes = true,
                autoSearchPaths = true,
              },
            },
          },
        },
        yamlls = {
          capabilities = capabilities,
          settings = {
            yaml = {
              -- Safe schemastore integration with error handling
              schemas = (function()
                local ok, schemastore = pcall(require, "schemastore")
                return ok and schemastore.yaml.schemas() or {}
              end)(),
              validate = true,
              completion = true,
            },
          },
        },
        ruff = { 
          capabilities = capabilities,
          init_options = {
            settings = {
              args = {},
            }
          }
        },
        matlab_ls = { capabilities = capabilities },
      }

      -- Set up each server with its configuration using modern Neovim 0.11+ API
      -- Only configure servers that are available
      local available_servers = {}
      for server, config in pairs(server_configs) do
        -- Simple availability check
        local server_available = false
        if server == "lua_ls" then
          server_available = true
        else
          local server_with_dash = server:gsub("_", "-")
          if vim.fn.executable(server_with_dash) == 1 then
            server_available = true
          elseif vim.fn.executable(server) == 1 then
            server_available = true
          end
        end
        
        if server_available then
          vim.lsp.config[server] = config
          table.insert(available_servers, server)
        end
      end

      -- Enable only available servers
      if #available_servers > 0 then
        vim.lsp.enable(available_servers)
      end

      -- LspAttach autocmd replaces the old on_attach function
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

          -- Find references for the word under your cursor.
          map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map("<leader>LD", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map("<leader>Ls", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map("<leader>Lr", vim.lsp.buf.rename, "[R]e[n]ame")

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map("<leader>La", vim.lsp.buf.code_action, "[C]ode [A]ction")

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap.
          map("K", vim.lsp.buf.hover, "Hover Documentation")

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          -- Additional enhanced keymaps
          map("<leader>Lf", function()
            vim.lsp.buf.format({ async = true })
          end, "[F]ormat")

          map("<leader>Lw", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

          -- Toggle diagnostics (buffer-specific for 0.11.2)
          map("<leader>Ld", function()
            local current_buf = vim.api.nvim_get_current_buf()
            local is_enabled = vim.diagnostic.is_enabled({ bufnr = current_buf })
            vim.diagnostic.enable(not is_enabled, { bufnr = current_buf })
          end, "[T]oggle [D]iagnostics")

          -- Add useful buffer commands
          vim.api.nvim_buf_create_user_command(event.buf, "LspRestart", function()
            local clients = vim.lsp.get_clients({ bufnr = event.buf })
            for _, client in pairs(clients) do
              vim.lsp.stop_client(client.id)
            end
            vim.defer_fn(function()
              vim.cmd("edit")
            end, 500)
          end, { desc = "Restart LSP for this buffer" })

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup =
                vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          -- Inlay hints (buffer-specific for 0.11.2)
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map("<leader>Li", function()
              local current_buf = vim.api.nvim_get_current_buf()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = current_buf }), { bufnr = current_buf })
            end, "[T]oggle [I]nlay Hints")
          end
        end,
      })
    end,
  },
}

