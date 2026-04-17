-- ~/.config/nvim/after/ftplugin/markdown.lua

-- Oculta símbolos por defecto no Markdown
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.conceallevel = 2
    vim.opt_local.concealcursor = "nc"
    vim.bo.textwidth = 79      -- rompe as liñas na columna 79
    vim.bo.formatoptions = vim.bo.formatoptions .. "t"  -- auto-wrap ao escribir
--    vim.wo.spell = true        -- activar corrección ortográfica
    vim.wo.linebreak = true    -- non cortar palabras ao final da liña
    vim.wo.wrap = true         -- axuste visual de liñas
  end,
})
