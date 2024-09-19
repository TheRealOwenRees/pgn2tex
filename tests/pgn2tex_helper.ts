import { readFileSync } from 'node:fs';

export const pgnReader = (file: string) => {
  try {
    return readFileSync(file, 'utf8');
  } catch (err) {
    console.error(err);
    return '';
  }
};

export const diagrams1 = [
  {
    ply: 6,
    fen: 'rnbqkb1r/ppp1p1pp/3p1n2/5p2/2PP4/5N2/PP2PPPP/RNBQKB1R w KQkq - 2 4',
  },
  {
    ply: 13,
    fen: 'rnbq1rk1/ppp1p1bp/3p1np1/5p2/2PP4/2N2NP1/PP2PPBP/R1BQ1RK1 b - - 5 7',
  },
];
