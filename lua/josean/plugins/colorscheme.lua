-- -- Define a function to set the color scheme and make the background transparent
-- function ColorMyPencils(color)
--   color = color or "rose-pine" -- Default to "rose-pine" if no color is provided
--   vim.cmd.colorscheme(color)
--
--   -- Set background transparency for Normal and NormalFloat highlight groups
--   vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
--   vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
-- end
--
-- -- Return the plugins configuration
-- return {
--   -- Tokyonight theme configuration
--   {
--       "folke/tokyonight.nvim",
--       config = function()
--           require("tokyonight").setup({
--               -- Customize the Tokyonight theme
--               style = "storm", -- Options: "storm", "moon", "night", "day"
--               transparent = true, -- Make the background transparent
--               terminal_colors = true, -- Use theme colors in terminal
--               styles = {
--                   comments = { italic = false }, -- Disable italics for comments
--                   keywords = { italic = false }, -- Disable italics for keywords
--                   sidebars = "dark", -- Use "dark" style for sidebars
--                   floats = "dark", -- Use "dark" style for floating windows
--               },
--           })
--
--           -- Apply the theme after setup
--           vim.cmd("colorscheme tokyonight")
--       end
--   },
--
--   -- Rose-pine theme configuration
--   {
--       "rose-pine/neovim",
--       name = "rose-pine", -- Specify the plugin name
--       config = function()
--           require('rose-pine').setup({
--               disable_background = true, -- Disable the background color
--           })
--
--           -- Apply the rose-pine theme and call ColorMyPencils
--           vim.cmd("colorscheme rose-pine")
--           ColorMyPencils()
--       end
--   },
-- }

-- Define a function to set the color scheme and make the background transparent
function ColorMyPencils(color)
     color = color or "rose-pine" -- Default to "rose-pine" if no color is provided

     -- Set background transparency for Normal and NormalFloat highlight groups
     vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
     vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

-- Return the plugins configuration
return {
     -- Tokyonight theme configuration
     {
          "folke/tokyonight.nvim",
          config = function()
               require("tokyonight").setup({
                    -- Customize the Tokyonight theme
                    style = "storm", -- Options: "storm", "moon", "night", "day"
                    transparent = true, -- Make the background transparent
                    terminal_colors = true, -- Use theme colors in terminal
                    styles = {
                         comments = { italic = false }, -- Disable italics for comments
                         keywords = { italic = false }, -- Disable italics for keywords
                         sidebars = "dark", -- Use "dark" style for sidebars
                         floats = "dark", -- Use "dark" style for floating windows
                    },
               })

               -- Apply the theme and set transparency
               vim.cmd("colorscheme tokyonight")
               ColorMyPencils("tokyonight")
          end,
     },

     -- Rose-pine theme configuration
     {
          "rose-pine/neovim",
          name = "rose-pine", -- Specify the plugin name
          config = function()
               require("rose-pine").setup({
                    disable_background = true, -- Disable the background color
               })

               -- Apply the theme and set transparency
               vim.cmd("colorscheme rose-pine")
               ColorMyPencils("rose-pine")
          end,
     },
}

-- return {
--   {
--     "tjdevries/colorbuddy.nvim", -- Use proper GitHub repo path instead of local path
--     lazy = false,
--     priority = 1000,
--     config = function()
--       vim.cmd.colorscheme "gruvbuddy"
--     end,
--   },
--   "rktjmp/lush.nvim",
--   "tckmn/hotdog.vim",
--   "dundargoc/fakedonalds.nvim",
--   {
--     "craftzdog/solarized-osaka.nvim",
--     lazy = false,
--     priority = 1000,
--   },
--   {
--     "rose-pine/neovim",
--     name = "rose-pine",
--     lazy = false,
--     priority = 1000,
--   },
--   "eldritch-theme/eldritch.nvim",
--   {
--     "jesseleite/nvim-noirbuddy",
--     dependencies = {
--       "tjdevries/colorbuddy.nvim", -- Required dependency
--     },
--   },
--   "miikanissi/modus-themes.nvim",
--   {
--     "rebelot/kanagawa.nvim",
--     lazy = false,
--     priority = 1000,
--   },
--   "gremble0/yellowbeans.nvim",
--   {
--     "rockyzhang24/arctic.nvim",
--     branch = "main", -- Specify branch to avoid errors
--   },
--   {
--     "folke/tokyonight.nvim",
--     lazy = false,
--     priority = 1000,
--   },
--   "Shatur/neovim-ayu",
--   "RRethy/base16-nvim",
--   "xero/miasma.nvim",
--   "cocopon/iceberg.vim",
--   "kepano/flexoki-neovim",
--   "ntk148v/komau.vim",
--   {
--     "catppuccin/nvim",
--     name = "catppuccin",
--     priority = 1000,
--     lazy = false,
--   },
--   {
--     "uloco/bluloco.nvim",
--     dependencies = { "rktjmp/lush.nvim" }, -- Required dependency
--   },
--   "LuRsT/austere.vim",
--   "ricardoraposo/gruvbox-minor.nvim",
--   "NTBBloodbath/sweetie.nvim",
--   "vim-scripts/MountainDew.vim",
--   {
--     "maxmx03/fluoromachine.nvim",
--     config = function()
--       local fm = require("fluoromachine")
--       fm.setup({ glow = true, theme = "fluoromachine" })
--     end,
--   },
-- }
