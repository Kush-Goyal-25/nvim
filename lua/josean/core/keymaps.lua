vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness
local opts = {} -- optional default options

-- Exit insert mode with jk or kj
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set("i", "kj", "<ESC>", { desc = "Exit insert mode with kj" })

keymap.set("i", "<C-h>", "<Left>", { noremap = true, silent = true })
keymap.set("i", "<C-l>", "<Right>", { noremap = true, silent = true })
-- keymap.set("i", "<C-j>", "<Down>", { noremap = true, silent = true })
-- keymap.set("i", "<C-k>", "<Up>", { noremap = true, silent = true })

keymap.set("i", "<C-b>", "<C-o>^", { noremap = true, silent = true })
keymap.set("i", "<C-a>", "<C-o>$", { noremap = true, silent = true })

-- Clear search highlights
keymap.set("n", "<leader>nn", ":nohl<CR>", { desc = "Clear search highlights" })
keymap.set("n", "TT", ":TransparentToggle<CR>", { noremap = true })
-- Increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- Window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- Tab management
keymap.set("n", "<leader>to", ":tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", ":tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", ":tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", ":tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", ":tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- Buffer management
keymap.set("n", "<leader>tk", ":blast<CR>", { desc = "Go to last buffer" })
keymap.set("n", "<leader>tj", ":bfirst<CR>", { desc = "Go to first buffer" })

-- Force quit and force write
keymap.set("n", "<leader>qq", ":q!<CR>", { desc = "Force quit" })
keymap.set("n", "<leader>ww", ":w!<CR>", { desc = "Force write" })

-- Navigate to start or end of line
keymap.set("n", "E", "$", { desc = "Go to end of line" })
keymap.set("n", "B", "^", { desc = "Go to beginning of line" })

-- Save and close mappings
keymap.set("n", "<leader>wa", ":wqa<CR>", { desc = "Save and close all" })
keymap.set("n", "<leader>wq", ":wq<CR>", { desc = "Save and close current" })
keymap.set("n", "<leader>qq", ":qa<CR>", { desc = "Quit all" }) -- Fixed `qq` to quit all buffers
keymap.set("n", "<leader>qa", ":qa!<cr>", { desc = "Close all without saving" }) -- Close all buffers without saving

-- Move to the first non-blank character of the line
keymap.set("n", "<BS>", "^", { desc = "Move to first non-blank character of the line" })

-- Center screen after scrolling
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Center screen after page up" })
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Center screen after page down" })

-- Keep cursor centered when searching
keymap.set("n", "n", "nzzzv", { desc = "Keep cursor centered after searching forward" })
keymap.set("n", "N", "Nzzzv", { desc = "Keep cursor centered after searching backward" })

-- Select all
keymap.set("n", "<leader>pa", "ggVGp", { desc = "Select all and paste" })
keymap.set("n", "<leader>sa", "ggVG", { desc = "Select all" })

-- Indentation and selection
keymap.set("v", "<", "<gv^", opts)
keymap.set("v", ">", ">gv^", opts)

-- Move selected lines
keymap.set("x", "J", ":m '>+1<CR>gv=gv", opts)
keymap.set("x", "K", ":m '<-2<CR>gv=gv", opts)

-- Delete without yanking
keymap.set("n", "x", '"_x', opts)

-- Open new lines and indent
keymap.set("n", "<leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<leader>O", "O<Esc>^Da", opts)

-- Yank to clipboard
keymap.set({ "n", "v" }, "<leader>y", [["+y]], opts)
keymap.set("n", "<leader>yy", [["+Y]], opts)

-- Paste from clipboard
keymap.set("v", "p", '"_dP', opts) -- Prevent overwriting selection
keymap.set("n", "<leader>p", '"+p', { desc = "Paste from system clipboard" })
keymap.set("v", "<leader>p", '"+p', { desc = "Paste from system clipboard" })

-- Delete without yanking
keymap.set({ "n", "v" }, "<leader>d", [["_d]], opts)

-- Join lines while keeping cursor position
keymap.set("n", "J", "mzJ`z")

-- Search and replace the word under cursor
keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Open terminal
keymap.set("n", "<leader>tt", ":terminal<CR>", { desc = "Open terminal" })
