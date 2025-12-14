# Typst Slides Template (Education)

A simple, readable slide template for teaching and classroom presentations, built with [Typst](https://typst.app/).

## What this is

- A small Typst “mini framework” for slides: consistent header styles, sensible typography defaults, and a few utilities.
- Intended for education: clear layouts, easy code blocks, and math support.

## Quick start

1. Install Typst.
2. Compile the example deck:

```bash
typst watch main.typ main.pdf
```

Edit the slides in `main.typ` and Typst will recompile on save.

## How to use

In your deck file (see `main.typ`):

- Import the template and configure it:

```typst
#import "slides_core.typ": *

#show: slides.with(
  ratio: "16-9",
  main-font: "Calibri",
  code-font: "Consolas",
  font-size-headers: 20pt,
  font-size-content: 19pt,
  equation_numbering_globally: true,
)
```

- Create slides with `slide(...)`:

```typst
#slide(headercolor: blue, title: "Example")[
  Your content here.
]
```

## Key features

- **Colored header styles** (blue/red/green/cyan/magenta/yellow/gray).
- **Focus boxes** for code, examples, and highlights via `focusbox(...)`.
- **Columns** via `cols(...)`, including fractional layouts like `(2fr, 1fr)`.
- **Equation numbering**
  - Global toggle in `slides.with(equation_numbering_globally: ...)`.
  - Per-slide override using `slide-equation-numbering: true/false`.
  - Optional reset per slide via `reset_equation_numbers_per_slide`.
- **Code block sizing**: `focusbox(text-size: ...)` also affects fenced code blocks.
- **Slide alignment controls**: `center_x` / `center_y` in `slide(...)`.

## Project structure

- `main.typ`: example presentation showcasing features
- `slides_core.typ`: main API (`slides(...)`, `slide(...)`) and state-based configuration
- `slides_utils.typ`: utilities (`focusbox(...)`, `cols(...)`, header color definitions)
- `typst-cmd.txt`: a handy compile command
- `fonts/`: notes about fonts

## Notes

- The template aims to stay **minimal**: a small set of knobs that are useful in real teaching.
- Typst math syntax is used throughout (not LaTeX commands).
