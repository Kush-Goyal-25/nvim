return {
     "gbprod/substitute.nvim",
     event = { "BufReadPre", "BufNewFile" },
     config = function()
          local substitute = require("substitute")

          substitute.setup()

          -- set keymaps
          local keymap = vim.keymap -- for conciseness

          keymap.set("n", "<leader>ns", substitute.operator, { desc = "Substitute with motion" })
          keymap.set("n", "<leader>nss", substitute.line, { desc = "Substitute line" })
          keymap.set("n", "<leader>nS", substitute.eol, { desc = "Substitute to end of line" })
          keymap.set("x", "<leader>ns", substitute.visual, { desc = "Substitute in visual mode" })
     end,
}
