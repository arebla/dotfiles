-- Lua: user/functions.lua

-- Comando Trim: limpa espazos finais e liñas baleiras
vim.api.nvim_create_user_command('Trim',
    function()
        vim.cmd [[%s/\s\+$//e]] -- eliminar espazos finais
        vim.cmd [[%s/\n\+\%$//e]] -- eliminar liñas finais
    end,
    {} -- argumento obligatorio
)

-- Autocomando ao entrar nunha xanela con buffer
vim.api.nvim_create_autocmd("BufWinEnter",{
    group = vim.api.nvim_create_augroup("Grupito", {clear = true}),
    callback = function()
        vim.fn.matchadd("formato", '\\s\\+$') -- resalta espazos finais con "formato"
        vim.fn.matchadd("formato", '\\($\\n\\s*\\)\\+\\%$') -- resalta liñas baleiras con espazos finais con "formato"
        vim.fn.matchadd("FACER", ':FACER:') -- resalta os :FACER:
    end
})

-- Cores e estilos para os grupos de resalto
vim.api.nvim_set_hl(0, 'formato', { undercurl = true, sp = "#991616" })
vim.api.nvim_set_hl(0, 'FACER', { fg = "#000000", bg = "#ed5151", bold=true })

-- Oculta símbolos por defecto no Markdown
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.conceallevel = 2
    vim.opt_local.concealcursor = "nc"
    vim.bo.textwidth = 79      -- rompe as liñas na columna 79
    vim.bo.formatoptions = vim.bo.formatoptions .. "t"  -- auto-wrap ao escribir
    vim.wo.spell = true        -- activar corrección ortográfica
    vim.wo.linebreak = true    -- non cortar palabras ao final da liña
    vim.wo.wrap = true         -- axuste visual de liñas
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "typst",
  callback = function()
    vim.keymap.set("n", "<leader>p", ":TypstPreview<CR>", { buffer = true, noremap = true, silent = true })

    vim.cmd([[
	setlocal wrapmargin=10
	setlocal formatoptions+=t
	setlocal linebreak
	setlocal spell
	setlocal wrap
    ]])
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function()
--    vim.bo.wrapmargin = 10     -- marxe de axuste automático
    vim.bo.textwidth = 79      -- rompe as liñas na columna 79
    vim.bo.formatoptions = vim.bo.formatoptions .. "t"  -- auto-wrap ao escribir
    vim.wo.spell = true        -- activar corrección ortográfica
--    vim.bo.spelllang = "gl"
    vim.wo.linebreak = true    -- non cortar palabras ao final da liña
    vim.wo.wrap = true         -- axuste visual de liñas
  end,
})
