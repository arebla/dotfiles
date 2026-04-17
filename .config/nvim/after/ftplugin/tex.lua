-- ~/.config/nvim/after/ftplugin/tex.lua

vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function()
--    vim.bo.wrapmargin = 10     -- marxe de axuste automático
--    vim.bo.textwidth = 79      -- rompe as liñas na columna 79
--    vim.bo.formatoptions = vim.bo.formatoptions .. "t"  -- auto-wrap ao escribir
--    vim.wo.spell = true        -- activar corrección ortográfica
--    vim.bo.spelllang = "gl"
    vim.wo.linebreak = true    -- non cortar palabras ao final da liña
    vim.wo.wrap = true         -- axuste visual de liñas
  end,
})
