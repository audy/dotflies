# Science

LLM-assisted data analysis.

## Stack

Polars, Altair, and Quarto notebooks (`.qmd`).

## Coding Conventions

1. Cache or memoize heavy number crunching so the notebook can be iterated on
   quickly.
2. Use a fresh Python environment and `pyproject.toml` per project, on the
   most recent Python version.
3. If working in `~/Code/lab-notebook/YYYY-mm-dd-some-notebook`, then
   `some-notebook` is its own git repo and project working directory.

## Layout

1. Introduction: the question the notebook seeks to answer
2. Materials and Methods: including a list or table of data source(s)
3. Results

## General

1. Content SHOULD NOT contain conclusions or interpretation.
2. Content SHOULD ALWAYS include materials and methods in enough detail that
   someone could reproduce the analysis from the text alone.
3. ONLY use the specified data sources, and ALWAYS confirm before including
   data from any other source.

## Figures and Tables

1. Number figures and tables sequentially.
2. Every figure and table includes a summary that defines how the axes were
   calculated (with formulas!) and the source of the data.
3. Captions ALWAYS define any special terms, acronyms, etc. that they
   reference.
4. Data tables are ONLY included when they directly relate to the question
   being asked. Tables describing inputs or methods in the Materials and
   Methods section are fine.

## Light/Dark Mode

Notebooks follow the OS colour scheme live (no refresh), including Altair
charts. Start new notebooks from `templates/notebook.qmd` and copy
`templates/adaptive.css` next to it. How it works:

1. Quarto front matter: `theme: {light: flatly, dark: darkly}` plus
   `respect-user-color-scheme: true`. Quarto's own JS listens for
   `prefers-color-scheme` changes and swaps the stylesheet.
2. Altair: render as SVG and use `currentColor` for all text, axis, grid, and
   tick colours (see the `adaptive` theme in the template). SVG presentation
   attributes resolve through CSS, so charts inherit the page text colour.
   Data marks keep their palette; pick colours that read on both backgrounds.
3. `adaptive.css` darkens the Vega tooltip/action menu and hides Quarto's
   manual toggle (clicking it pins the scheme in localStorage).
