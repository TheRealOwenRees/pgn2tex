## v1.0.0-rc.1

- Full rewrite in OCaml.
- NAGs, clocks, and variations are now rendered.

## v0.2.2

- Sanitise `&` and `:` as escape charcters in TeX output.
- Remove space for the title if no title information is present. Game moves will start at the top of the page.

## v0.2.1

- Fixed 'undefined' appearing in PDF when custom headers are used, but where some are left blank.
- Change the way TEX tags are written, conditionally rendering them where needed to help prevent `undefined`.

## v0.2.0

- Added support for customer headers `title` and `subtitle`, allowing the overriding of standard PGN headers in the PDF.
- Added scripts and GH Actions to check linting and build on branch push and PR creation.

## v0.1.7

- Fixed bug where no date in the PGN header was being rendered as `undefined`

## v0.1.6

- Variation comments are now displayed.
- Additional TeX sanitisation: removing double spaces, adding a space after a move number if preceded by parenthesis.

## v0.1.5

- Sanitise PGN before passing onto the PGN parser. Removes the odd whitespace character '☒' found in one example, and removes comments inside of square brackets which are often square highlights from Chess.com or Lichess. Non-ASCII character removal is on the roadmap.
- TSDoc comments added to the public `toTex` method.

## v0.1.0

- Move times displayed at the top and bottom of the chessboard, set with the boolean `diagramClock`.
- TypeScript update from 5.1.6 to 5.3.3.

## v0.0.1

- Initial release
