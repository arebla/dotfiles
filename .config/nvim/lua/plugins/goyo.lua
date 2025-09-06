-- ~/.config/nvim/lua/plugins/goyo.lua

return {
  {
    "junegunn/goyo.vim",
    cmd = { "Goyo" },
    keys = {
      { "<leader>zg", "<CMD>Goyo<CR>", desc = "Toggle Goyo" },
    },
  },
}
