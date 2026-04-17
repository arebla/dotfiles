-- ~/.config/nvim/after/ftplugin/typst.lua

vim.api.nvim_create_autocmd("FileType", {
  pattern = "typ",
  callback = function()
    vim.keymap.set("n", "<leader>p", ":TypstPreview<CR>", { buffer = true, noremap = true, silent = true })
    -- Bold: *bold*
    vim.fn.matchadd("TypstBold", [[\*\zs[^*]\+\ze\*]])
    -- Italic: _italic_
    vim.fn.matchadd("TypstItalic", [[_\zs[^_]\+\ze_]])
    -- Underline: __underline__
    vim.fn.matchadd("TypstUnderline", [[__\zs[^_]\+\ze__]])
    vim.api.nvim_set_hl(0, 'TypstBold', { fg = "#e06c75", bold = true })
    vim.api.nvim_set_hl(0, 'TypstItalic', { fg = "#61afef", italic = true })
    vim.api.nvim_set_hl(0, 'TypstUnderline', { fg = "#98c379", underline = true })

    vim.cmd([[
	setlocal textwidth=79
	setlocal formatoptions+=t
	setlocal linebreak
	setlocal wrap
    ]])
  end,
})
