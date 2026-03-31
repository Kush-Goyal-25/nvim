return {
     "monkoose/neocodeium",
     event = "VeryLazy",
     config = function()
          local neocodeium = require("neocodeium")
          local commands = require("neocodeium.commands")

          neocodeium.setup({
               enabled = false, -- disabled on startup
          })

          -- Toggle neocodeium on/off in normal mode
          vim.keymap.set("n", "<leader>nc", function()
               commands.toggle()
               local status = neocodeium.get_status and neocodeium.get_status() or "toggled"
               vim.notify("Neocodeium " .. (status == 0 and "enabled" or "disabled"), vim.log.levels.INFO)
          end, { desc = "Toggle Neocodeium" })

          -- Accept full suggestion
          vim.keymap.set("i", "<A-y>", function()
               neocodeium.accept()
          end, { desc = "Neocodeium: Accept suggestion" })

          -- Accept next word only
          vim.keymap.set("i", "<A-w>", function()
               neocodeium.accept_word()
          end, { desc = "Neocodeium: Accept word" })

          -- Accept current line only
          vim.keymap.set("i", "<A-a>", function()
               neocodeium.accept_line()
          end, { desc = "Neocodeium: Accept line" })

          -- Cycle forward through suggestions / trigger completion
          vim.keymap.set("i", "<A-e>", function()
               neocodeium.cycle_or_complete()
          end, { desc = "Neocodeium: Next suggestion" })

          -- Cycle backward through suggestions
          vim.keymap.set("i", "<A-r>", function()
               neocodeium.cycle_or_complete(-1)
          end, { desc = "Neocodeium: Previous suggestion" })

          -- Clear current suggestion
          vim.keymap.set("i", "<A-c>", function()
               neocodeium.clear()
          end, { desc = "Neocodeium: Clear suggestion" })
     end,
}
