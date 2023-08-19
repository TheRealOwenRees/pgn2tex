"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const pgn_parser_1 = require("@mliebelt/pgn-parser");
class Pgn2Tex {
    constructor(pgn, diagrams) {
        this.pgn = pgn;
        this.diagrams = diagrams;
        this.game = (0, pgn_parser_1.parseGame)(this.pgn);
        this.moveStr = '';
        this.header = this.game.tags;
        this.texStart = `\\documentclass{article}\\usepackage{xskak}\\usepackage{multicol}\\usepackage[a4paper]{geometry}\\usepackage{parskip}\\geometry{left=1.25cm,right=1.25cm,top=1.5cm,bottom=1.5cm,columnsep=1.2cm}\\setlength{\\parindent}{0pt}\\title{${this.header?.White} (${this.header?.WhiteElo}) - ${this.header?.Black} (${this.header?.BlackElo})}\\date{${this.header?.Date.value}, ${this.header?.Site}}\\author{${this.header?.Event}}\\begin{document}\\begin{multicols}{2}\\maketitle\\newchessgame`;
        this.texEnd = '\n\\end{multicols}\\end{document}';
        this.moves = this.game.moves;
    }
    addThreeDots(move) {
        if (move.turn === 'w')
            this.moveStr += `\\textbf{${move.moveNumber}...}`;
    }
    sideToMove(move) {
        if (move.turn === 'w')
            this.moveStr += `\\textbf{${move.moveNumber}.}`;
        this.moveStr += `\\textbf{${move.notation.notation}} `;
    }
    commentsAfter(move) {
        if (move.commentAfter) {
            this.moveStr += `\\newline ${move.commentAfter.trim()} \\par `;
            this.addThreeDots(move);
        }
    }
    diagram(move, index) {
        const diagramExists = this.diagrams.find((x) => x.ply === index + 1);
        if (diagramExists) {
            this.moveStr += `\\par\\chessboard[setfen=${diagramExists.fen}]\\par `;
            this.addThreeDots(move);
        }
    }
    variations(move, depth = 1) {
        let variationString = '';
        if (move.variations.length > 0) {
            move.variations.forEach((variation) => {
                variationString += '(';
                variation.forEach((varMove, varIndex) => {
                    const dots = varMove.turn === 'b' && varIndex === 0 ? '...' : '';
                    const moveNumber = varMove.turn === 'w' ? `${varMove.moveNumber}.` : '';
                    variationString += `${dots}${moveNumber}${varMove.notation.notation} `;
                    variationString += this.variations(varMove, depth + 1);
                });
                variationString = `${variationString.trim()}) `;
            });
            if (depth === 1) {
                this.moveStr += `${variationString.trim()} `;
                this.addThreeDots(move);
            }
        }
        return variationString.trim();
    }
    format() {
        this.moveStr += `\\textbf{${this.header?.Result}}`;
        this.moveStr.replaceAll(/#/g, '\\#');
    }
    toTex() {
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
exports.default = Pgn2Tex;
//# sourceMappingURL=pgn2tex.js.map