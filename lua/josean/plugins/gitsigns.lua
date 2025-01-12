return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end

      -- Navigation
      map("n", "]h", function() gs.next_hunk() end, "Next Hunk")
      map("n", "[h", function() gs.prev_hunk() end, "Prev Hunk")

      -- Actions
      map("n", "<leader>hs", function() gs.stage_hunk() end, "Stage hunk")
      map("n", "<leader>hr", function() gs.reset_hunk() end, "Reset hunk")
      map("v", "<leader>hs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Stage hunk")
      map("v", "<leader>hr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Reset hunk")

      map("n", "<leader>hS", function() gs.stage_buffer() end, "Stage buffer")
      map("n", "<leader>hR", function() gs.reset_buffer() end, "Reset buffer")

      map("n", "<leader>hu", function() gs.undo_stage_hunk() end, "Undo stage hunk")

      map("n", "<leader>hp", function() gs.preview_hunk() end, "Preview hunk")

      map("n", "<leader>hb", function()
        gs.blame_line({ full = true })
      end, "Blame line")
      map("n", "<leader>hB", function() gs.toggle_current_line_blame() end, "Toggle line blame")

      map("n", "<leader>hd", function() gs.diffthis() end, "Diff this")
      map("n", "<leader>hD", function()
        gs.diffthis("~")
      end, "Diff this ~")

      -- Text object
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Gitsigns select hunk")
    end,
  },
}