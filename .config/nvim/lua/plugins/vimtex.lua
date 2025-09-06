-- ~/.config/nvim/lua/plugins/vimtex.lua

return {
  {
    "lervag/vimtex",
    ft = { "tex", "sty", "cls" },
    init = function()
      vim.g.tex_flavor = "latex"
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_compiler_latexmk_engines = {
          ['_'] = '-lualatex',
      }
    end,
  },
}
