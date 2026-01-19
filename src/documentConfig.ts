import type { ExtendedTags } from './index';

type Header = ExtendedTags | undefined;

const documentStart = '\\documentclass{article}';
const documentPackages =
  '\\usepackage{xskak}\\usepackage{multicol}\\usepackage[a4paper]{geometry}\\usepackage{parskip}';
const documentGeometry = '\\geometry{left=1.25cm,right=1.25cm,top=1.5cm,bottom=1.5cm,columnsep=1.2cm}';
const documentLength = '\\setlength{\\parindent}{0pt}';

export const documentSetup = `${documentStart}${documentPackages}${documentGeometry}${documentLength}`;

export const beginDocument = (header: Header) => {
  const isTitle = !!(
    header?.Title ||
    header?.Subtitle ||
    header?.Author ||
    header?.DateString ||
    header?.Event ||
    header?.Date ||
    header?.Site
  );

  const start = '\\begin{document}\\begin{multicols}{2}';
  const makeTitle = isTitle ? '\\maketitle' : '';
  const end = '\\newchessgame';

  return `${start}${makeTitle}${end}`;
};

export const endDocument = '\\end{multicols}\\end{document}';
