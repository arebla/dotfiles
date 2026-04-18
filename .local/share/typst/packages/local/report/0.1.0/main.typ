// $HOME/.local/share/typst/packages/local/report/0.1.0

// Sources:
// - Alternating heading: https://forum.typst.app/t/how-to-set-headers-and-page-numbers-with-alternating-text-on-even-and-odd-pages/2992
// - Multiple authors: https://github.com/typst/typst/discussions/1504
// - Appendix: https://github.com/typst/typst/discussions/4031

#let report(
  title: none,
  course: none,
  course_code: none,
  program: "Master in Artificial Intelligence",
  academic_year: "Academic Year 2025-2026",
  date: datetime.today().display("[month repr:long] [year]"),
  // Example:
  // (
  //   "Author Name": (
  //     "email": "author.name@example.com",
  //     "affiliation": "affil-1",  // Optional
  //     "address": "Mail address",  // Optional
  //     "name": "Alias Name", // Optional
  //     "cofirst": false // Optional, identify whether this author is the co-first author
  //   )
  // )
  authors: "",
  affiliations: (),
  abstract: "This page aims at being an 'out-of-the-kitchen' device for gossip, ideas, and hopefully lots of fun stuff.",
  body,
) = {

  set page(
    paper: "a4",
    //margin: (top: 15mm, bottom: 2mm, right: 3mm, left: 3mm),
    numbering: "1",
    header: context {
        if here().page() == 1 {
            []
        } else {
            let page = counter(page).get().first()
            let body = if calc.odd(page) [#strong(str(page)) #h(0.5cm) #upper(title)]
            else [#upper(course) #h(0.5cm) #strong(str(page))]
            let alignment = if calc.odd(page) { left } else { right }
            align(alignment, body)
           // [header other pages]
        }},
    footer: none
  )

  set text(font: "CMU Bright", size: 11pt)

  set par(justify: true, leading: 0.52em)
  set heading(numbering: "1.1")
  set enum(indent: 1.5em, spacing: 1em)
  set list(indent: 1.5em)
  show link: set text(rgb(0,51,153))
//  show link: underline
  set list(marker:
   (box(height: 0.65em, align(horizon, text(size: 0.8em)[•])),
   [--],
   [◉],
   box(height: 0.65em, align(horizon, text(size: 0.8em)[⦾])),
   [‣])
  )

  // Display inline code in a small box
  // that retains the correct baseline.
  show raw.where(block: false): box.with(
    fill: luma(240),
    inset: (x: 2pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
  )
  show raw.where(block: true): block.with(
//#show raw: it => block(
  fill: rgb("f4f8ff"),
//  fill: rgb("f1f5f3"),
  width: 100%,
  inset: 8pt,
  radius: 2pt,
  //#text(fill: rgb("#a2aabc"),)
  )
  // Display block code in a larger block
  // with more padding.
//  show raw.where(block: true): block.with(
//    fill: luma(240),
//    inset: 5pt,
//    radius: 2pt,
//  )

  [
  #v(30pt)
  #grid(
    columns: (1fr, 1fr),
    align(left)[
        #image("fig/usc-branco-negro.pdf", width: 55%)
    ],
    align(right)[\
      #program\
      #academic_year\

      #emph(date)
    ],
  )
  #v(50pt)
  #align(left, text(17pt)[
    #text(14pt)[#course (#course_code)] \ #v(0pt)
    *#title*
  ])
  #line(length: 100%, stroke: 0.5pt)
  #v(10pt)

  // Authors' block
  #block([
    // Process the text for each author one by one
    #for (id, au) in authors.keys().enumerate() {
      let au_meta = authors.at(au)
      // Don't put comma before the first author
      if id != 0 {
        text([, ])
        text([\ ])
      }
      // Write author's name
      if au_meta.keys().contains("name") {
        text([#au_meta.name])
      } else {
        text([#au])
      }
      // Corresponding author
      if au_meta.keys().contains("email") and au_meta.email != "" or au_meta.keys().contains("address") {
        footnote(numbering: "1")[
//          Corresponding author. Address:
          #if au_meta.keys().contains("email") {
            [#link("mailto:" + au_meta.email)]
          }
        ]
      }
    }
  ])

  #v(8pt)
  #align(left)[
  #set par(justify: true)
  #abstract
  ]

  ]
  body
}
#let appendix(body) = {
  set heading(numbering: "A", supplement: [Appendix])
  counter(heading).update(0)
  body
}
