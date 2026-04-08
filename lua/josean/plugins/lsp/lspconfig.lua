return {
     "neovim/nvim-lspconfig",
     event = { "BufReadPre", "BufNewFile" },
     dependencies = {
          "hrsh7th/cmp-nvim-lsp",
          "hrsh7th/cmp-buffer",
          "hrsh7th/cmp-path",
          "hrsh7th/cmp-cmdline",
          "hrsh7th/nvim-cmp",
          "L3MON4D3/LuaSnip",
          "saadparwaiz1/cmp_luasnip",
          "j-hui/fidget.nvim",
          { "antosha417/nvim-lsp-file-operations", config = true },
          { "folke/lazydev.nvim", ft = "lua", opts = {} },
     },

     config = function()
          local lspconfig = require("lspconfig")
          require("fidget").setup({})

          local cmp_nvim_lsp = require("cmp_nvim_lsp")
          local keymap = vim.keymap

          -- ==================== COOL LSP HOVER ====================
          vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
               border = "rounded", -- Rounded borders (modern look)
               style = "minimal",
               focusable = false,
               silent = true,
          })

          -- Also improve signature help (when you type `(` )
          vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
               border = "rounded",
               focusable = false,
               silent = true,
          })

          -- Diagnostic configuration (floating window)
          vim.diagnostic.config({
               float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "● ",
               },
               signs = {
                    text = {
                         [vim.diagnostic.severity.ERROR] = " ",
                         [vim.diagnostic.severity.WARN] = " ",
                         [vim.diagnostic.severity.HINT] = "󰠠 ",
                         [vim.diagnostic.severity.INFO] = " ",
                    },
               },
               virtual_text = true,
               underline = true,
               severity_sort = true,
          })

          -- ==================== LSP ATTACH ====================
          vim.api.nvim_create_autocmd("LspAttach", {
               group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
               callback = function(ev)
                    -- Skip Harpoon menu
                    local ft = vim.bo[ev.buf].filetype
                    local name = vim.api.nvim_buf_get_name(ev.buf)
                    local bt = vim.bo[ev.buf].buftype
                    if ft == "harpoon" or bt == "acwrite" or name:find("harpoon%-menu") then
                         pcall(vim.lsp.buf.detach_client, ev.buf, ev.data.client_id)
                         return
                    end

                    local opts = { buffer = ev.buf, silent = true }

                    -- Keymaps
                    opts.desc = "Show LSP references"
                    keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

                    opts.desc = "Go to declaration"
                    keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

                    opts.desc = "Show LSP definitions"
                    keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

                    opts.desc = "Show LSP implementations"
                    keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

                    opts.desc = "Show LSP type definitions"
                    keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

                    opts.desc = "See available code actions"
                    keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

                    opts.desc = "Smart rename"
                    keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

                    opts.desc = "Show buffer diagnostics"
                    keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

                    opts.desc = "Show line diagnostics"
                    keymap.set("n", "<leader>dl", vim.diagnostic.open_float, opts)

                    opts.desc = "Go to previous diagnostic"
                    keymap.set("n", "[d", function()
                         vim.diagnostic.jump({ count = -1 })
                    end, opts)

                    opts.desc = "Go to next diagnostic"
                    keymap.set("n", "]d", function()
                         vim.diagnostic.jump({ count = 1 })
                    end, opts)

                    opts.desc = "Show documentation for what is under cursor"
                    keymap.set("n", "K", vim.lsp.buf.hover, opts)

                    opts.desc = "Restart LSP"
                    keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
               end,
          })

          -- Capabilities
          local capabilities = cmp_nvim_lsp.default_capabilities()

          -- Setup LSP servers (for Neovim ≥ 0.11)
          if vim.lsp and vim.lsp.config then
               local default_config = { capabilities = capabilities }

               local servers_with_custom = {
                    lua_ls = {
                         capabilities = capabilities,
                         settings = {
                              Lua = {
                                   diagnostics = { globals = { "vim" } },
                                   completion = { callSnippet = "Replace" },
                              },
                         },
                    },
                    -- Add more custom servers here if needed
               }

               for server_name, server_config in pairs(servers_with_custom) do
                    vim.lsp.config(server_name, server_config)
               end

               local other_servers =
                    { "html", "cssls", "tailwindcss", "prismals", "pyright", "ts_ls", "svelte", "graphql", "emmet_ls" }
               for _, server_name in ipairs(other_servers) do
                    if not servers_with_custom[server_name] then
                         vim.lsp.config(server_name, default_config)
                    end
               end
          end
     end,
}
