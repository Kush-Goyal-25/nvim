-- Remove netrw settings since we're using nvim-tree
-- vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.nu = true
opt.relativenumber = true
opt.number = true
opt.guicursor = ""

-- tabs & indentation
opt.tabstop = 5 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 5 -- 2 spaces for indent width
opt.softtabstop = 5
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one
opt.smartindent = true

opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive
opt.incsearch = true -- if you include mixed case in your search, assumes you want case-sensitive
opt.scrolloff = 8
opt.cursorline = true
opt.undofile = true
-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift
opt.colorcolumn = "80"
opt.updatetime = 50

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
     callback = function()
          vim.highlight.on_yank()
     end,
     group = highlight_group,
     pattern = "*",
})

-- [[ Remove trailing whitespace on save ]]
-- Define the augroup for ThePrimeagenGroup
local ThePrimeagenGroup = vim.api.nvim_create_augroup("ThePrimeagenGroup", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
     group = ThePrimeagenGroup,
     pattern = "*",
     command = [[%s/\s\+$//e]],
})
