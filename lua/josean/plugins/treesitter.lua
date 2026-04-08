-- treesitter.lua
-- Place this file in: ~/.config/nvim/lua/plugins/treesitter.lua

return {
     {
          "nvim-treesitter/nvim-treesitter",
          lazy = false,
          build = ":TSUpdate",
          dependencies = {
               "windwp/nvim-ts-autotag",
               "nvim-treesitter/nvim-treesitter-textobjects",
          },
          config = function()
               -- ─── Core Setup ─────────────────────────────────────────────────────
               require("nvim-treesitter").setup({
                    install_dir = vim.fn.stdpath("data") .. "/site",
               })

               require("nvim-treesitter").install({
                    "lua",
                    "vim",
                    "vimdoc",
                    "query",
                    "bash",
                    "json",
                    "yaml",
                    "markdown",
                    "markdown_inline",
                    "html",
                    "css",
                    "javascript",
                    "typescript",
                    "tsx",
                    "go",
                    "c",
                    "cpp",
                    "python",
               })

               -- ─── Auto-close / rename HTML tags ───────────────────────────────────
               require("nvim-ts-autotag").setup()

               -- ─── Highlighting via autocmd ────────────────────────────────────────
               vim.api.nvim_create_autocmd("FileType", {
                    pattern = "*",
                    callback = function(args)
                         local buf = args.buf
                         local max_filesize = 100 * 1024 -- 100 KB
                         local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                         if ok and stats and stats.size > max_filesize then
                              return
                         end
                         local ok2, ts = pcall(vim.treesitter.get_parser, buf)
                         if ok2 and ts then
                              vim.treesitter.start()
                         end
                    end,
               })

               -- ─── Folding ─────────────────────────────────────────────────────────
               vim.wo.foldmethod = "expr"
               vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

               -- ─── Text Objects: Select ────────────────────────────────────────────
               local select = require("nvim-treesitter-textobjects.select")

               local select_maps = {
                    ["a="] = { "@assignment.outer", "Select outer part of an assignment" },
                    ["i="] = { "@assignment.inner", "Select inner part of an assignment" },
                    ["l="] = { "@assignment.lhs", "Select left hand side of an assignment" },
                    ["r="] = { "@assignment.rhs", "Select right hand side of an assignment" },
                    ["aa"] = { "@parameter.outer", "Select outer part of a parameter/argument" },
                    ["ia"] = { "@parameter.inner", "Select inner part of a parameter/argument" },
                    ["ai"] = { "@conditional.outer", "Select outer part of a conditional" },
                    ["ii"] = { "@conditional.inner", "Select inner part of a conditional" },
                    ["al"] = { "@loop.outer", "Select outer part of a loop" },
                    ["il"] = { "@loop.inner", "Select inner part of a loop" },
                    ["af"] = { "@call.outer", "Select outer part of a function call" },
                    ["if"] = { "@call.inner", "Select inner part of a function call" },
                    ["am"] = { "@function.outer", "Select outer part of a method/function def" },
                    ["im"] = { "@function.inner", "Select inner part of a method/function def" },
                    ["ac"] = { "@class.outer", "Select outer part of a class" },
                    ["ic"] = { "@class.inner", "Select inner part of a class" },
                    ["ak"] = { "@comment.outer", "Select comment" },
               }

               for key, val in pairs(select_maps) do
                    vim.keymap.set({ "x", "o" }, key, function()
                         select.select_textobject(val[1], "textobjects")
                    end, { desc = val[2] })
               end

               -- ─── Text Objects: Move ──────────────────────────────────────────────
               local move = require("nvim-treesitter-textobjects.move")

               local move_maps = {
                    ["]f"] = { "@call.outer", "next", "Next function call start" },
                    ["[f"] = { "@call.outer", "prev", "Prev function call start" },
                    ["]m"] = { "@function.outer", "next", "Next method/function def start" },
                    ["[m"] = { "@function.outer", "prev", "Prev method/function def start" },
                    ["]c"] = { "@class.outer", "next", "Next class start" },
                    ["[c"] = { "@class.outer", "prev", "Prev class start" },
                    ["]i"] = { "@conditional.outer", "next", "Next conditional start" },
                    ["[i"] = { "@conditional.outer", "prev", "Prev conditional start" },
                    ["]l"] = { "@loop.outer", "next", "Next loop start" },
                    ["[l"] = { "@loop.outer", "prev", "Prev loop start" },
                    ["]a"] = { "@parameter.inner", "next", "Next parameter" },
                    ["[a"] = { "@parameter.inner", "prev", "Prev parameter" },
               }

               for key, val in pairs(move_maps) do
                    vim.keymap.set({ "n", "x", "o" }, key, function()
                         if val[2] == "next" then
                              move.goto_next_start(val[1], "textobjects")
                         else
                              move.goto_previous_start(val[1], "textobjects")
                         end
                    end, { desc = val[3] })
               end

               -- ─── Swap Parameters ─────────────────────────────────────────────────
               local swap = require("nvim-treesitter-textobjects.swap")
               vim.keymap.set("n", "<leader>sn", function()
                    swap.swap_next("@parameter.inner")
               end, { desc = "Swap with next parameter" })
               vim.keymap.set("n", "<leader>sp", function()
                    swap.swap_previous("@parameter.inner")
               end, { desc = "Swap with prev parameter" })

               -- ─── Repeatable Moves via ; and , ────────────────────────────────────
               local rep = require("nvim-treesitter-textobjects.repeatable_move")
               vim.keymap.set({ "n", "x", "o" }, ";", rep.repeat_last_move_next)
               vim.keymap.set({ "n", "x", "o" }, ",", rep.repeat_last_move_previous)
               vim.keymap.set({ "n", "x", "o" }, "f", rep.builtin_f_expr, { expr = true })
               vim.keymap.set({ "n", "x", "o" }, "F", rep.builtin_F_expr, { expr = true })
               vim.keymap.set({ "n", "x", "o" }, "t", rep.builtin_t_expr, { expr = true })
               vim.keymap.set({ "n", "x", "o" }, "T", rep.builtin_T_expr, { expr = true })
          end,
     },
}
