import { parseGame, ParseTree } from '@mliebelt/pgn-parser';
import type { PgnMove, Tags } from '@mliebelt/pgn-types';

export interface Diagram {
  ply: number;
  fen: string;
}

export default class Pgn2Tex {
  private readonly pgn: string;
  private diagrams: Diagram[];
  private readonly game: ParseTree;
  private moveStr: string;
  private readonly texStart: string;
  private readonly texEnd: string;
  private readonly header: Tags | undefined;
  private moves: PgnMove[];
  private readonly diagramClock: boolean;
  private readonly sanitisedGame: string;

  constructor(pgn: string, diagrams: Diagram[], diagramClock: boolean = false) {
    this.pgn = pgn;
    this.diagrams = diagrams;
    this.sanitisedGame = Pgn2Tex.sanitiseGame(this.pgn);
    this.game = parseGame(this.sanitisedGame);
    this.moveStr = '';
    this.header = this.game.tags;
    this.texStart = `\\documentclass{article}\\usepackage{xskak}\\usepackage{multicol}\\usepackage[a4paper]{geometry}\\usepackage{parskip}\\geometry{left=1.25cm,right=1.25cm,top=1.5cm,bottom=1.5cm,columnsep=1.2cm}\\setlength{\\parindent}{0pt}\\title{${this
      .header?.White} (${this.header?.WhiteElo}) - ${this.header?.Black} (${this.header?.BlackElo})}\\date{${
      !this.header?.Date.value ? '' : this.header?.Date.value
    }${this.header?.Date.value && this.header?.Site ? ', ' : ''}${this.header?.Site}}\\author{${this.header
      ?.Event}}\\begin{document}\\begin{multicols}{2}\\maketitle\\newchessgame`;
    this.texEnd = '\n\\end{multicols}\\end{document}';
    this.moves = this.game.moves;
    this.diagramClock = diagramClock;
  }

  /**
   * Remove odd whitespace (☒) characters and comments inside square brackets.
   * @param pgn
   * @private
   */
  private static sanitiseGame(pgn: string) {
    const whitespaceChars = '☒';
    const squareBracketComments = /(?<=\{)\[[\s\S]*?]\s?/g;
    return pgn.replaceAll(whitespaceChars, ' ').replaceAll(squareBracketComments, '');
  }

  private addThreeDots(move: PgnMove) {
    if (move.turn === 'w') this.moveStr += `\\textbf{${move.moveNumber}...}`;
  }

  private sideToMove(move: PgnMove) {
    if (move.turn === 'w') this.moveStr += `\\textbf{${move.moveNumber}.}`;
    this.moveStr += `\\textbf{${move.notation.notation}} `;
  }

  private commentsAfter(move: PgnMove) {
    if (move.commentAfter) {
      this.moveStr += `\\newline ${move.commentAfter.trim()} \\par `;
      this.addThreeDots(move);
    }
  }

  private moveTime(move: PgnMove) {
    if (!this.diagramClock) return { whiteTime: null, blackTime: null };
    try {
      const { moveNumber } = move;
      const moveClock = this.game.moves[moveNumber].commentDiag.clk;
      const previousMoveClock = this.game.moves[moveNumber - 1].commentDiag.clk;
      const whiteTime = move.turn === 'w' ? moveClock : previousMoveClock;
      const blackTime = move.turn === 'b' ? moveClock : previousMoveClock;
      return { whiteTime, blackTime };
    } catch {
      return { whiteTime: null, blackTime: null };
    }
  }

  private diagram(move: PgnMove, index: number) {
    const diagramExists = this.diagrams.find((x) => x.ply === index + 1);
    const { whiteTime, blackTime } = this.moveTime(move);

    if (whiteTime && blackTime && diagramExists) {
      this.moveStr += `\\par\\nobreak\\textbf{${blackTime}}\\par\\nobreak\\chessboard[setfen=${diagramExists.fen}, vmargin=false]\\par\\nobreak\\vspace{1mm}\\nobreak\\textbf{${whiteTime}}\\par`;
      this.addThreeDots(move);
    } else if (diagramExists) {
      this.moveStr += `\\par\\chessboard[setfen=${diagramExists.fen}]\\par `;
      this.addThreeDots(move);
    }
  }

  private variations(move: PgnMove, depth: number = 1): string {
    let variationString = '';

    if (move.variations.length > 0) {
      move.variations.forEach((variation: PgnMove[]) => {
        variationString += '(';
        variation.forEach((varMove, varIndex) => {
          const dots = varMove.turn === 'b' && varIndex === 0 ? '...' : '';
          const moveNumber = varMove.turn === 'w' ? `${varMove.moveNumber}.` : '';

          variationString += `${dots}${moveNumber}${varMove.notation.notation} `;
          variationString += varMove.commentAfter ? `\\textit{${varMove.commentAfter.trim()}} ` : '';
          variationString += this.variations(varMove, depth + 1);
        });

        // if the variation starts with a move number, add a space after the closing bracket
        if (/\)\w/.test(variationString)) {
          variationString = variationString.replaceAll(/\)(\w)/g, ') $1');
        }

        variationString = `${variationString.trim()}) `;
      });

      if (depth === 1) {
        this.moveStr += `${variationString.trim()} `;
        this.addThreeDots(move);
      }
    }

    return variationString.trim();
  }

  private format() {
    this.moveStr += `\\textbf{${this.header?.Result}}`; // add result
    this.moveStr = this.moveStr.replaceAll(/#/g, '\\#'); // remove TeX special characters
    this.moveStr = this.moveStr.replace(/ {2,}/g, ' '); // remove double spaces
  }

  /**
   * Convert PGN to LaTeX markdown
   * @returns {string} LaTeX markdown
   */
  public toTex(): string {
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
