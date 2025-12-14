#import "slides_utils.typ": *

// Default configuration constants
// Comand line command to list fonts: typst fonts
// Recomended dyslectic friendly fonts: OpenDyslexic, Comic Sans MS
#let default-header-font-size = 23pt
#let default-content-font-size = 21pt
#let default-main-font = "Calibri"
#let default-code-font = "Consolas"
#let default-focusbox-font-size = 1em
#let default-table-font-size = 1em
// State variables to pass configuration from slides() to slide() function
// To list available system fonts, use the command: typst fonts
#let header-font-size-state = state("header-font-size", default-header-font-size)
#let main-font-state = state("main-font", default-main-font)
#let code-font-state = state("code-font", default-code-font)
#let equation-numbering-state = state("equation-numbering", "(1)")
#let reset-equation-state = state("reset-equation", false)
#let footer-text-state = state("footer-text", "")
#let focusbox-font-size-state = state("focusbox-font-size", default-focusbox-font-size)
#let table-font-size-state = state("table-font-size", default-table-font-size)

// Main configuration function for presentations
#let slides(
  ratio: "16-9",
  // The font family for the entire presentation. Can be controlled per slide too.
  main-font: default-main-font,
  code-font: default-code-font,
  // The font sizes for all elements can be customized in each slide using em-units
  font-size-headers: default-header-font-size, // Default header font size that also affects slide header height
  font-size-content: default-content-font-size, // Default content font size. 
  focusbox-font-size: default-focusbox-font-size, // Default focusbox font size
  table-font-size: default-table-font-size, // Default table font size
  footer_text: "", // Text to show in the footer. Empty by default.
  reset_equation_numbers_per_slide: true, // Reset equation numbering on each slide
  equation_numbering_globally: true, // Enable automatic equation numbering that starts on 1. Set to false to disable.
  body,
) = {
  header-font-size-state.update(font-size-headers)
  main-font-state.update(main-font)
  code-font-state.update(code-font)
  focusbox-font-size-state.update(focusbox-font-size)
  table-font-size-state.update(table-font-size)
  reset-equation-state.update(reset_equation_numbers_per_slide)
  footer-text-state.update(footer_text)
  let numbering_format = if equation_numbering_globally { "(1)" } else { none }
  equation-numbering-state.update(numbering_format)
  set text(font: main-font, size: font-size-content)
  set page(paper: "presentation-" + ratio, fill: white)
  set math.equation(numbering: numbering_format)
  body
}

// Slide with colored header
#let slide(
  headercolor: blue,
  title: none,
  center_x: false,
  center_y: true,
  slide-main-font: none,
  slide-main-font-size: none,
  slide-code-font: none,
  slide-code-font-size: none,
  slide-equation-numbering: auto, // Set to true/false to override global equation numbering for this slide
  body,
) = context {
  // Calculate dynamic top margin based on header size
  let header-size = header-font-size-state.get()
  let header-height = if title != none { 1.6em } else { 1.5em }
  // Convert em to absolute units by measuring at the header font size
  let header-height-absolute = measure(text(size: header-size)[#v(header-height)]).height
  let top-margin = if title != none {
    header-height-absolute + 0.5cm
  } else {
    1.75cm
  }
  
  set page(
    fill: white,
    header-ascent: if title != none { 65% } else { 66% },
    header: [],
    margin: (x: 1.6cm, top: top-margin, bottom: 1.2cm),
    background: context {
      place(slide-header(title, headercolor, header-font-size-state.get()))
    },
    footer: context [
      #set text(size: 12pt, fill: gray)
      #grid(
        columns: (1fr, 1fr),
        align: (left + horizon, right + horizon),
        footer-text-state.get(),
        counter(page).display("1 / 1", both: true)
      )
    ],
  )

  set par(justify: true)

  // Apply slide-specific font settings
  context {
    let x_align = if center_x { center } else { left }
    let y_align = if center_y { horizon } else { top }

    let font = if slide-main-font != none { slide-main-font } else { main-font-state.get() }
    let size = if slide-main-font-size != none { slide-main-font-size } else { text.size }
    let code-font-val = if slide-code-font != none { slide-code-font } else { code-font-state.get() }
    let code-size = slide-code-font-size
    
    // Determine equation numbering for this slide
    let eq-numbering = if slide-equation-numbering == auto {
      equation-numbering-state.get()
    } else if slide-equation-numbering {
      "(1)"
    } else {
      none
    }
    
    set text(font: font, size: size)
    set math.equation(numbering: eq-numbering)
    set align(x_align + y_align)
    // Math equations always use Typst's default math font
    show raw: set text(font: code-font-val, size: if code-size != none { code-size } else { size })

    // Reset equation numbering for each slide
    if reset-equation-state.get() == true {
      counter(math.equation).update(0)
    }

    v(0cm)
    body
  }
}
