-- ~/.config/nvim/lua/plugins/syntax-clingo.lua

-- Used in Reasoning and Planning

return {
  {
    "rkaminsk/vim-syntax-clingo",
--    ft = { "lp" },
    config = function()
      vim.keymap.set("n", "<leader>r", function()
        vim.cmd("botright split | resize 15 | terminal clingo 0 " .. vim.fn.expand("%"))
      end, { desc = "Compile .lp / .clingo files" })
    end,
  }
}
