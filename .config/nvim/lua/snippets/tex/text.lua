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
local in_mathzone = utils.in_mathzone

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

  s({ trig = "chap", snippetType = "autosnippet" },
    fmta(
      [[\chapter{<>}]],
      { i(1) }
    ),
    { condition = line_begin }
  ),

  s({ trig = "h1", snippetType = "autosnippet" },
    fmta(
      [[\section{<>}]],
      { i(1) }
    ),
    { condition = line_begin }
  ),

  s({ trig = "h2", snippetType = "autosnippet" },
    fmta(
      [[\subsection{<>}]],
      { i(1) }
    ),
    { condition = line_begin }
  ),

  s({ trig = "h3", snippetType = "autosnippet" },
    fmta(
      [[\subsubsection{<>}]],
      { i(1) }
    ),
    { condition = line_begin }
  ),

  -- GREEK
  s({ trig = ",a", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\alpha"),
  }),
  s({ trig = ",b", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\beta"),
  }),
  s({ trig = ",g", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\gamma"),
  }),
  s({ trig = ",G", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\Gamma"),
  }),
  s({ trig = ",d", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\delta"),
  }),
  s({ trig = ",D", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\Delta"),
  }),
  s({ trig = ",e", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\epsilon"),
  }),
  s({ trig = ",ve", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\varepsilon"),
  }),
  s({ trig = ",z", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\zeta"),
  }),
  s({ trig = ",h", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\eta"),
  }),
  s({ trig = ",o", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\theta"),
  }),
  s({ trig = ",vo", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\vartheta"),
  }),
  s({ trig = ",O", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\Theta"),
  }),
  s({ trig = ",k", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\kappa"),
  }),
  s({ trig = ",l", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\lambda"),
  }),
  s({ trig = ",L", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\Lambda"),
  }),
  s({ trig = ",m", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\mu"),
  }),
  s({ trig = ",n", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\nu"),
  }),
  s({ trig = ",x", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\xi"),
  }),
  s({ trig = ",X", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\Xi"),
  }),
  s({ trig = ",i", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\pi"),
  }),
  s({ trig = ",I", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\Pi"),
  }),
  s({ trig = ",r", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\rho"),
  }),
  s({ trig = ",s", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\sigma"),
  }),
  s({ trig = ",S", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\Sigma"),
  }),
  s({ trig = ",t", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\tau"),
  }),
  s({ trig = ",f", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\phi"),
  }),
  s({ trig = ",vf", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\varphi"),
  }),
  s({ trig = ",F", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\Phi"),
  }),
  s({ trig = ",c", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\chi"),
  }),
  s({ trig = ",p", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\psi"),
  }),
  s({ trig = ",P", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\Psi"),
  }),
  s({ trig = ",w", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\omega"),
  }),
  s({ trig = ",W", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("\\Omega"),
  }),

}
