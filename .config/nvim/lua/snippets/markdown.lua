-- File: ~/.config/nvim/lua/snippets/markdown.lua

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

    s({ trig = "itt", snippetType = "autosnippet" },
      fmta(
        "_<>_",
        { d(1, get_visual) }
      )),
    s({ trig = "bf", snippetType = "autosnippet" },
      fmta(
        "**<>**",
        { d(1, get_visual) }
      )),
    s({ trig = "kk", snippetType = "autosnippet" },
      fmta(
        "~~<>~~",
        { d(1, get_visual) }
      )),
    s({trig="tt" },
      fmta(
        "`<>`",
        { d(1, get_visual) }
      )),
    s({trig = "h1", condition = line_begin },
      { t("# "), }
      ),
    s({trig = "h2", condition = line_begin },
      { t("## "), }
      ),
    s({trig = "h3", condition = line_begin },
      { t("### "), }
      ),
}
