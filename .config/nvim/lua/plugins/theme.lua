-- ~/.config/nvim/lua/plugins/theme.lua

--return {
--  {
--    "joshdick/onedark.vim",
--    lazy = false,        -- Load on startup
--    priority = 1000,     -- Load early
--    config = function()
--      vim.cmd.colorscheme("onedark")
--      vim.api.nvim_set_hl(0, "Normal", { -- Use the terminal's background color
--        fg = "#ABB2BF",
--        bg = "none",
--      })
--    end,
--  },
--}

return {
  {
    "navarasu/onedark.nvim",
    lazy = false,         -- Load on startup
    priority = 1000,      -- Load before other plugins
    config = function()
      require("onedark").setup({
        style = "cool", -- Options: "dark", "darker", "cool", "deep", "warm", "warmer", "light"
        transparent = true, -- Use the terminal's background color
      })

      -- Enable theme
      require("onedark").load()
    end,
  },
}
