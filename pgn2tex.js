const MAX_VARIATION_DEPTH = 3; // maximum nested variations that will be displayed

const { parse } = require('@mliebelt/pgn-parser');

const pgn2tex = (pgn, diagrams) => {
  const game = parse(pgn);
  const header = game[0].tags;
  const { moves } = game[0];

  // TODO add comments after and before
  // write variations to string, adding move numbers and ...
  const writeVariationMove = (move, index) => {
    let result = '';
    if (move.turn === 'b' && index === 0) result += '...';
    if (move.turn === 'w') result += `${move.moveNumber}.`;
    result += `${move.notation.notation} `;
    return result;
  };

  const writeVariations = (move, depth = 0, maxDepth = MAX_VARIATION_DEPTH) => {
    // base case
    if (depth >= maxDepth) {
      return '';
    }

    let variationString = '('; // with starting parenthesis
    move.variations.forEach((variation) => {
      variation.forEach((variationMove, index) => {
        variationString += writeVariationMove(variationMove, index);
        if (variationMove.variations.length > 0) {
          variationString += writeVariations(variationMove, depth + 1, maxDepth);
        }
      });

      // Append closing parentheses to match depth of recursion
      for (let i = 0; i < depth; i + 1) {
        variationString += ')';
      }

      variationString = `${variationString.trim()} `;
    });

    return `${variationString.trim()}`; // with ending parenthesis
  };

  // starting and ending markdown for TeX document
  const texStart = `\\documentclass{article}\\usepackage{xskak}\\usepackage{multicol}\\usepackage[a4paper]{geometry}\\usepackage{parskip}\\geometry{left=1.25cm,right=1.25cm,top=1.5cm,bottom=1.5cm,columnsep=1.2cm}\\setlength{\\parindent}{0pt}\\title{${header.White} (${header.WhiteElo}) - ${header.Black} (${header.BlackElo})}\\date{${header.Date.value}, ${header.Site}}\\author{${header.Event}}\\begin{document}\\begin{multicols}{2}\\maketitle\\newchessgame`;
  const texEnd = '\n\\end{multicols}\\end{document}';

  // build tex for the moves/comments/diagrams
  const moveText = () => {
    let moveStr = '';
    moves.forEach((move, index) => {
      // add numbers to move pairs
      if (move.turn === 'w') moveStr += `\\textbf{${move.moveNumber}.}`;
      // add move to string
      moveStr += `\\textbf{${move.notation.notation}} `;
      // add comments after move - TODO add comments before as well
      if (move.commentAfter) {
        moveStr += `\\newline ${move.commentAfter.trim()} \\par `;
        if (move.turn === 'w') moveStr += `\\textbf{${move.moveNumber}...}`;
      }

      // display chessboard diagram at ply - object (ply/fen) to be passed as function parameter
      const diagramExists = diagrams.find((x) => x.ply === index + 1);
      if (diagramExists) {
        moveStr += `\\par\\chessboard[setfen=${diagramExists.fen}]\\par `;
        // TODO check if the diagram was at the last move
        // add ...dots if it is black to move next when resuming mainline
        if (move.turn === 'w') moveStr += `\\textbf{${move.moveNumber}...}`;
      }

      // Variations
      if (move.variations.length > 0) {
        moveStr += writeVariations(move);
        if (move.turn === 'w') moveStr += `\\textbf{${move.moveNumber}...}`;
      }
    });

    // end of moveStr
    moveStr += `\\textbf{${header.Result}}`;
    moveStr = moveStr.replaceAll(/#/g, '\\#'); // regex replace # with \# for LaTex
    return moveStr;
  };

  return texStart + moveText(diagrams) + texEnd;
};

module.exports = pgn2tex;
