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

-- Documentation:
--  https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
--
-- Params:
--   wordTrig: Boolean, if true, the snippet is only expanded if the word
--             ([%w_]+) before the cursor matches the trigger entirely. True by
--             default.
--             E.g.: If "false", acot -> a\cot.
--
--   regTrig: Boolean, whether the trigger should be interpreted as a Lua
--            pattern. False by default.

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

s({trig = "sq", condition = in_mathzone, snippetType = "autosnippet"},
  fmta(
    [[\sqrt{<>}]],
    { d(1, get_visual) }
  )),

s({trig = "lim", snippetType = "autosnippet", condition = in_mathzone},
   fmta("\\lim_{<> \\to <>}<>",
   { i(1, "n"), i(2, "\\infty"), i(0)})
 ),

s({trig = "sum", snippetType = "autosnippet", wordTrig = false, regTrig = true, condition = in_mathzone},
    fmta([[<>]],
        { c(1,{
            sn(nil,fmta([[ \sum_{<>}^{<>}<> ]], { d(1, get_visual),i(2, "\\infty"), i(0) })),
            sn(nil,fmta([[ \sum<> ]], { i(1) })),
            }) }
    )),

s({trig = "prod", snippetType = "autosnippet", wordTrig = false, regTrig = true, condition = in_mathzone},
    fmta([[<>]],
        { c(1,{
            sn(nil,fmta([[ \prod_{<>}^{<>}<> ]], { d(1, get_visual),i(2, "\\infty"), i(0) })),
            sn(nil,fmta([[ \prod<> ]], { i(1) })),
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

s({trig = "sd", condition = in_mathzone, snippetType = "autosnippet"},
  fmta("_{\\mathrm{<>}}",
    { d(1, get_visual) }
  )
),

s({trig = "int", snippetType = "autosnippet", condition = in_mathzone },
    fmta([[<>]],
        { c(1,{
            sn(nil,fmta([[ \int_{<>}^{<>} ]],{i(1),i(2)})),
            t("\\int_{-\\infty}^\\infty"),
            }) }
    )),

s({trig = "([%sbBpvV])Mat(%d+)x(%d+)", snippetType = "autosnippet", regTrig = true, wordTrig = false, desc = "[bBpvV]matrix of A x B size"},
    fmta([[
    \begin{<>}
    <>
    \end{<>}
    ]],
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
        if  snip.captures[1] ==" " then
            return "matrix"
        else
            return snip.captures[1] .. "matrix"
        end
    end)
    }),
    { show_condition = in_mathzone }
),

s({ trig = "@p", snippetType = "autosnippet" }, t("\\partial"), { condition = in_mathzone }),
s({ trig = "dot", snippetType = "autosnippet", condition = in_mathzone }, { t("\\cdot") }),
s({ trig = "oplus", snippetType = "autosnippet", condition = in_mathzone }, { t("\\oplus") }),
s({ trig = "odot", snippetType = "autosnippet", condition = in_mathzone }, { t("\\odot") }),
s({ trig = "otimes", snippetType = "autosnippet", condition = in_mathzone }, { t("\\otimes") }),
s({ trig = "propto", snippetType = "autosnippet", condition = in_mathzone }, { t("\\propto") }),
s({ trig = "!=", snippetType = "autosnippet", condition = in_mathzone }, { t("\\neq") }),
s({ trig = ">>", snippetType = "autosnippet", condition = in_mathzone }, { t("\\gg") }),
s({ trig = "<<", snippetType = "autosnippet", condition = in_mathzone }, { t("\\ll") }),
s({ trig = "~~", snippetType = "autosnippet", condition = in_mathzone }, { t("\\sim") }),
s({ trig = "sim", snippetType = "autosnippet", condition = in_mathzone }, { t("\\sim") }),
s({ trig = "approx", snippetType = "autosnippet", condition = in_mathzone }, { t("\\approx") }),
s({ trig = "max", snippetType = "autosnippet", condition = in_mathzone }, { t("\\max") }),
s({ trig = "min", snippetType = "autosnippet", condition = in_mathzone }, { t("\\min") }),
s({ trig = "mid", snippetType = "autosnippet", condition = in_mathzone }, { t("\\mid") }),
s({ trig = "notin", snippetType = "autosnippet", condition = in_mathzone }, { t("\\not\\in") }),
s({ trig = "<=", snippetType = "autosnippet", condition = in_mathzone }, { t("\\leq") }),
s({ trig = ">=", snippetType = "autosnippet", condition = in_mathzone }, { t("\\geq") }),
s({ trig = "implies", snippetType = "autosnippet", condition = in_mathzone }, { t("\\rightarrow") }),
s({ trig = "to ", snippetType = "autosnippet", condition = in_mathzone }, { t("\\rightarrow") }),
s({ trig = "=>", snippetType = "autosnippet", condition = in_mathzone }, { t("\\Rightarrow") }),
s({ trig = "<->", snippetType = "autosnippet", condition = in_mathzone }, { t("\\leftrightarrow") }),
s({ trig = "<=>", snippetType = "autosnippet", condition = in_mathzone }, { t("\\Leftrightarrow") }),
s({ trig = "**", snippetType = "autosnippet", condition = in_mathzone }, { t("\\cdot") }),
s({ trig = "xx", snippetType = "autosnippet", condition = in_mathzone }, { t("\\times") }),
s({ trig = "+-", snippetType = "autosnippet", condition = in_mathzone }, { t("\\pm") }),
s({ trig = "-+", snippetType = "autosnippet", condition = in_mathzone }, { t("\\mp") }),
s({ trig = "ooo", snippetType = "autosnippet", condition = in_mathzone }, { t("\\infty") }),
s({ trig = "exp", snippetType = "autosnippet", condition = in_mathzone }, { t("\\exp") }),
s({ trig = "and", snippetType = "autosnippet", condition = in_mathzone }, { t("\\cap") }),
s({ trig = "or", snippetType = "autosnippet", condition = in_mathzone }, { t("\\cup") }),
s({ trig = "inn", snippetType = "autosnippet", condition = in_mathzone }, { t("\\in") }),
s({ trig = "ll", snippetType = "autosnippet", condition = in_mathzone }, { t("\\ell") }),
s({ trig = "dif", snippetType = "autosnippet", condition = in_mathzone }, { t("\\textrm{d}") }),
s({ trig = "AA", snippetType = "autosnippet", condition = in_mathzone }, { t("\\forall") }),
s({ trig = "EE", snippetType = "autosnippet", condition = in_mathzone }, { t("\\exists") }),
s({ trig = "log", snippetType = "autosnippet", condition = in_mathzone }, { t("\\log") }),
s({ trig = "ln", snippetType = "autosnippet", condition = in_mathzone }, { t("\\ln") }),
s({ trig = "quad", snippetType = "autosnippet", condition = in_mathzone }, { t("\\quad") }),
s({ trig = "qquad", snippetType = "autosnippet", condition = in_mathzone }, { t("\\qquad") }),
s({ trig = "empty", snippetType = "autosnippet", condition = in_mathzone }, { t("\\emptyset") }),


-- TRIGONOMETRY

s({trig = "cos", snippetType = "autosnippet", condition = in_mathzone}, {
		c(1, { t("\\cos"), t("\\cosh"), })
 }),

s({trig = "sin", snippetType = "autosnippet", condition = in_mathzone}, {
		c(1, { t("\\sin"), t("\\sinh"), })
 }),

s({trig = "tan", snippetType = "autosnippet", condition = in_mathzone}, {
		c(1, { t("\\tan"), t("\\tanh"), })
 }),

s({trig = "csc", snippetType = "autosnippet", condition = in_mathzone}, {
		c(1, { t("\\csc"), t("\\csch"), })
 }),

s({trig = "sec", snippetType = "autosnippet", condition = in_mathzone}, {
		c(1, { t("\\sec"), t("\\sech"), })
 }),

s({trig = "cot", snippetType = "autosnippet", condition = in_mathzone}, {
		c(1, { t("\\cot"), t("\\coth"), })
 }),

s({ trig = "arccos", snippetType = "autosnippet", condition = in_mathzone }, { t("\\arccos") }),
s({ trig = "arcsin", snippetType = "autosnippet", condition = in_mathzone }, { t("\\arcsin") }),
s({ trig = "arctan", snippetType = "autosnippet", condition = in_mathzone }, { t("\\arctan") }),
s({ trig = "arccsc", snippetType = "autosnippet", condition = in_mathzone }, { t("\\arccsc") }),
s({ trig = "arcsec", snippetType = "autosnippet", condition = in_mathzone }, { t("\\arcsec") }),
s({ trig = "arccot", snippetType = "autosnippet", condition = in_mathzone }, { t("\\arccot") }),

s({ trig = "arcosh", snippetType = "autosnippet", condition = in_mathzone }, { t("\\arcosh") }),
s({ trig = "arsinh", snippetType = "autosnippet", condition = in_mathzone }, { t("\\arsinh") }),
s({ trig = "artanh", snippetType = "autosnippet", condition = in_mathzone }, { t("\\artanh") }),
s({ trig = "arcsch", snippetType = "autosnippet", condition = in_mathzone }, { t("\\arcsch") }),
s({ trig = "arsech", snippetType = "autosnippet", condition = in_mathzone }, { t("\\arsech") }),
s({ trig = "arcoth", snippetType = "autosnippet", condition = in_mathzone }, { t("\\arcoth") }),

s({trig = "...", snippetType = "autosnippet", condition = in_mathzone}, {
		c(1, {
			t("\\dots"),
			t("\\cdots"),
			t("\\vdots"),
			t("\\ddots"),
		})
 }),

s({trig = "undb", snippetType = "autosnippet", condition = in_mathzone},
   fmta("\\underbrace{<>}_{<>}",
   { d(1, get_visual), i(2) })),

s({ trig = "lr", wordTrig = false },
   fmta("\\left( <> \\right)<>",
   { d(1, get_visual), i(0), }),
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
s({trig = "([%w%)%]%}|])__", wordTrig = false, regTrig = true, snippetType = "autosnippet",},
  fmta("<>_{<>}", {
    f(function(_, snip)
      return snip.captures[1]
    end),
    d(1, get_visual),
  }),
  { condition = in_mathzone }),

-- SUBSCRIPT con índices
-- s({ trig = "([%w%)%]%}|])_([ijknmtvd])", wordTrig = false, desc = "subscript", regTrig = true, snippetType = "autosnippet", },
--   fmta("<>_{<> <>}<>", {
--     f(function(_, snip)
--       return snip.captures[1]
--     end),
--     f(function(_, snip)
--       return snip.captures[2]
--     end),
--     i(1),
--     i(0),
--   }),
--   { condition = in_mathzone }
-- ),

  -- SUBSCRIPT con números
  s({ trig = "([%a])(%d+)", wordTrig = false, regTrig = true },
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
  s({ trig = "([%w%)%]%}|])td", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
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
      d(1, get_visual),
    }),
    { condition = in_mathzone }
  ),

  s({ trig = "bar", wordTrig = false, snippetType = "autosnippet" },
    fmta([[\overline{<>}]], {
      d(1, get_visual),
    }),
    { condition = in_mathzone }
  ),

  s({ trig = "tild", wordTrig = false, snippetType = "autosnippet" },
    fmta([[\widetilde{<>}]], {
      d(1, get_visual),
    }),
    { condition = in_mathzone }
  ),


  s({ trig = "bb", snippetType = "autosnippet" },
    fmta([[\mathbb{<>}<>]], {
      d(1, get_visual),
      i(0),
    }),
    { condition = in_mathzone }
  ),
  s({ trig = "cal", snippetType = "autosnippet" },
    fmta([[\mathcal{<>}<>]], {
      d(1, get_visual),
      i(0),
    }),
    { condition = in_mathzone }
  ),
  s({ trig = "scr", snippetType = "autosnippet" },
    fmta([[\mathscr{<>}<>]], {
      d(1, get_visual),
      i(0),
    }),
    { condition = in_mathzone }
  ),
  s({ trig = "msf", snippetType = "autosnippet" },
    fmta([[\mathsf{<>}<>]], {
      d(1, get_visual),
      i(0),
    }),
    { condition = in_mathzone }
  ),

s({trig = "mfra", snippetType = "autosnippet", condition = in_mathzone},
   fmta([[\mathfrack{<>}<>]],
   { d(1, get_visual), i(0) })),

s({trig = "bra", condition = in_mathzone}, fmta("\\left\\langle <> \\right\\rvert", { i(1) }) ),
s({trig = "ket", condition = in_mathzone}, fmta("\\left\\lvert <> \\right\\rangle", { i(1) }) ),
s({trig = "braket", condition = in_mathzone},
  fmta("\\left\\lvert <> \\middle| <>  \\right\\rangle",
  { i(1), i(2), })),

}
