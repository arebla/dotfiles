-- File: ~/.config/nvim/lua/snippets/tex/math.lua

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

-- Some comments:
--   wordTrig:
--    - true: a snippet only expands if the trigger follows a non-word
--            character (such as a space, tab, or punctuation) or occurs at the
--            beginning of a line.
--    - false: disables this check
--

local generate_matrix = function(args, snip)
	local rows = tonumber(snip.captures[2])
	local cols = tonumber(snip.captures[3])
	local nodes = {}
	local ins_indx = 1
	for j = 1, rows do
		table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1)))
		ins_indx = ins_indx + 1
		for k = 2, cols do
			table.insert(nodes, t(" & "))
			table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1)))
			ins_indx = ins_indx + 1
		end
		table.insert(nodes, t({ "\\\\", "" }))
	end
	-- fix last node.
	nodes[#nodes] = t("\\\\")
	return sn(nil, nodes)
end

return {

s({trig = "mk", snippetType = "autosnippet"},
  fmta(
    [[\(<>\)]],
    { d(1, get_visual) }
  )),

--s({trig = "([^%a])mk", wordTrig = false, regTrig = true, snippetType = "autosnippet"},
--  fmta(
--    [[<>\(<>\)]],
--    { f( function(_, snip) return snip.captures[1] end ),
--      d(1, get_visual) }
--  )),

s({trig = "dm", snippetType = "autosnippet"},
  fmta(
    [[
      \[
          <>
      \]
    ]],
    {  d(1, get_visual) }
  )),

s({trig = "([^%a])fr", regTrig = true, wordTrig = false, condition = in_mathzone, snippetType = "autosnippet"},
  fmta(
    [[<>\frac{<>}{<>}]],
    { f( function(_, snip) return snip.captures[1] end ), -- Needed for regex
      i(1), i(2) }
  )),

s({trig = "sq", wordTrig = true, condition = in_mathzone, snippetType = "autosnippet"},
  fmta(
    [[\sqrt{<>}]],
    { d(1, get_visual) }
  )),

s({trig = "sum", snippetType = "autosnippet", wordTrig = false, regTrig = true, condition = in_mathzone},
    fmta([[<>]],
        { c(1,{
            sn(nil,fmta([[ \sum<> ]], { i(1) })),
            sn(nil,fmta([[ \sum_{<>}^{<>}<> ]], { d(1, get_visual),i(2), i(0) })),
            }) }
    )),

s({trig = "beg", condition = line_begin, snippetType = "autosnippet"},
  fmt(
    [[
      \begin{<>}
          <>
      \end{<>}
    ]],
    { i(1), i(2), rep(1) },
    { delimiters = "<>" }
  )),

s({trig = "beq", condition = line_begin, snippetType = "autosnippet"},
  fmta(
    [[
      \begin{equation}
          <>
      \end{equation}
    ]],
    { i(1) }
  )),

s({trig = 'sd', condition = in_mathzone, snippetType = "autosnippet"},
  fmta("_{\\mathrm{<>}}",
    { d(1, get_visual) }
  )
),

s({trig = "int ", snippetType = "autosnippet" },
    fmta([[<>]],
        { c(1,{
            t("\\int_{-\\infty}^\\infty"),
            sn(nil,fmta([[ \int_{<>}^{<>} ]],{i(1),i(2)})),
            }) }
    )),

s({trig = "([%sbBpvV])Mat(%d+)x(%d+)", snippetType = "autosnippet", regTrig = true, wordTrig = false, desc = "[bBpvV]matrix of A x B size"},
    fmta([[
    \begin{<>}
    <>
    \end{<>}]],
    {
    f(function(_, snip)
        if  snip.captures[1] ==" " then
            return "matrix"
        else
            return snip.captures[1] .. "matrix"
        end
    end),
    d(1, generate_matrix),
    f(function(_, snip)
        return snip.captures[1] .. "matrix"
    end)
    }),
    { show_condition = in_mathzone }
),

s({ trig = "@p", snippetType = "autosnippet" }, t("\\partial"), { condition = in_mathzone }),
s({ trig = "dot", snippetType = "autosnippet" }, t("\\cdot"), { condition = in_mathzone }),
s({ trig = "oplus", snippetType = "autosnippet" }, t("\\oplus"), { condition = in_mathzone }),
s({ trig = "odot", snippetType = "autosnippet" }, t("\\odot"), { condition = in_mathzone }),
s({ trig = "otimes", snippetType = "autosnippet" }, t("\\otimes"), { condition = in_mathzone }),
s({ trig = "!=", snippetType = "autosnippet" }, t("\\neq"), { condition = in_mathzone }),
s({ trig = ">>", snippetType = "autosnippet" }, t("\\gg"), { condition = in_mathzone }),
s({ trig = "<<", snippetType = "autosnippet" }, t("\\ll"), { condition = in_mathzone }),
s({ trig = "~~", snippetType = "autosnippet" }, t("\\sim"), { condition = in_mathzone }),
s({ trig = "approx", snippetType = "autosnippet" }, t("\\approx"), { condition = in_mathzone }),
s({ trig = "mid", snippetType = "autosnippet" }, t("\\mid"), { condition = in_mathzone }),
s({ trig = "notin", snippetType = "autosnippet" }, t("\\not\\in"), { condition = in_mathzone }),
s({ trig = "<=", snippetType = "autosnippet" }, t("\\leq"), { condition = in_mathzone }),
s({ trig = ">=", snippetType = "autosnippet" }, t("\\geq"), { condition = in_mathzone }),
s({ trig = "implies", snippetType = "autosnippet" }, t("\\rightarrow"), { condition = in_mathzone }),
s({ trig = "to ", snippetType = "autosnippet" }, t("\\rightarrow"), { condition = in_mathzone }),
s({ trig = "=>", snippetType = "autosnippet" }, t("\\Rightarrow"), { condition = in_mathzone }),
s({ trig = "<->", snippetType = "autosnippet" }, t("\\leftrightarrow"), { condition = in_mathzone }),
s({ trig = "<=>", snippetType = "autosnippet" }, t("\\Leftrightarrow"), { condition = in_mathzone }),
s({ trig = "**", snippetType = "autosnippet" }, t("\\cdot"), { condition = in_mathzone }),
s({ trig = "xx", snippetType = "autosnippet" }, t("\\times"), { condition = in_mathzone }),
s({ trig = "+-", snippetType = "autosnippet" }, t("\\pm"), { condition = in_mathzone }),
s({trig = "-+", snippetType = "autosnippet", condition = in_mathzone}, { t("\\mp") }),
s({ trig = "ooo", snippetType = "autosnippet" }, t("\\infty"), { condition = in_mathzone }),
s({ trig = "exp", snippetType = "autosnippet" }, t("\\exp"), { condition = in_mathzone }),
s({trig = "and", snippetType = "autosnippet", condition = in_mathzone}, { t("\\cap") }),
s({trig = "or", snippetType = "autosnippet", condition = in_mathzone}, { t("\\cup") }),
s({trig = "in", snippetType = "autosnippet", condition = in_mathzone}, { t("\\in") }),
s({trig = "ll", snippetType = "autosnippet", condition = in_mathzone}, { t("\\ell") }),

s({trig = "...", snippetType = "autosnippet", condition = in_mathzone}, {
		c(1, {
			t("\\dots"),
			t("\\vdots"),
			t("\\ddots"),
		})
	}),

s({trig = "lim", snippetType = "autosnippet", condition = in_mathzone}, fmta("\\lim_{<> \\to <>}<>", { i(1, "n"), i(2, "\\infty"), i(0)})),

s({trig = "undb", snippetType = "autosnippet", condition = in_mathzone}, fmta("\\underbrace{<>}_{<>}", { d(1, get_visual), i(2) })),


  s({ trig = "lr", wordTrig = false },
   fmta("\\left( <> \\right)<>", {
     d(1, get_visual),
     i(0),
   }),
   { condition = in_mathzone }
  ),
  s({ trig = "lrb", wordTrig = false, snippetType = "autosnippet" },
    fmta("\\left\\{ <> \\right\\}<>", {
      d(1, get_visual),
      i(0),
    }),
    { condition = in_mathzone }
  ),
  s({ trig = "lrs", wordTrig = false, snippetType = "autosnippet" },
    fmta("\\left[ <> \\right])<>", {
      d(1, get_visual),
      i(0),
    }),
    { condition = in_mathzone }
  ),
  s({ trig = "lrc", wordTrig = false, snippetType = "autosnippet" },
    fmta("\\left| <> \\right|<>", {
      d(1, get_visual),
      i(0),
    }),
    { condition = in_mathzone }
  ),

  s({trig = "lra", condition = in_mathzone, snippetType = "autosnippet"},
    fmta([[\left\lvert <> \right\rangle]],
    { i(1) }
   )),

-- SUBSCRIPT
s({
    trig = "([%w%)%]%}|])__",
    wordTrig = false,
    regTrig = true,
    snippetType = "autosnippet",
  },
  fmta("<>_{<>}", {
    f(function(_, snip)
      return snip.captures[1]
    end),
    d(1, get_visual),
  }),
  { condition = in_mathzone }),

-- SUBSCRIPT con índices
s({
    trig = "([%w%)%]%}|])_([ijknmtvd])",
    wordTrig = false,
    desc = "subscript",
    regTrig = true,
    snippetType = "autosnippet",
  },
  fmta("<>_{<> <>}<>", {
    f(function(_, snip)
      return snip.captures[1]
    end),
    f(function(_, snip)
      return snip.captures[2]
    end),
    i(1),
    i(0),
  }),
  { condition = in_mathzone }
),

  -- SUBSCRIPT con números
  s(
    { trig = "([%a])(%d+)", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>_{<><>}<>", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
      i(1), i(0),
    }),
    { condition = in_mathzone }
  ),

-- Superscript
  s(
    { trig = "([%w%)%]%}|])td", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>^{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "([%w%)%]%}|])rd", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>^{(<>)}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = in_mathzone }
  ),

s({ trig = "sr", snippetType = "autosnippet", wordTrig = false }, t("^2"), { condition = in_mathzone }),
s({ trig = "cb", snippetType = "autosnippet", wordTrig = false }, t("^3"), { condition = in_mathzone }),
s({ trig = "inv", snippetType = "autosnippet", wordTrig = false }, t("^{-1}"), { condition = in_mathzone }),

  s({ trig = "(%d?)cases", regTrig = true, snippetType = "autosnippet" },
    fmta(
      [[
        \begin{cases}
        	<>
        \end{cases}
      ]],
      { i(1) }
    ),
    { condition = in_mathzone }
  ),

  --- Accents - hat
  s({ trig = "hat", wordTrig = false, snippetType = "autosnippet" },
    fmta([[\hat{<>}]], {
      i(1),
    }),
    { condition = in_mathzone }
  ),

  s({ trig = "bar", wordTrig = false, snippetType = "autosnippet" },
    fmta([[\overline{<>}]], {
      i(1),
    }),
    { condition = in_mathzone }
  ),

  s({ trig = "tild", wordTrig = false, snippetType = "autosnippet" },
    fmta([[\widetilde{<>}]], {
      i(1),
    }),
    { condition = in_mathzone }
  ),


  s({ trig = "bb", wordTrig = false, snippetType = "autosnippet" },
    fmta([[\mathbb{<>}<>]], {
      d(1, get_visual),
      i(0),
    }),
    { condition = in_mathzone }
  ),
  s({ trig = "cal", wordTrig = false, snippetType = "autosnippet" },
    fmta([[\mathcal{<>}<>]], {
      d(1, get_visual),
      i(0),
    }),
    { condition = in_mathzone }
  ),
  s({ trig = "scr", wordTrig = false, snippetType = "autosnippet" },
    fmta([[\mathscr{<>}<>]], {
      d(1, get_visual),
      i(0),
    }),
    { condition = in_mathzone }
  ),
  s({ trig = "msf", wordTrig = false, snippetType = "autosnippet" },
    fmta([[\mathsf{<>}<>]], {
      d(1, get_visual),
      i(0),
    }),
    { condition = in_mathzone }
  ),

s({trig = "mfra", snippetType = "autosnippet", condition = in_mathzone}, fmta("\\mathfrack{<>}<>", { i(1), i(0) } )),

s({trig = "bra", condition = in_mathzone}, fmta("\\left\\langle <> \\right\\rvert", { i(1) }) ),
s({trig = "ket", condition = in_mathzone}, fmta("\\left\\lvert <> \\right\\rangle", { i(1) }) ),
s({trig = "braket", condition = in_mathzone},
  fmta("\\left\\lvert <> \\middle| <>  \\right\\rangle",
  { i(1), i(2), })),

}
