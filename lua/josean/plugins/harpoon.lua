return {
     "ThePrimeagen/harpoon",
     branch = "harpoon2", -- ← this is required in 2025–2026
     dependencies = {
          "nvim-lua/plenary.nvim",
     },

     config = function()
          local harpoon = require("harpoon")

          -- Basic setup (you can customize more later)
          harpoon:setup({
               settings = {
                    save_on_toggle = true,
                    sync_on_ui_close = true, -- saves automatically when menu closes
                    key = function()
                         -- Makes list unique per project folder
                         return vim.loop.cwd()
                    end,
               },
          })

          -- Your keybindings (adapted to correct Harpoon 2 API)
          local map = vim.keymap.set
          local opts = { noremap = true, silent = true }

          -- Add current file to list
          map("n", "<leader>a", function()
               harpoon:list():append()
          end, vim.tbl_extend("force", opts, { desc = "Harpoon: Add file" }))

          -- Toggle quick menu
          map("n", "<C-e>", function()
               harpoon.ui:toggle_quick_menu(harpoon:list())
          end, vim.tbl_extend("force", opts, { desc = "Harpoon: Toggle menu" }))

          -- Jump to specific slots (exactly matching your desired bindings)
          map("n", "<M-j>", function()
               harpoon:list():select(1)
          end, { desc = "Harpoon → File 1" })
          map("n", "<M-k>", function()
               harpoon:list():select(2)
          end, { desc = "Harpoon → File 2" })
          map("n", "<M-l>", function()
               harpoon:list():select(3)
          end, { desc = "Harpoon → File 3" })
          map("n", "<M-h>", function()
               harpoon:list():select(4)
          end, { desc = "Harpoon → File 4" })

          -- Optional but very useful: next/previous navigation
          map("n", "<leader>hn", function()
               harpoon:list():next()
          end, { desc = "Harpoon: Next file" })
          map("n", "<leader>hp", function()
               harpoon:list():prev()
          end, { desc = "Harpoon: Previous file" })
     end,
}
