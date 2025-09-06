-- File: ~/.config/nvim/lua/snippets/tex/environments.lua

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

s({ trig='minipage', dscr='Minipage environment', snippetType = "autosnippet", condition = line_begin },
  fmta(
    [[
      \begin{minipage}[t]{0.5\linewidth}
      <>
      \end{minipage}
      \begin{minipage}[t]{0.5\linewidth}
      <>
      \end{minipage}
    ]],
  { i(1), i(2) }
  )),

--s({ trig='fig', condition = line_begin},
--  fmta(
--    [[
--      \begin{figure}[${1:htpb}]
--          \centering
--          ${2:\includegraphics[scale=0.8]{fig/$3}}
--          \caption{${4:$3}}
--          \label{fig:${5:${3/\W+/-/g}}}
--      \end{figure}
--    ]],
--  { i(1, "htpb"),  }
--  )),














}
