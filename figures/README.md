# Figures

Diagrams and images for the chapter notes, organized by chapter.

```
figures/
├── ch1/
├── ch2/
│   └── example2-circuit.svg
├── ch3/
├── ch4/
├── ch5/
├── ch6/
└── ch7/
```

## How to use a figure in a chapter

Save the image here (SVG preferred — crisp at any zoom; PNG/JPG also fine),
then reference it from the chapter `.md` file with a relative path.

A chapter file lives in `chapters/`, so it reaches this folder with `../figures/...`:

```markdown
![Example 2 — reduced circuit](../figures/ch2/example2-circuit.svg)
```

To center it and add a caption, wrap it in HTML:

```html
<p align="center">
  <img src="../figures/ch2/example2-circuit.svg" alt="Example 2 circuit" width="560">
</p>
<p align="center"><em>The circuit after reduction — Loop 1 gives I<sub>out</sub>, Loop 2 gives V<sub>out</sub>.</em></p>
```

## Why files instead of inline SVG?

A `.svg` file shows up **everywhere** — the published site, the GitHub repo
preview, and the VS Code editor preview. Inline `<svg>` pasted into markdown
only renders on the published site (GitHub and editors strip it for security).

## Naming

Use lowercase, hyphenated, descriptive names tied to where they're used:
`example2-circuit.svg`, `rc-step-response.svg`, `opamp-inverting.svg`.
