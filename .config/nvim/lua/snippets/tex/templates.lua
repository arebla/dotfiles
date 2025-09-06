-- File: ~/.config/nvim/lua/snippets/tex/templates.lua

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
s({ trig = "pac", snippetType = "autosnippet", wordTrig = false, condition = line_begin },
    fmta([[<>]],
        { c(1,{
            sn(nil,fmta([[ \usepackage{<>} ]], { i(1, "package") })),
            sn(nil,fmta([[ \usepackage[<>]{<>} ]], { i(2, "options"),i(1, "package") })),
            }) }
    )),

s({ trig = "notes", desc = "Notes template" },
  fmt(
    [[
      \documentclass[a4paper, 11pt, parskip=half-]{scrartcl}

      \usepackage[notes]{arebla}

      \lhead{\sffamily{<>}}
      \date{\normalsize{<>}}
      \title{<>}
      \author{\normalsize\textsc{{<>}}}

      \begin{document}
          \pagenumbering{roman}
          \maketitle
          \begin{abstract}

          \end{abstract}
          \clearpage
          \tableofcontents
          \clearpage
          \pagenumbering{arabic}

      <>
      \end{document}
    ]],
    { i(1, "author"), i(2, "date"), i(3, "title"), rep(1), i(0) },
    { delimiters="<>" }
  )),

s({ trig = "cs", desc = "Cheatsheet template" },
  fmta(
    [[
      \documentclass[10pt, a4paper, landscape]{scrartcl}
      \usepackage[cs]{arebla}
      \definecolor{cscolor}{HTML}{583c6e}
      \newcommand{\lastedited}{\versiondate}
      %\setlength{\columnsep}{0.7cm}

      \begin{document}
      \title{<>}
      \author{\href{mailto:<>}{Andrea Real}}
      \small
      \begin{multicols*}{<>}
      <>

      \vspace*{\fill}\null
      \end{multicols*}
      \end{document}
    ]],
    { i(1, "Title"), i(2, "Email"), i(3, "n of columns"), i(0) }
  )),

s({ trig='pset', dscr='Handout template' },
  fmta(
    [[
      \documentclass[11pt, parskip=half-]{scrartcl}
      \usepackage[pset,arch]{arebla}

      \begin{document}
      \title{<>}
      \author{\textsc{Andrea Real}}
      \date{<>}
      \maketitle
      \pagenumbering{arabic}
      <>
      \end{document}
    ]],
    { i(1, "Title"), i(2, "\\today"), i(0) }
  )),

s({ trig='lab', dscr='Lab template'},
  fmta(
    [[
      \documentclass[a4paper, 10pt, parskip=half-]{scrartcl}

      \usepackage[lab, es]{arebla}
      \title{\vspace{-4ex}\Large Práctica <> \vspace{1ex}}
      \author{\vspace{-5ex}\small{<>}\\\ \normalsize{Andrea Real}}
      \date{\small <>}

      \begin{document}
      \maketitle
      \vspace*{-1cm}
      \begin{abstract}
      \textit{Resumen}. <>
      \end{abstract}
      \tableofcontents

      \section{Fundamento teórico}
      <>
      \section{Dispositivo experimental}
      \section{Procedimento y resultados}
      \section{Bibliografía}
      \end{document}
    ]],
    { i(1, "Nombre práctica"), i(2, "Correo"), i(3, "\\today"), i(4, "Resumen"), i(0) }
  )),

s({ trig = 'book', dscr = 'Book template'},
  fmta(
    [[
      \documentclass[draft]{book}
      \usepackage[book]{arebla}

      \title{<>}
      \author{Andrea Real}
      \date{<>}
      \begin{document}
      \newpage
         \maketitle
          \renewcommand{\thepage}{\roman{page}}
          \thispagestyle{empty}
          \newpage
          \pagestyle{plain}
          \setcounter{page}{0}
          \input{preface.tex}
          \tableofcontents
          \cleardoublepage %Ensure that the following content starts on a new right-hand (odd-numbered) page.
          \renewcommand{\thepage}{\arabic{page}}
          \setcounter{page}{1}
          \pagestyle{normal}
      <>
      \end{document}
    ]],
  { i(1, "Title"), i(2, "\\today"), i(0)}
  )),

}
