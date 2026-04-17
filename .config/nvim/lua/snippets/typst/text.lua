-- File: ~/.config/nvim/lua/snippets/typst/text.lua

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

local function in_mathzone()
  return vim.api.nvim_eval("typst#in_math()") == 1
end

local iv = function(i, ...)
  return d(i, get_visual, ...)
end

return {

s({trig="tt", dscr="Expands 'tt' into '\texttt{}'" },
  fmta(
    "`<>`",
    { i(1) }
  )),

s({ trig = "itt", snippetType = "autosnippet" },
  fmta("_<>_",
    { d(1, get_visual) }
  )),

s({ trig = "bf", snippetType = "autosnippet" },
  fmta("*<>*",
    { d(1, get_visual) }
  )),

s({ trig = "red" },
  fmta("#text(red)[<>]",
    { d(1, get_visual) }
  )),

s({ trig = "mail" },
  fmt([[
        #link("mailto:<>")
      ]],
    { d(1, get_visual) },
    { delimiters='<>' }
  )),

s({trig = "s", condition = line_begin },
  { t("= "), }
  ),
s({trig = "ss", condition = line_begin },
  { t("== "), }
  ),
s({trig = "sss", condition = line_begin },
  { t("=== "), }
  ),
s({trig = "rf", snippetType = "autosnippet" },
  { t("\\ "), }
  ),

  -- SECTION
  s({ trig = "h1", snippetType = "autosnippet" },
    fmta(
      [[= <> <<sec:<>>>
<>]],
      {
        iv(1),
        l(l._1:gsub("%s", "-"), 1),
        i(0),
      }
    ),
    { condition = in_textzone }
  ),
  -- SUBSECTION
  s({ trig = "h2", snippetType = "autosnippet" },
    fmta(
      [[== <>  <<subsec:<>>>
<>]],
      {
        iv(1),
        l(l._1:gsub("%s", "-"), 1),
        i(0),
      }
    ),
    { condition = in_textzone }
  ),
  -- SUBSUBSECTION
  s({ trig = "h3", snippetType = "autosnippet" },
    fmta(
      [[=== <>  <<subsubsec:<>>>
<>]],
      {
        iv(1),
        l(l._1:gsub("%s", "-"), 1),
        i(0),
      }
    ),
    { condition = in_textzone }
  ),

  -- GREEK
  s({ trig = ",a", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("alpha"),
  }),
  s({ trig = ",b", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("beta"),
  }),
  s({ trig = ",g", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("gamma"),
  }),
  s({ trig = ",G", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("Gamma"),
  }),
  s({ trig = ",d", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("delta"),
  }),
  s({ trig = ",D", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("Delta"),
  }),
  s({ trig = ",e", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("epsilon"),
  }),
  s({ trig = ",ve", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("varepsilon"),
  }),
  s({ trig = ",z", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("zeta"),
  }),
  s({ trig = ",h", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("eta"),
  }),
  s({ trig = ",o", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("theta"),
  }),
  s({ trig = ",vo", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("vartheta"),
  }),
  s({ trig = ",O", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("Theta"),
  }),
  s({ trig = ",k", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("kappa"),
  }),
  s({ trig = ",l", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("lambda"),
  }),
  s({ trig = ",L", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("Lambda"),
  }),
  s({ trig = ",m", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("mu"),
  }),
  s({ trig = ",n", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("nu"),
  }),
  s({ trig = ",x", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("xi"),
  }),
  s({ trig = ",X", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("Xi"),
  }),
  s({ trig = ",i", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("pi"),
  }),
  s({ trig = ",I", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("Pi"),
  }),
  s({ trig = ",r", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("rho"),
  }),
  s({ trig = ",s", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("sigma"),
  }),
  s({ trig = ",S", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("Sigma"),
  }),
  s({ trig = ",t", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("tau"),
  }),
  s({ trig = ",f", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("phi"),
  }),
  s({ trig = ",vf", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("varphi"),
  }),
  s({ trig = ",F", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("Phi"),
  }),
  s({ trig = ",c", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("chi"),
  }),
  s({ trig = ",p", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("psi"),
  }),
  s({ trig = ",P", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("Psi"),
  }),
  s({ trig = ",w", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("omega"),
  }),
  s({ trig = ",W", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" }, {
    t("Omega"),
  }),

-- LINE
  s({ trig = "line", condition = line_begin, snippetType = "autosnippet" },
  { t("#line(length: 100%, stroke: 0.5pt)"), }
    ),

}
