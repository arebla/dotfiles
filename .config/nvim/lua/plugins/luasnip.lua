-- ~/.config/nvim/lua/plugins/luasnip.lua

return {
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",

    config = function()
        require("luasnip").config.set_config({ -- Setting LuaSnip config
          -- Enable autotriggered snippets
          enable_autosnippets = true,
          update_events = "TextChanged,TextChangedI", -- Text in repeated nodes gets updated as its typed
          -- Use Tab (or some other key if you prefer) to trigger visual selection
          store_selection_keys = "<Tab>",
        })
        vim.cmd[[
        " Expand or jump in insert mode
        imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'

        " Jump forward through tabstops in visual mode
        smap <silent><expr> <Tab> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Tab>'
        " Jump backward through snippet tabstops with Shift-Tab (for example)
        imap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
        smap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
        imap <silent><expr> <C-j> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-j>'
        smap <silent><expr> <C-j> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-j>'
        imap <silent><expr> <C-k> luasnip#choice_active() ? '<Plug>luasnip-prev-choice' : '<C-k>'
        smap <silent><expr> <C-k> luasnip#choice_active() ? '<Plug>luasnip-prev-choice' : '<C-k>'
        ]]

        -- Reload snippets
        vim.keymap.set('n', '<Leader>po', '<Cmd>lua require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/lua/snippets/"})<CR>')
    end,
  },
}
