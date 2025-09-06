-- File: ~/.config/nvim/init.lua

vim.deprecate = function() end
-- Disable warning
--vim.g.loaded_python3_provider = 0
vim.g.python3_host_prog = "/usr/bin/python3"

-- Automatically reload the configuration file after saving it
vim.cmd([[autocmd! BufWritePost $MYVIMRC luafile %]])

-- General options
vim.o.number = true
vim.o.relativenumber = true
vim.o.encoding = "utf-8"
--vim.o.clipboard = vim.o.clipboard .. "unnamedplus"
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.o.cursorline = true
vim.o.showcmd = true
vim.o.ruler = false
vim.o.backup = false
vim.o.swapfile = false

vim.o.visualbell = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.opt.colorcolumn = "79"

-- Indentation options
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--------------
-- Mappings --
--------------

-- Map 'jk' to exit insert mode
vim.keymap.set('i', 'jk', '<Esc>', { noremap = true })
-- Map 'ww' to save the file
vim.keymap.set('n', 'ññ', ':w<CR>', { noremap = true })
-- Map 'bd' to close the current buffer
vim.keymap.set('n', 'bd', ':bd<CR>', { noremap = true })
-- Map '\\' to clear the search highlight
vim.keymap.set('n', '\\', ':noh<CR>', { noremap = true })
-- Map 'oo' to insert a line below and exit insert mode
vim.keymap.set('n', 'oo', 'o<Esc>', { noremap = true })
-- Map 'OO' to insert a line above and exit insert mode, then move down
vim.keymap.set('n', 'OO', 'O<Esc>j', { noremap = true })

-- Map <C-c> to copy the selected text to the system clipboard in visual mode
vim.keymap.set('x', '<C-c>', '"*y', { noremap = true })

-- Map <C-BS> and <C-H> to <C-W> in command-line mode
vim.keymap.set('c', '<C-BS>', '<C-\\><C-O>db', { noremap = true })
vim.keymap.set('c', '<C-H>', '<C-\\><C-O>db', { noremap = true })
vim.keymap.set('i', '<C-H>', '<C-\\><C-O>db', { noremap = true, silent = true })
vim.keymap.set('i', '<C-BS>', '<C-\\><C-O>db', { noremap = true, silent = true })

-- Map <C-l> to convert the current previous spelling mistakes
vim.keymap.set('i', '<C-l>', '<C-g>u<Esc>[s1z=`]a<C-g>u', { noremap = true })

-------------
-- Plugins --
-------------

require("config.lazy")

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

require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/lua/snippets/" })
vim.keymap.set('n', '<Leader>po', '<Cmd>lua require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/lua/snippets/"})<CR>')

require("functions")
