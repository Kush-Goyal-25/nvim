return {
     {
          "nvim-treesitter/nvim-treesitter",
          version = "v0.9.3",
          event = { "BufReadPre", "BufNewFile" },
          build = ":TSUpdate",
          dependencies = {
               "windwp/nvim-ts-autotag",
               "nvim-treesitter/nvim-treesitter-textobjects",
          },
          config = function()
               require("nvim-treesitter.configs").setup({
                    ensure_installed = {
                         "json",
                         "javascript",
                         "typescript",
                         "tsx",
                         "yaml",
                         "html",
                         "css",
                         "cpp",
                         "prisma",
                         "markdown",
                         "markdown_inline",
                         "svelte",
                         "graphql",
                         "bash",
                         "lua",
                         "vim",
                         "dockerfile",
                         "gitignore",
                         "query",
                         "vimdoc",
                         "c",
                    },
                    auto_install = true,
                    highlight = { enable = true },
                    indent = { enable = true },
                    autotag = { enable = true },
                    incremental_selection = {
                         enable = true,
                         keymaps = {
                              init_selection = "<C-space>",
                              node_incremental = "<C-space>",
                              scope_incremental = false,
                              node_decremental = "<bs>",
                         },
                    },
               })

               -- ✅ New textobjects API using new module path
               local select = require("nvim-treesitter-textobjects.select")
               local move = require("nvim-treesitter-textobjects.move")

               -- SELECT textobjects (use in visual mode or with operator)
               local select_keymaps = {
                    ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
                    ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
                    ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
                    ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },
                    ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
                    ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },
                    ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
                    ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },
                    ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
                    ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },
                    ["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
                    ["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },
                    ["am"] = { query = "@function.outer", desc = "Select outer part of a method/function def" },
                    ["im"] = { query = "@function.inner", desc = "Select inner part of a method/function def" },
                    ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
                    ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
               }

               for key, mapping in pairs(select_keymaps) do
                    vim.keymap.set({ "x", "o" }, key, function()
                         select.select_textobject(mapping.query, "textobjects")
                    end, { desc = mapping.desc })
               end

               -- MOVE textobjects (use in normal mode)
               local move_keymaps = {
                    ["]f"] = {
                         query = "@call.outer",
                         dir = "next",
                         start = true,
                         desc = "Next function call start",
                    },
                    ["]m"] = {
                         query = "@function.outer",
                         dir = "next",
                         start = true,
                         desc = "Next method/function def start",
                    },
                    ["]c"] = { query = "@class.outer", dir = "next", start = true, desc = "Next class start" },
                    ["]i"] = {
                         query = "@conditional.outer",
                         dir = "next",
                         start = true,
                         desc = "Next conditional start",
                    },
                    ["]l"] = { query = "@loop.outer", dir = "next", start = true, desc = "Next loop start" },
                    ["[f"] = {
                         query = "@call.outer",
                         dir = "prev",
                         start = true,
                         desc = "Prev function call start",
                    },
                    ["[m"] = {
                         query = "@function.outer",
                         dir = "prev",
                         start = true,
                         desc = "Prev method/function def start",
                    },
                    ["[c"] = { query = "@class.outer", dir = "prev", start = true, desc = "Prev class start" },
                    ["[i"] = {
                         query = "@conditional.outer",
                         dir = "prev",
                         start = true,
                         desc = "Prev conditional start",
                    },
                    ["[l"] = { query = "@loop.outer", dir = "prev", start = true, desc = "Prev loop start" },
               }

               for key, mapping in pairs(move_keymaps) do
                    vim.keymap.set({ "n", "x", "o" }, key, function()
                         if mapping.dir == "next" then
                              move.goto_next_start(mapping.query, "textobjects")
                         else
                              move.goto_previous_start(mapping.query, "textobjects")
                         end
                    end, { desc = mapping.desc })
               end
          end,
     },
}
