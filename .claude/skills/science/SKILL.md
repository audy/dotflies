# Science

LLM-assisted data analysis

## Stack

Polars, Altair, Quarto Notebooks (`.qmd`) files

## Coding Conventions

1. Heavy number crunching for notebooks should be cached/memoized so that the
   notebook can be iterated upon quickly
2. Use a fresh Python environment and `pyproject.toml` per project, use the
   most-recent Python version
3. If you're in `~/Code/lab-notebook/YYYY-mm-dd-some-notebook`, then
   `some-notebook` should be its own git repo and project working directory

## Layout

1. Introduction: the question that the notebook seeks to answer
2. Materials and Methods including a list or table of data source(s)
3. Results

## General

1. Content SHOULD NOT contain any conslusions or interpretation
2. Content SHOULD ALWAYS include materials and methodology information with
   enough detail that someone should be able to reproduce an analysis by
   reading the text
3. ONLY use specified data sources and ALWAYS confirm before including data
   from any other sources

## Figures/Tables

1. Figures and tables should be numbered sequentially
2. Every figure and table should include a summary that defines how the axes
   were calculated (with formulas!) and the source of the data
3. tables should ONLY be included when they directly relate to the question being asked

## Light/Dark Mode

Notebooks follow the OS colour scheme live (no refresh), including Altair
charts. Start new notebooks from `templates/notebook.qmd` and copy
`templates/adaptive.css` next to it. How it works:

1. Quarto front matter: `theme: {light: flatly, dark: darkly}` plus
   `respect-user-color-scheme: true`. Quarto's own JS listens for
   `prefers-color-scheme` changes and swaps the stylesheet.
2. Altair: render as SVG and use `currentColor` for all text, axis, grid, and
   tick colours (see the `adaptive` theme in the template). SVG presentation
   attributes resolve through CSS, so the charts inherit the page text colour.
   Data marks keep their palette; pick colours that read on both backgrounds.
3. `adaptive.css` darkens the Vega tooltip/action menu and hides Quarto's
   manual toggle (clicking it pins the scheme in localStorage).
