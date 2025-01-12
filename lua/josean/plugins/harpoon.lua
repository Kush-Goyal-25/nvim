return {
   {
      "ThePrimeagen/harpoon",
      config = function()
         require("harpoon").setup({
            global_settings = {
               -- Sets the marks upon calling `toggle` on the UI, instead of requiring `:w`.
               save_on_toggle = false,

               -- Saves the harpoon file upon every change. Disabling is not recommended.
               save_on_change = true,

               -- Sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
               enter_on_sendcmd = false,

               -- Closes any tmux windows created by harpoon when you close Neovim.
               tmux_autoclose_windows = false,

               -- Filetypes that you want to prevent from adding to the harpoon list menu.
               excluded_filetypes = { "harpoon" },

               -- Set marks specific to each git branch inside a git repository.
               -- Each branch will have its own set of marked files.
               mark_branch = true,

               -- Enable tabline with harpoon marks.
               tabline = false,
               tabline_prefix = "   ",
               tabline_suffix = "   ",
            },
         })

         -- Require Harpoon modules
         local ui = require("harpoon.ui")
         local mark = require("harpoon.mark")

         -- Keymaps for adding files and navigating the Harpoon UI
         vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Add file to Harpoon" })
         vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "Toggle Harpoon menu" })

         -- Keymaps for navigating files in Harpoon
         vim.keymap.set("n", "<M-j>", function()
            ui.nav_file(1)
         end, { desc = "Navigate to Harpoon file 1" })

         vim.keymap.set("n", "<M-k>", function()
            ui.nav_file(2)
         end, { desc = "Navigate to Harpoon file 2" })

         vim.keymap.set("n", "<M-l>", function()
            ui.nav_file(3)
         end, { desc = "Navigate to Harpoon file 3" })

         vim.keymap.set("n", "<M-h>", function()
            ui.nav_file(4)
         end, { desc = "Navigate to Harpoon file 4" })
      end,
   },
}
