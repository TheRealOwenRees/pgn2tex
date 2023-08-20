import { parseGame } from '@mliebelt/pgn-parser';
var Index = /** @class */ (function () {
    function Index(pgn, diagrams) {
        var _a, _b, _c, _d, _e, _f, _g;
        this.pgn = pgn;
        this.diagrams = diagrams;
        this.game = parseGame(this.pgn);
        this.moveStr = '';
        this.header = this.game.tags;
        this.texStart = "\\documentclass{article}\\usepackage{xskak}\\usepackage{multicol}\\usepackage[a4paper]{geometry}\\usepackage{parskip}\\geometry{left=1.25cm,right=1.25cm,top=1.5cm,bottom=1.5cm,columnsep=1.2cm}\\setlength{\\parindent}{0pt}\\title{".concat((_a = this.header) === null || _a === void 0 ? void 0 : _a.White, " (").concat((_b = this.header) === null || _b === void 0 ? void 0 : _b.WhiteElo, ") - ").concat((_c = this.header) === null || _c === void 0 ? void 0 : _c.Black, " (").concat((_d = this.header) === null || _d === void 0 ? void 0 : _d.BlackElo, ")}\\date{").concat((_e = this.header) === null || _e === void 0 ? void 0 : _e.Date.value, ", ").concat((_f = this.header) === null || _f === void 0 ? void 0 : _f.Site, "}\\author{").concat((_g = this.header) === null || _g === void 0 ? void 0 : _g.Event, "}\\begin{document}\\begin{multicols}{2}\\maketitle\\newchessgame");
        this.texEnd = '\n\\end{multicols}\\end{document}';
        this.moves = this.game.moves;
    }
    Index.prototype.addThreeDots = function (move) {
        if (move.turn === 'w')
            this.moveStr += "\\textbf{".concat(move.moveNumber, "...}");
    };
    Index.prototype.sideToMove = function (move) {
        if (move.turn === 'w')
            this.moveStr += "\\textbf{".concat(move.moveNumber, ".}");
        this.moveStr += "\\textbf{".concat(move.notation.notation, "} ");
    };
    Index.prototype.commentsAfter = function (move) {
        if (move.commentAfter) {
            this.moveStr += "\\newline ".concat(move.commentAfter.trim(), " \\par ");
            this.addThreeDots(move);
        }
    };
    Index.prototype.diagram = function (move, index) {
        var diagramExists = this.diagrams.find(function (x) { return x.ply === index + 1; });
        if (diagramExists) {
            this.moveStr += "\\par\\chessboard[setfen=".concat(diagramExists.fen, "]\\par ");
            this.addThreeDots(move);
        }
    };
    Index.prototype.variations = function (move, depth) {
        var _this = this;
        if (depth === void 0) { depth = 1; }
        var variationString = '';
        if (move.variations.length > 0) {
            move.variations.forEach(function (variation) {
                variationString += '(';
                variation.forEach(function (varMove, varIndex) {
                    var dots = varMove.turn === 'b' && varIndex === 0 ? '...' : '';
                    var moveNumber = varMove.turn === 'w' ? "".concat(varMove.moveNumber, ".") : '';
                    variationString += "".concat(dots).concat(moveNumber).concat(varMove.notation.notation, " ");
                    variationString += _this.variations(varMove, depth + 1);
                });
                variationString = "".concat(variationString.trim(), ") ");
            });
            if (depth === 1) {
                this.moveStr += "".concat(variationString.trim(), " ");
                this.addThreeDots(move);
            }
        }
        return variationString.trim();
    };
    Index.prototype.format = function () {
        var _a;
        this.moveStr += "\\textbf{".concat((_a = this.header) === null || _a === void 0 ? void 0 : _a.Result, "}");
        this.moveStr.replaceAll(/#/g, '\\#');
    };
    Index.prototype.toTex = function () {
        var _this = this;
        this.moves.forEach(function (move, index) {
            _this.sideToMove(move);
            _this.commentsAfter(move);
            _this.diagram(move, index);
            _this.variations(move);
        });
        this.format();
        return "".concat(this.texStart).concat(this.moveStr).concat(this.texEnd);
    };
    return Index;
}());
export default Index;
