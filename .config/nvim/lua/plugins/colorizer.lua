-- ~/.config/nvim/lua/plugins/colorizer.lua

return {
  {
    "catgoose/nvim-colorizer.lua",
    cmd = { "ColorizerToggle" },
    keys = {
      { "<leader>ct", "<CMD>ColorizerToggle<CR>", desc = "[C]olorizer [T]oggle" },
    },
--    event = "BufReadPre",
    opts = {
      filetypes = { "*" },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = true,
        css = true,
        mode = "background",
      },
    },
--    config = function(_, opts)
--      require("colorizer").setup(opts)
--      vim.keymap.set("n", "<leader>ct", "<CMD>ColorizerToggle<CR>", { desc = "[C]olorizer [T]oggle" })
--    end,
  },
}
