# PGN to TEX

## A chess PGN to TeX conversion tool

See it on [NPM](https://www.npmjs.com/package/pgn2tex)

# Installation
`npm install pgn2tex`

Import this library into your code with `const pgn2tex = require('pgn2tex')`

# About
The `pgn2tex` function takes two parameters:
- `pgn` - a string of the PGN file you wish to parse
- `diagrams` - JSON composed of the move ply number (integer), and the FEN string of the diagram you wish to include in the TeX output

```js
[
  {
    ply: 6,
    fen: 'rnbqkb1r/ppp1p1pp/3p1n2/5p2/2PP4/5N2/PP2PPPP/RNBQKB1R w KQkq - 2 4',
  },
  {
    ply: 13,
    fen: 'rnbq1rk1/ppp1p1bp/3p1np1/5p2/2PP4/2N2NP1/PP2PPBP/R1BQ1RK1 b - - 5 7',
  },
];
```

In order to render the output in a LaTeX based program, you need to have the `xskak` package installed. Copying the output into Overleaf will render a PDF of the output.

# Limitations
At present the following limitations / issues exist:
- nested variations have a maximum depth of 3. This is currently written in nested hell, but will be rewritten recusively once I can figure out how to correctly place the variation parenthesis
- comments are only shown if they are after the move
- variation comments are not shown

These issues are a priority for future versions.

## Contributing
Yes please. Contributions are always welcome. Please work from the `develop` branch.

Please open an issue to discuss.

## License
[GPL-3.0](https://choosealicense.com/licenses/gpl-3.0/)
