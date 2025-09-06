-- File: ~/.config/nvim/lua/snippets/tex/text.lua

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local utils = require("snippets.tex.utils")
local get_visual = utils.get_visual
local line_begin = utils.line_begin

return {

s({trig="tt", dscr="Expands 'tt' into '\texttt{}'"},
  fmta(
    "\\texttt{<>}",
    { i(1) }
  )),

s({ trig = "hr", dscr="The hyperref package's href{}{} command (for url links)"},
  fmta(
    [[\href{<>}{<>}]],
    { i(1, "url"),
      i(2, "display name") }
  )),

s({ trig = "itt", snippetType = "autosnippet" },
  fmta("\\textit{<>}",
    { d(1, get_visual) }
  )),

s({ trig = "bf", snippetType = "autosnippet" },
  fmta("\\textbf{<>}",
    { d(1, get_visual) }
  )),


}
