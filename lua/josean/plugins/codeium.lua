return {
    "augmentcode/augment.vim",
    event = "BufEnter", -- Optional: Lazy-load on buffer entry
    config = function()
        -- Keymaps for Augment functionality

        -- Use Ctrl-Y to accept a suggestion
        vim.keymap.set("i", "<M-y>", function()
            vim.schedule(function()
                vim.fn["augment#Accept"]()
            end)
            return ""
        end, { expr = true, silent = true, desc = "Accept Augment completion" })

        -- Use Enter to accept a suggestion, falling back to a newline if no suggestion is available
        vim.keymap.set("i", "<M-n>", function()
            vim.schedule(function()
                vim.fn["augment#Accept"]("\n")
            end)
            return ""
        end, { expr = true, silent = true, desc = "Accept Augment completion or insert newline" })

        -- Normal mode: Open Augment chat
        vim.keymap.set("n", "<leader>ac", ":Augment chat<CR>", { silent = true, desc = "Open Augment chat" })

        -- Visual mode: Open Augment chat with selected text
        vim.keymap.set(
            "v",
            "<leader>ac",
            ":Augment chat<CR>",
            { silent = true, desc = "Open Augment chat with selection" }
        )

        -- Normal mode: Start a new Augment chat
        vim.keymap.set("n", "<leader>an", ":Augment chat-new<CR>", { silent = true, desc = "Start new Augment chat" })

        -- Normal mode: Toggle Augment chat
        vim.keymap.set("n", "<leader>at", ":Augment chat-toggle<CR>", { silent = true, desc = "Toggle Augment chat" })
    end,
}
