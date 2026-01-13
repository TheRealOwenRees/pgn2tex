const documentStart = '\\documentclass{article}';
const documentPackages =
  '\\usepackage{xskak}\\usepackage{multicol}\\usepackage[a4paper]{geometry}\\usepackage{parskip}';
const documentGeometry = '\\geometry{left=1.25cm,right=1.25cm,top=1.5cm,bottom=1.5cm,columnsep=1.2cm}';
const documentLength = '\\setlength{\\parindent}{0pt}';

export const documentSetup = `${documentStart}${documentPackages}${documentGeometry}${documentLength}`;
export const beginDocument = '\\begin{document}\\begin{multicols}{2}\\maketitle\\newchessgame';
export const endDocument = '\\end{multicols}\\end{document}';
