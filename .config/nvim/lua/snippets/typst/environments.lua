-- File: ~/.config/nvim/lua/snippets/typst/environments.lua

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

local iv = function(i, ...)
  return d(i, get_visual, ...)
end

return {
  s({ trig = "toc", snippetType = "autosnippet" }, t("#outline()"), { condition = line_begin }),

  s({ trig = "cent" },
  	fmta("#align(center)[<>]", { i(1) })
  ),

  s({ trig = "mla" },
    fmta([[
      #set page(header: context align(right)[Page #counter(page).get().first()])

      Name

      #datetime.today().display("[day] [month repr:long] [year]")
      <>

      <>
    ]], { i(1), i(2) }
  )),

  s({ trig = "fig" },
    fmt([[
         #figure(
           //placement: auto,
           image("fig/^!", width: 85%),
           caption: [^!],
         )<fig:^!>
         ]],
         { i(1), i(2), i(3) },
         { delimiters = "^!" }
  )),

  s({ trig = "csv" },
    fmt([[
         #show table.cell.where(y: 0): set text(weight: "bold")
         #show figure: set block(breakable: true)
         #let results = csv("^!")
         #{
           show table.cell: set text(size: 10pt)
         figure(
           table(
           columns: (^!) ,
           ..results.flatten()
         ),
         caption: [^!],
         )<tab:^!>
         }
        ]],
        { i(1), i(2), i(3), i(4) },
        { delimiters = "^!" }
  )),

  s({ trig = "listing" },
    fmta(
      [[
       #align(center)[
       ```
       <>
       ```
       ]
      ]],
    { i(0) }
  )),
}
