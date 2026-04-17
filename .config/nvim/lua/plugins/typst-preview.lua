-- ~/.config/nvim/lua/plugins/typst-preview.lua

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.typ",
    callback = function()
        local filename = vim.fn.expand("%:t")
        local output = vim.fn.expand("%:r") .. ".pdf"
--        local packages_path = vim.env.HOME .. "/OneDrive/MSc/Administrativia/typst"

        -- Compilaton with absolute --path
--        local cmd = string.format("typst compile --path %s %s %s 2>&1", packages_path, filename, output)
        --vim.fn.systemlist(cmd)
        local result = vim.fn.systemlist("typst compile " .. filename .. " " .. output .. " 2>&1")
        if vim.v.shell_error ~= 0 then
            vim.fn.setqflist({}, ' ', {title='Typst Compile Errors', lines=result})
            vim.cmd("copen")
--        else
--            print("Compiled " .. filename .. " " .. output)
        end
    end
})


-- Buffer-local mapping for Typst files
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"typ", "typst"},
    callback = function()
        vim.keymap.set("n", "<leader>l", function()
            local pdf = vim.fn.expand("%:p:r") .. ".pdf"
            vim.fn.system("zathura --fork " .. pdf .. " &")
        end, { buffer = 0, silent = true })
        vim.keymap.set("n", "<leader>p", ":TypstPreview<CR>", { buffer = 0 })
    end
})


return {
  {
    'chomosuke/typst-preview.nvim',
    ft = 'typst',
    version = '1.*',
    opts = {}, -- lazy.nvim will implicitly calls `setup {}`
  },
  {
    'kaarmu/typst.vim',
    ft = 'typst',
--    lazy=true,
  },
}
