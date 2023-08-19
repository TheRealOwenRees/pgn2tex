import { parse } from '@mliebelt/pgn-parser';

interface Diagram {
  ply: number;
  fen: string;
}

class Pgn2Tex {
  private readonly pgn: string;
  private diagrams: Diagram[];
  private readonly game: any;
  private moveStr: string;
  private texStart: string;
  private texEnd: string;

  constructor(pgn: string, diagrams: Diagram[]) {
    this.pgn = pgn;
    this.diagrams = diagrams;
    this.game = parse(this.pgn, { startRule: 'game' });
    this.moveStr = '';
    this.texStart = '';
    this.texEnd = '';
    this.init();
  }

  private init() {
    const header = this.game.tags;
    const { moves } = this.game;
    this.texStart = `\\documentclass{article}\\usepackage{xskak}\\usepackage{multicol}\\usepackage[a4paper]{geometry}\\usepackage{parskip}\\geometry{left=1.25cm,right=1.25cm,top=1.5cm,bottom=1.5cm,columnsep=1.2cm}\\setlength{\\parindent}{0pt}\\title{${header.White} (${header.WhiteElo}) - ${header.Black} (${header.BlackElo})}\\date{${header.Date.value}, ${header.Site}}\\author{${header.Event}}\\begin{document}\\begin{multicols}{2}\\maketitle\\newchessgame`;
    this.texEnd = '\n\\end{multicols}\\end{document}';
    this.movesToText(moves);
  }

  private formatString() {
    this.moveStr += `\\textbf{${this.game.tags.Result}}`;
    this.moveStr.replaceAll(/#/g, '\\#');
  }

  private addThreeDots(move) {
    if (move.turn === 'w') this.moveStr += `\\textbf{${move.moveNumber}...}`;
  }

  private sideToMove(move) {
    if (move.turn === 'w') this.moveStr += `\\textbf{${move.moveNumber}.}`;
    this.moveStr += `\\textbf{${move.notation.notation}} `;
  }

  // TODO write commentsBefore method
  private commentsAfter(move) {
    if (move.commentAfter) {
      this.moveStr += `\\newline ${move.commentAfter.trim()} \\par `;
      this.addThreeDots(move);
    }
  }

  private diagram(move, index: number) {
    const diagramExists = this.diagrams.find((x) => x.ply === index + 1);
    if (diagramExists) {
      this.moveStr += `\\par\\chessboard[setfen=${diagramExists.fen}]\\par `; // TODO check if the diagram was at the last move
      this.addThreeDots(move);
    }
  }

  private variations(move) {
    const writeVariations = (currentMove, index) => {
      let result = '';
      if (currentMove.turn === 'b' && index === 0) result += '...';
      if (currentMove.turn === 'w') result += `${currentMove.moveNumber}.`;
      result += `${currentMove.notation.notation} `;
      return result;
    };
    let variationString = '(';
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
      this.moveStr += `${variationString.trim()}) `;
      this.addThreeDots(move);
    }
  }

  private movesToText(moves) {
    moves.forEach((move, index: number) => {
      this.sideToMove(move);
      this.commentsAfter(move);
      this.diagram(move, index);
      this.variations(move);
      this.formatString();
    });
  }

  public toTex() {
    return `${this.texStart}${this.moveStr}${this.texEnd}`;
    // TODO reduce/remove or call init() because this method should now start the conversion
  }
}

export default Pgn2Tex;
