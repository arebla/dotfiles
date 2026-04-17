-- File: ~/.config/nvim/lua/snippets/tex/utils.lua

-- See:
--  https://ejmastnak.com/tutorials/vim-latex/luasnip/#config
--  https://evesdropper.dev/files/luasnip/ultisnips-to-luasnip/

local M = {}

-- Be sure to explicitly define these LuaSnip node abbreviations!
local ls = require("luasnip")
local sn = ls.snippet_node
local i = ls.insert_node

-- Summary: When `LS_SELECT_RAW` is populated with a visual selection, the function
-- returns an insert node whose initial text is set to the visual selection.
-- When `LS_SELECT_RAW` is empty, the function simply returns an empty insert node.
function M.get_visual(args, parent)
  if (#parent.snippet.env.LS_SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else  -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

M.line_begin = require("luasnip.extras.expand_conditions").line_begin

-- Expand only in determined contexts (requires VimTeX)
--local in_mathzone = function()
--  return vim.fn['vimtex#syntax#in_mathzone']() == 1
--end
--local tex_utils = {}

M.in_mathzone = function()  -- math context detection
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end
M.in_text = function()
  return not in_mathzone()
end
M.in_comment = function()  -- comment detection
  return vim.fn['vimtex#syntax#in_comment']() == 1
end
M.in_env = function(name)  -- generic environment detection
    local is_inside = vim.fn['vimtex#env#is_inside'](name)
    return (is_inside[1] > 0 and is_inside[2] > 0)
end
M.in_equation = function()  -- equation environment detection
    return in_env('equation')
end
M.in_itemize = function()  -- itemize environment detection
    return in_env('itemize')
end
M.in_tikz = function()  -- TikZ picture environment detection
    return in_env('tikzpicture')
end

return M
