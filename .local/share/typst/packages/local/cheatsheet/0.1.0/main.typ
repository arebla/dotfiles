// $HOME/.local/share/typst/packages/local/cheatsheet/0.1.0

#let header_title(title, author, num_columns, accent) = {
 columns(num_columns)[
  #block(
    width: 100%,
    inset: 0.5em, outset: 0.3mm,
    stroke: 0.5pt + black, fill: accent.transparentize(90%))[
  #grid(
    columns: (1.2fr, 0.8fr),
    align(left)[
    *#title* \ #v(-7.5pt)
    Page #context[#counter(page).display("1 of 1", both: true)]\
    ],
    align(right)[
    #author \ #v(-7.5pt)
    #datetime.today().display("v.[year][month][day]")]
  )]
  #colbreak()
  ]
}

#let cheatsheet(
  title: none,
  author: "Andrea",
  num_columns: 1,
  accent: green,
  body,
) = {

  set page(
    paper: "a4",
    flipped: true,
    margin: (top: 15mm, bottom: 2mm, right: 3mm, left: 3mm),
    columns: num_columns,
    numbering: "1 of 1",
    header: [#header_title(title, author, num_columns, accent)],
    header-ascent: 7pt,
    footer: []
  )
  set columns(gutter: 20pt)
  set text(font: "CMU Bright", size: 9pt)
  set heading(numbering: "1.1")
  set par(justify: true, spacing: 1em)
  set list(marker:
   (box(height: 0.65em, align(horizon, text(size: 0.8em)[•])),
   [--],
   [◉],
   box(height: 0.65em, align(horizon, text(size: 0.8em)[⦾])),
   [‣])
  )

  show heading: box
  show heading: set text(accent.darken(30%))
  show heading.where(level: 1): set text(size: 11pt)
  show heading.where(level: 2): set text(size: 10pt)

  // Display inline code in a small box
  // that retains the correct baseline
  show raw.where(block: false): box.with(
    fill: luma(240),
//    inset: (x: 2pt, y: 0pt),
//    outset: (y: 3pt),
//    radius: 2pt,
  )

  // Display block code in a larger block
  // with more padding
  let code_block(it) = {
    set text(1em / 0.8) // https://github.com/typst/typst/issues/1331
    block(
      fill: luma(240),
 //     inset: (10pt),
      // Use the raw content directly to prevent the original
      // raw block's properties from interfering.
      raw(it.text, lang: it.lang, block: false)
    )
  }

  show raw.where(block: true): it => code_block(it)


  body
}

// Same cal font as in LaTeX
#let cal(it) = math.class("normal", box({
  show math.equation: set text(font: "Garamond-Math", stylistic-set: 3)
  $#math.cal(it)$
}) + h(0pt))


// -------------------------------------------------------------
// IMPORTANT: This stuff gets overwritten, better put it outside
// -------------------------------------------------------------
