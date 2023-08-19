import { parseGame, ParseTree } from '@mliebelt/pgn-parser';
import type { PgnMove, Tags } from '@mliebelt/pgn-parser';

interface Diagram {
  ply: number;
  fen: string;
}

class Pgn2Tex {
  private readonly pgn: string;
  private diagrams: Diagram[];
  private readonly game: ParseTree;
  private moveStr: string;
  private readonly texStart: string;
  private readonly texEnd: string;
  private readonly header: Tags | undefined;
  private moves: PgnMove[];

  constructor(pgn: string, diagrams: Diagram[]) {
    this.pgn = pgn;
    this.diagrams = diagrams;
    this.game = parseGame(this.pgn);
    this.moveStr = ''; // TODO consider moving inside of toTex() and returning from each method instead of writing here
    this.header = this.game.tags;
    this.texStart = `\\documentclass{article}\\usepackage{xskak}\\usepackage{multicol}\\usepackage[a4paper]{geometry}\\usepackage{parskip}\\geometry{left=1.25cm,right=1.25cm,top=1.5cm,bottom=1.5cm,columnsep=1.2cm}\\setlength{\\parindent}{0pt}\\title{${this.header?.White} (${this.header?.WhiteElo}) - ${this.header?.Black} (${this.header?.BlackElo})}\\date{${this.header?.Date.value}, ${this.header?.Site}}\\author{${this.header?.Event}}\\begin{document}\\begin{multicols}{2}\\maketitle\\newchessgame`;
    this.texEnd = '\n\\end{multicols}\\end{document}';
    this.moves = this.game.moves;
  }

  private addThreeDots(move: PgnMove) {
    if (move.turn === 'w') this.moveStr += `\\textbf{${move.moveNumber}...}`;
  }

  private sideToMove(move: PgnMove) {
    if (move.turn === 'w') this.moveStr += `\\textbf{${move.moveNumber}.}`;
    this.moveStr += `\\textbf{${move.notation.notation}} `;
  }

  // TODO write commentsBefore method
  private commentsAfter(move: PgnMove) {
    if (move.commentAfter) {
      this.moveStr += `\\newline ${move.commentAfter.trim()} \\par `;
      this.addThreeDots(move);
    }
  }

  private diagram(move: PgnMove, index: number) {
    const diagramExists = this.diagrams.find((x) => x.ply === index + 1);
    if (diagramExists) {
      this.moveStr += `\\par\\chessboard[setfen=${diagramExists.fen}]\\par `; // TODO check if the diagram was at the last move
      this.addThreeDots(move);
    }
  }

  private variations(move: PgnMove) {
    const writeVariations = (currentMove: PgnMove, index: number) => {
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

  private format() {
    this.moveStr += `\\textbf{${this.header?.Result}}`;
    this.moveStr.replaceAll(/#/g, '\\#');
  }

  public toTex() {
    this.moves.forEach((move, index) => {
      this.sideToMove(move);
      this.commentsAfter(move);
      this.diagram(move, index);
      this.variations(move);
    });
    this.format();
    return `${this.texStart}${this.moveStr}${this.texEnd}`;
  }
}

export default Pgn2Tex;
