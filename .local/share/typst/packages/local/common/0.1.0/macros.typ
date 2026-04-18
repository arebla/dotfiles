// $HOME/.local/share/typst/packages/local/cheatsheet/0.1.0

// Source: https://github.com/Jollywatt/notes
#let env(kind, body, accent: green) = {
//	figure(
//		supplement: kind,
		block(width: 100%, inset: 0.8em, stroke: 0.5pt + black, fill: accent.transparentize(80%))[
			#set align(left)
			*#kind.* #body
		] //,
//	)
}

#let genenv(body) = {
  block(width: 100%, inset: 0.8em, stroke: 0.5pt + black)[
    #set align(left)
    #body
  ]
}

#let recall = env.with(accent: teal.saturate(-20%))[Recall]
#let questions = env.with(accent: teal.saturate(-20%))[Questions]
#let define = env.with(accent: green.saturate(-50%))[Define]
#let result = env.with(accent: yellow.saturate(-20%))[Result]
#let comment = env.with(accent: purple.saturate(-80%))[Comment]
#let theorem = env.with(accent: red.saturate(-50%))[Theorem]
#let example = env.with(accent: purple.lighten(70%))[Example]



#let warning = env.with(accent: white)[Warning]
#let note = env.with(accent: red.saturate(-50%))[Note]

// Lecture date macro
#let lecture_date(date) = {
  h(1fr)
  highlight(
    fill: blue.saturate(-90%),
    extent: 3pt,
    radius: 2pt
  )[Lecture #date]
}

// Some colors:
// - #FFECB3 //rgb("FFECB3")
// - #E0F2F1
