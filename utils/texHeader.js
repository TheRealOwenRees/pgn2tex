const { header } = require('../pgn2tex');

// initial tex to setup the document
const texStart = `\\documentclass{article}
\\usepackage{xskak}
\\usepackage{multicol}
\\usepackage[a4paper]{geometry}
\\usepackage{parskip}
\\geometry{left=1.25cm,right=1.25cm,top=1.5cm,bottom=1.5cm,columnsep=1.2cm}
\\setlength{\\parindent}{0pt} 
\\title{${header.White} (${header.WhiteElo}) - ${header.Black} (${header.BlackElo})}
\\date{${header.Date.value}, ${header.Site}}
\\author{${header.Event}}
\\begin{document}
\\begin{multicols}{2}
\\maketitle
\\newchessgame`;

// closing tex
const texEnd = `\n\\end{multicols}
\\end{document}`;

module.exports = { texStart, texEnd };
