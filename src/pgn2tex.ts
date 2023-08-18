import { parse } from '@mliebelt/pgn-parser';

interface Diagram {
  ply: number;
  fen: string;
}

class Pgn2Tex {
  private readonly pgn: string;
  private diagrams: Diagram[];
  private readonly game: any;

  constructor(pgn: string, diagrams: Diagram[]) {
    this.pgn = pgn;
    this.diagrams = diagrams;
    this.game = parse(this.pgn, { startRule: 'game' });
    this.init();
  }

  init() {
    const header = this.game.tags;
    const { moves } = this.game;
    const texStart = `\\documentclass{article}\\usepackage{xskak}\\usepackage{multicol}\\usepackage[a4paper]{geometry}\\usepackage{parskip}\\geometry{left=1.25cm,right=1.25cm,top=1.5cm,bottom=1.5cm,columnsep=1.2cm}\\setlength{\\parindent}{0pt}\\title{${header.White} (${header.WhiteElo}) - ${header.Black} (${header.BlackElo})}\\date{${header.Date.value}, ${header.Site}}\\author{${header.Event}}\\begin{document}\\begin{multicols}{2}\\maketitle\\newchessgame`;
    const texEnd = '\n\\end{multicols}\\end{document}';
  }
}

export default Pgn2Tex;
