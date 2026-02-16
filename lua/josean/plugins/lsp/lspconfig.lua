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
          { "folke/neodev.nvim", opts = {} },
     },
     config = function()
          -- import lspconfig plugin
          local lspconfig = require("lspconfig")
          require("fidget").setup({})

          -- import cmp-nvim-lsp plugin
          local cmp_nvim_lsp = require("cmp_nvim_lsp")

          local keymap = vim.keymap -- for conciseness

          vim.api.nvim_create_autocmd("LspAttach", {
               group = vim.api.nvim_create_augroup("UserLspConfig", {}),
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
                    keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

                    opts.desc = "Go to declaration"
                    keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

                    opts.desc = "Show LSP definitions"
                    keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

                    opts.desc = "Show LSP implementations"
                    keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

                    opts.desc = "Show LSP type definitions"
                    keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

                    opts.desc = "See available code actions"
                    keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

                    opts.desc = "Smart rename"
                    keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

                    opts.desc = "Show buffer diagnostics"
                    keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

                    opts.desc = "Show line diagnostics"
                    keymap.set("n", "<leader>dl", vim.diagnostic.open_float, opts) -- show diagnostics for line

                    opts.desc = "Go to previous diagnostic"
                    keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

                    opts.desc = "Go to next diagnostic"
                    keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

                    opts.desc = "Show documentation for what is under cursor"
                    keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

                    opts.desc = "Restart LSP"
                    keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
               end,
          })

          -- used to enable autocompletion (assign to every lsp server config)
          local capabilities = cmp_nvim_lsp.default_capabilities()

          -- Change the Diagnostic symbols in the sign column (gutter)
          -- (not in youtube nvim video)
          local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
          for type, icon in pairs(signs) do
               local hl = "DiagnosticSign" .. type
               vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
          end

          -- mason-lspconfig v2: no setup_handlers; register configs via vim.lsp.config (Neovim 0.11+)
          -- then mason-lspconfig will auto-enable installed servers
          if vim.lsp and vim.lsp.config then
               local default_config = { capabilities = capabilities }
               local servers_with_custom = {
                    svelte = {
                         capabilities = capabilities,
                         on_attach = function(client, bufnr)
                              vim.api.nvim_create_autocmd("BufWritePost", {
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
                              "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte",
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
               local function setup_server(server_name, opts)
                    opts = vim.tbl_extend("force", { capabilities = capabilities }, opts or {})
                    lspconfig[server_name].setup(opts)
               end
               setup_server("svelte", {
                    on_attach = function(client)
                         vim.api.nvim_create_autocmd("BufWritePost", {
                              pattern = { "*.js", "*.ts" },
                              callback = function(ctx)
                                   client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
                              end,
                         })
                    end,
               })
               setup_server("graphql", { filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" } })
               setup_server("emmet_ls", {
                    filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
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
