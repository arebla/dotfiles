-- File: ~/.config/nvim/lua/snippets/typst/math.lua

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

s({trig = "([^%a])mk", wordTrig = false, regTrig = true, snippetType = "autosnippet"},
  fmta(
    [[<>$<>$]],
    { f( function(_, snip) return snip.captures[1] end ),
      d(1, get_visual) }
  )),

s({trig = "dm", snippetType = "autosnippet"},
  fmta(
    [[
      $
          <>
      $
    ]],
    {  d(1, get_visual) }
  )),

s({trig = "([^%a])fr", regTrig = true, wordTrig = true, condition = in_mathzone, snippetType = "autosnippet" },
  fmta(
    [[<>frac(<>, <>)]],
    { f( function(_, snip) return snip.captures[1] end ),
      d(1, get_visual), i(2) }
  )),

s({trig = "sq", regTrig = true, wordTrig = false, condition = in_mathzone, snippetType = "autosnippet"},
  fmta(
    [[sqrt(<>)]],
    { d(1, get_visual) }
  )),

--s({trig = "([^%a])sum", wordTrig = false, regTrig = true, condition = in_mathzone, snippetType = "autosnippet" },
--  fmta(
--    [[<>sum_(<>)^(<>)]],
--    { f( function(_, snip) return snip.captures[1] end ),
--      i(1), i(2) }
--  )),
--s({trig = "sum", wordTrig = false, regTrig = true, condition = in_mathzone, snippetType = "autosnippet" },
--  fmta(
--    [[sum_(<>)^(<>)<>]],
--    { d(1, get_visual) ,
--      i(2), i(0) }
--  )),

s({ trig = "sum", snippetType = "autosnippet", wordTrig = false, regTrig = true, condition = in_mathzone},
    fmta([[<>]],
        { c(1,{
            sn(nil,fmta([[ sum<> ]], { i(1) })),
            sn(nil,fmta([[ sum_(<>)^(<>)<> ]], { d(1, get_visual),i(2), i(0) })),
            }) }
    )),

-- SUBSCRIPT
s({
    trig = "([%w%)%]%}|])jj",
    desc = "Subscript(no ambiguity)",
    wordTrig = false,
    regTrig = true,
    snippetType = "autosnippet",
  },
  fmta("<>_(<>)", {
    f(function(_, snip)
      return snip.captures[1]
    end),
    d(1, get_visual),
  }),
  { condition = in_mathzone }),
s(
  {
    trig = "([%w%)%]%}|])j([ijknmtvd])",
    wordTrig = false,
    desc = "subscript",
    regTrig = true,
    snippetType = "autosnippet",
  },
  fmta("<>_(<>)<>", {
    f(function(_, snip)
      return snip.captures[1]
    end),
    f(function(_, snip)
      return snip.captures[2]
    end),
    i(0),
  }),
  { condition = in_mathzone }
),
  s(
    { trig = "([%w%)%]%}|])j(%d+)", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>_(<>)<>", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
      i(0),
    }),
    { condition = in_mathzone }
  ),
  s(
    {
      trig = "([%w%)%]%}|])J",
      desc = "Subscript(no ambiguity)",
      wordTrig = false,
      regTrig = true,
      snippetType = "autosnippet",
    },
    fmta("<>_(<>)", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = in_mathzone }
  ),

