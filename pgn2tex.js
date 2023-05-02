const { parse } = require('@mliebelt/pgn-parser');

const pgn2tex = (pgn, diagrams) => {
  const game = parse(pgn);
  const header = game[0].tags;
  const { moves } = game[0];

  // write variations to string, adding move numbers and ...
  const writeVariations = (move, index) => {
    let result = '';
    if (move.turn === 'b' && index === 0) result += '...';
    if (move.turn === 'w') result += `${move.moveNumber}.`;
    result += `${move.notation.notation} `;
    return result;
  };

  // opening and closing TeX
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
      // TODO game comments before and after
      // TODO rewrite recursively? I have had trouble getting the parenthesis to order correctly
      let variationString = '('; // with starting parenthesis

      // variation depth 1
      if (move.variations.length > 0) {
        move.variations.forEach((variationDepth1) => {
          variationDepth1.forEach((moveDepth1, indexDepth1) => {
            variationString += writeVariations(moveDepth1, indexDepth1);
            // variation depth 2
            if (moveDepth1.variations.length > 0) {
              moveDepth1.variations.forEach((variationDepth2) => {
                variationString += '(';
                variationDepth2.forEach((moveDepth2, indexDepth2) => {
                  variationString += writeVariations(moveDepth2, indexDepth2);
                  // variation depth 3
                  if (moveDepth2.variations.length > 0) {
                    moveDepth2.variations.forEach((variationDepth3) => {
                      variationString += '(';
                      variationDepth3.forEach((moveDepth3, indexDepth3) => {
                        variationString += writeVariations(
                          moveDepth3,
                          indexDepth3,
                        );
                      });
                      variationString = `${variationString.trim()}) `;
                    });
                  }
                });
                variationString = `${variationString.trim()}) `;
              });
            }
          });
          variationString = `${variationString.trim()}`;
        });

        moveStr += `${variationString.trim()}) `; // with ending parenthesis
        if (move.turn === 'w') moveStr += `\\textbf{${move.moveNumber}...}`;
      }
    });

    // end of moveStr
    moveStr += `\\textbf{${header.Result}}`;
    return moveStr.replaceAll(/#/g, '\\#'); // regex replace # with \# for LaTex
  };

  return texStart + moveText(diagrams) + texEnd;
};

module.exports = pgn2tex;
