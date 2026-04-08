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
          -- neodev.nvim is deprecated; replaced by lazydev.nvim for Neovim 0.10+
          { "folke/lazydev.nvim", ft = "lua", opts = {} },
     },
     config = function()
          -- import lspconfig plugin
          local lspconfig = require("lspconfig")
          require("fidget").setup({})

          -- import cmp-nvim-lsp plugin
          local cmp_nvim_lsp = require("cmp_nvim_lsp")

          local keymap = vim.keymap -- for conciseness

          vim.api.nvim_create_autocmd("LspAttach", {
               -- clear = true prevents duplicate autocmds on re-source
               group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
               callback = function(ev)
                    -- Detach LSP from Harpoon menu buffer to avoid Neovim LSP sync bug (#33224).
                    -- Only detach when we're sure it's Harpoon (name/filetype/buftype) to avoid
                    -- triggering the buf_state nil error in _changetracking.lua after detach.
                    local ft = vim.bo[ev.buf].filetype
                    local name = vim.api.nvim_buf_get_name(ev.buf)
                    local bt = vim.bo[ev.buf].buftype
                    if ft == "harpoon" or bt == "acwrite" or name:find("harpoon%-menu") then
                         pcall(vim.lsp.buf_detach_client, ev.buf, ev.data.client_id)
                         return
                    end

                    -- Buffer local mappings.
                    -- See `:help vim.lsp.*` for documentation on any of the below functions
                    local opts = { buffer = ev.buf, silent = true }

                    -- set keybinds
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
                    -- vim.diagnostic.goto_prev/next were renamed in Neovim 0.10+
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

          -- used to enable autocompletion (assign to every lsp server config)
          local capabilities = cmp_nvim_lsp.default_capabilities()

          -- Diagnostic signs in the gutter (Neovim 0.10+ uses vim.diagnostic.config)
          vim.diagnostic.config({
               signs = {
                    text = {
                         [vim.diagnostic.severity.ERROR] = " ",
                         [vim.diagnostic.severity.WARN] = " ",
                         [vim.diagnostic.severity.HINT] = "󰠠 ",
                         [vim.diagnostic.severity.INFO] = " ",
                    },
               },
          })

          -- mason-lspconfig v2: no setup_handlers; register configs via vim.lsp.config (Neovim 0.11+)
          -- then mason-lspconfig will auto-enable installed servers
          if vim.lsp and vim.lsp.config then
               local default_config = { capabilities = capabilities }
               local servers_with_custom = {
                    svelte = {
                         capabilities = capabilities,
                         -- on_attach signature is (client, bufnr); bufnr must be used for
                         -- buf-local autocmds, otherwise the autocmd fires for every buffer
                         on_attach = function(client, bufnr)
                              vim.api.nvim_create_autocmd("BufWritePost", {
                                   buffer = bufnr,
                                   pattern = { "*.js", "*.ts" },
                                   callback = function(ctx)
                                        client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
                                   end,
                              })
                         end,
                    },
                    graphql = {
                         capabilities = capabilities,
                         filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
                    },
                    emmet_ls = {
                         capabilities = capabilities,
                         filetypes = {
                              "html",
                              "typescriptreact",
                              "javascriptreact",
                              "css",
                              "sass",
                              "scss",
                              "less",
                              "svelte",
                         },
                    },
                    lua_ls = {
                         capabilities = capabilities,
                         settings = {
                              Lua = {
                                   diagnostics = { globals = { "vim" } },
                                   completion = { callSnippet = "Replace" },
                              },
                         },
                    },
               }
               for server_name, server_config in pairs(servers_with_custom) do
                    vim.lsp.config(server_name, server_config)
               end
               -- Register default (capabilities only) for other mason-installed servers
               local other_servers = { "html", "cssls", "tailwindcss", "prismals", "pyright", "ts_ls" }
               for _, server_name in ipairs(other_servers) do
                    if not servers_with_custom[server_name] then
                         vim.lsp.config(server_name, default_config)
                    end
               end
          else
               -- Fallback for Neovim < 0.11: use lspconfig and manual setup
               local function setup_server(server_name, server_opts)
                    server_opts = vim.tbl_extend("force", { capabilities = capabilities }, server_opts or {})
                    lspconfig[server_name].setup(server_opts)
               end
               setup_server("svelte", {
                    on_attach = function(client, bufnr)
                         vim.api.nvim_create_autocmd("BufWritePost", {
                              buffer = bufnr,
                              pattern = { "*.js", "*.ts" },
                              callback = function(ctx)
                                   client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
                              end,
                         })
                    end,
               })
               setup_server(
                    "graphql",
                    { filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" } }
               )
               setup_server("emmet_ls", {
                    filetypes = {
                         "html",
                         "typescriptreact",
                         "javascriptreact",
                         "css",
                         "sass",
                         "scss",
                         "less",
                         "svelte",
                    },
               })
               setup_server("lua_ls", {
                    settings = {
                         Lua = { diagnostics = { globals = { "vim" } }, completion = { callSnippet = "Replace" } },
                    },
               })
               for _, server_name in ipairs({ "html", "cssls", "tailwindcss", "prismals", "pyright", "ts_ls" }) do
                    setup_server(server_name)
               end
          end
     end,
}
