return {
     "nvim-telescope/telescope.nvim",
     branch = "0.1.x",
     dependencies = {
          "nvim-lua/plenary.nvim",
          { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
          "nvim-tree/nvim-web-devicons",
          "folke/todo-comments.nvim",
     },
     config = function()
          local telescope = require("telescope")
          local actions = require("telescope.actions")
          local builtin = require("telescope.builtin")

          telescope.setup({
               defaults = {
                    path_display = { "smart" },
                    preview = { treesitter = false },
                    mappings = {
                         i = {
                              ["<C-k>"] = actions.move_selection_previous,
                              ["<C-j>"] = actions.move_selection_next,
                              ["<C-q>"] = function(prompt_bufnr)
                                   actions.smart_send_to_qflist(prompt_bufnr)
                                   vim.cmd("Trouble quickfix toggle")
                              end,
                         },
                         n = {
                              ["<C-q>"] = function(prompt_bufnr)
                                   actions.smart_send_to_qflist(prompt_bufnr)
                                   vim.cmd("Trouble quickfix toggle")
                              end,
                         },
                    },
               },
          })

          telescope.load_extension("fzf")

          local keymap = vim.keymap

          keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
          keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
          keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
          keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
          keymap.set("n", "<leader>vh", builtin.help_tags, { desc = "Search help tags" })
          keymap.set("n", "<leader>gf", builtin.git_files, { desc = "Search git files" })
          keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
     end,
}
