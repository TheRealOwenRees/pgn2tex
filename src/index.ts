import { parseGame, ParseTree } from '@mliebelt/pgn-parser';
import type { PgnMove, Tags } from '@mliebelt/pgn-types';
import { beginDocument, documentSetup, endDocument } from './documentConfig';
import { sanitiseString } from './utils';

export interface Diagram {
  ply: number;
  fen: string;
}

export interface ExtendedTags extends Partial<Tags> {
  Title?: string;
  Subtitle?: string;
  Author?: string;
  DateString?: string;
}

export default class Pgn2Tex {
  private readonly pgn: string;
  private diagrams: Diagram[];
  private readonly game: ParseTree;
  private moveStr: string;
  private readonly texStart: string;
  private readonly texEnd: string;
  private readonly header: ExtendedTags | undefined;
  private moves: PgnMove[];
  private readonly diagramClock: boolean;
  private readonly sanitisedGame: string;

  constructor(pgn: string, diagrams: Diagram[], diagramClock: boolean = false) {
    this.pgn = pgn;
    this.diagrams = diagrams;
    this.sanitisedGame = Pgn2Tex.sanitiseGame(this.pgn);
    this.game = parseGame(this.sanitisedGame);
    this.moveStr = '';

    const headerComponent = pgn?.split(/\n\n/g)[0];
    const titleMatch = headerComponent.match(/\[Title "([^"]+)"\]/);
    const subtitleMatch = headerComponent.match(/\[Subtitle "([^"]+)"\]/);
    const dateMatch = headerComponent.match(/\[Date "([^"]+)"\]/);
    const authorMatch = headerComponent.match(/\[Author "([^"]+)"\]/);
    const resultMatch = headerComponent.match(/\[Result "([^"]+)"\]/);

    if (titleMatch?.[1] || subtitleMatch?.[1]) {
      this.header = {
        Title: titleMatch?.[1],
        Subtitle: subtitleMatch?.[1],
        Author: authorMatch?.[1],
        DateString: dateMatch?.[1],
        Result: resultMatch?.[1],
      };

      this.texStart =
        `${documentSetup}` +
        `${this.header.Title ? `\\title{${this.header.Title}\\\\[2ex]` : ''}` +
        `${this.header.Subtitle ? `\\large{${this.header.Subtitle}}` : ''}` +
        `${this.header.DateString ? `\\date{${this.header.DateString}}` : '\\date{}'}` +
        `${this.header.Author ? `\\author{${this.header.Author}}` : ''}` +
        `${beginDocument(this.header)}`;
    } else {
      this.header = this.game.tags;

      const title = this.generatePlayersTitle();
      const dateSiteTitle = this.generateDateSiteTitle();

      this.texStart =
        `${documentSetup}` +
        `${title ? `\\title{${title}}\\\\[2ex]` : ''}` +
        `${dateSiteTitle ? `\\date{${dateSiteTitle}}` : '\\date{}'}` +
        `${this.header?.Event ? `\\author{${this.header.Event}}` : ''}` +
        `${beginDocument(this.header)}`;
    }

    this.texEnd = `\n${endDocument}`;
    this.moves = this.game.moves;
    this.diagramClock = diagramClock;
  }

  private generateDateSiteTitle() {
    if (!this.header) return '';

    const dateComponent = this.header.Date?.value ? this.header.Date.value : '';
    const siteComponent = this.header.Site ? this.header.Site : '';

    if (dateComponent && siteComponent) return `${dateComponent}, ${siteComponent}`;
    if (dateComponent) return `${dateComponent}`;
    if (siteComponent) return `${siteComponent}`;
    return '';
  }

  private generatePlayersTitle() {
    if (!this.header) return '';

    const whiteName = this.header.White ? sanitiseString(this.header.White) : '';
    const whiteElo = this.header.WhiteElo ? `(${this.header.WhiteElo})` : '';
    const whiteComponent = `${whiteName} ${whiteElo}`.trim();

    const blackName = this.header.Black ? sanitiseString(this.header.Black) : '';
    const blackElo = this.header.BlackElo ? `(${this.header.BlackElo})` : '';
    const blackComponent = `${blackName} ${blackElo}`.trim();

    if (whiteComponent && blackComponent) {
      return `${whiteComponent} - ${blackComponent}`;
    }

    return whiteComponent || blackComponent || '';
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
      this.moveStr += `\\newline ${sanitiseString(move.commentAfter)} \\par `;
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
    // add result if present in header
    if (this.header?.Result) {
      this.moveStr += `\\textbf{${this.header?.Result}}`;
    }

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
