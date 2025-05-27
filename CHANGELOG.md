## 0.2.0
- Added support for customer headers `title` and `subtitle, allowing the overriding of standard PGN headers in the PDF.

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
- Typescript update from 5.1.6 to 5.3.3.

## v0.0.1
- Initial release
