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

s({trig = "([^%a])mk", wordTrig = false, regTrig = true, snippetType = "autosnippet"},
  fmta(
    "<>\\(<>\\)",
    { f( function(_, snip) return snip.captures[1] end ),
      d(1, get_visual) }
  )),

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
    { f( function(_, snip) return snip.captures[1] end ),
      i(1), i(2) }
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

s({trig = ";I", snippetType = "autosnippet", desc = "integral with infinite or inserted limits", wordTrig=false},
    fmta([[<>]],
        { c(1,{
            t("\\int_{-\\infty}^\\infty"),
            sn(nil,fmta([[ \int_{<>}^{<>} ]],{i(1),i(2)})),
            }) }
    )),

s({trig=";a", snippetType="autosnippet"},
  { t("\\alpha"), }
),
s({trig=";b", snippetType="autosnippet"},
  { t("\\beta"), }
),
s({trig=";g", snippetType="autosnippet"},
  { t("\\gamma"), }
),

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

}
