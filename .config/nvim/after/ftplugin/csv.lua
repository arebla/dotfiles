local status_ok, ls = pcall(require, "luasnip")
if not status_ok then
    return
end

ls.filetype_extend("csv", { "tex" })
