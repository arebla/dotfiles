-- File: ~/.config/nvim/lua/snippets/typst/templates.lua

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

s({ trig = "today", dscr = "Insert today's date" },
  f(function()
    return os.date("%Y-%m-%d")  -- format: 2025-09-29
  end, {})
),

s({ trig = "cs", desc = "Cheatsheet template" },
  fmta(
    [[
      // "$HOME/.local/share/typst/packages/local/cheatsheet/0.1.0/main.typ"
      // "$HOME/.local/share/typst/packages/local/common/0.1.0/macros.typ"

      #import "@local/common:0.1.0": *
      #import "@local/cheatsheet:0.1.0": *

      #show: cheatsheet.with(
        title: "<>",
        author: "<>",
        num_columns: <>,
        accent: navy,
      )
      <>
    ]],
    { i(1, "Title"), i(2, "Andrea"), i(3, "3"), i(0) }
  )),

s({ trig = "report", desc = "Report template" },
  fmta(
    [[
      // "$HOME/.local/share/typst/packages/local/report/0.1.0/main.typ"
      // "$HOME/.local/share/typst/packages/local/common/0.1.0/macros.typ"

      #import "@local/common:0.1.0": *
      #import "@local/report:0.1.0": *

      #show: report.with(
        title: "<>",
        course: "<>",
        authors: ("<>": ("email": "<>")),
        abstract: "<>"
      )
      <>
    ]],
    { i(1, "Title"), i(2, "Course name"), i(3, "Andrea"), i(4, ""), i(5), i(0) }
  )),
}