-- Superscript
  s(
    { trig = "([%w%)%]%}|])kk", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>^(<>)", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "([%w%)%]%}|])k(%d+)", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>^(<>)<>", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
      i(0),
    }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "([%w%)%]%}|])k([ijknmtvd])", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>^(<>)<>", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
      i(0),
    }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "([%w%)%]%}|])K", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("<>^(<>)", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = in_mathzone }
  ),
  -- INVERSE
  s(
    { trig = "([%w%)%]%}])inv", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta([[<>^(-1)<>]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(0),
    }),
    { condition = in_mathzone }
  ),

  -- DAGGER
  s({ trig = "([%w%)%]%}])dagger", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta([[<>^(dagger)<>]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(0),
    }),
    { condition = in_mathzone }
  ),
  s({ trig = "int", wordTrig = false, snippetType = "autosnippet" },
    fmta("integral_(<>)^(<>)<>", {
      d(1, get_visual),
      i(2),
      i(0),
    }),
    { condition = in_mathzone }
  ),

  s({ trig = "und", snippetType = "autosnippet" },
    fmta([[underbrace(<>, "<>")]], {
      d(1, get_visual),
      i(2),
    }),
    { condition = in_mathzone }
  ),

  s({ trig = "implies", snippetType = "autosnippet" }, t("==>"), { condition = in_mathzone }),
  s({ trig = "neq", snippetType = "autosnippet" }, t("!="), { condition = in_mathzone }),
  s({ trig = "leq", snippetType = "autosnippet" }, t("<="), { condition = in_mathzone }),
  s({ trig = "geq", snippetType = "autosnippet" }, t(">="), { condition = in_mathzone }),
  s({ trig = "to ", snippetType = "autosnippet" }, t("-> "), { condition = in_mathzone }),
  s({ trig = "**", snippetType = "autosnippet" }, t("dot "), { condition = in_mathzone }),


  s({ trig = "|([^%s][^|]*)|", regTrig = true, snippetType = "autosnippet" },
    fmta("abs(<>)<>", { f(function(_, snip)
      return snip.captures[1]
    end), i(0) }),
    { condition = in_mathzone }
  ),
   s({ trig = "lrd", wordTrig = false, snippetType = "autosnippet" },
    fmta("lr(( <> ))<>", {
      iv(1),
      i(0),
    }),
    { condition = in_mathzone }
  ),
  s({ trig = "lrb", wordTrig = false, snippetType = "autosnippet" },
    fmta("lr({ <> })<>", {
      iv(1),
      i(0),
    }),
    { condition = in_mathzone }
  ),
  s({ trig = "lrs", wordTrig = false, snippetType = "autosnippet" },
    fmta("lr([ <> ])<>", {
      iv(1),
      i(0),
    }),
    { condition = in_mathzone }
  ),
  s({ trig = "lrc", wordTrig = false, snippetType = "autosnippet" },
    fmta("lr(| <> |)<>", {
      iv(1),
      i(0),
    }),
    { condition = in_mathzone }
  ),
  s({ trig = "lra", wordTrig = false, snippetType = "autosnippet" },
    fmta("chevron.l <> chevron.r<>", {
      iv(1),
      i(0),
    }),
    { condition = in_mathzone }
  ),

  --- Accents - Tilde
  s({ trig = "tild", wordTrig = false, snippetType = "autosnippet" },
    fmta([[tilde(<>)]], {
      i(1),
    }),
    { condition = in_mathzone }
  ),
  --- Accents - hat
  s({ trig = "hat", wordTrig = false, snippetType = "autosnippet" },
    fmta([[hat(<>)]], {
      i(1),
    }),
    { condition = in_mathzone }
  ),

  s({ trig = "mc", wordTrig = false, snippetType = "autosnippet" },
    fmta([[cal(<>)<>]], {
      d(1, get_visual),
      i(0),
    }),
    { condition = in_mathzone }
  ),
  s({ trig = "mcal", wordTrig = false, snippetType = "autosnippet" },
    fmta([[cal(<>)<>]], {
      d(1, get_visual),
      i(0),
    }),
    { condition = in_mathzone }
  ),
  s({ trig = "cal", wordTrig = false, snippetType = "autosnippet" },
    fmta([[cal(<>)<>]], {
      d(1, get_visual),
      i(0),
    }),
    { condition = in_mathzone }
  ),
  s({ trig = "mbb", wordTrig = false, snippetType = "autosnippet" },
    fmta([[bb(<>)<>]], {
      d(1, get_visual),
      i(0),
    }),
    { condition = in_mathzone }
  ),

  s({ trig = "(%d?)cases", regTrig = true, snippetType = "autosnippet" },
    fmta(
      [[
cases(
<>
)<>]],
      { i(1), i(0) }
    ),
    { condition = in_mathzone }
  ),

s({ trig = "@p", snippetType = "autosnippet" }, t("partial"), { condition = in_mathzone }),


-- Reasoning and Planning
  s({ trig = "entail", wordTrig = false, condition = in_mathzone, snippetType = "autosnippet" },
    {t("tack.r.double"),}),

}
