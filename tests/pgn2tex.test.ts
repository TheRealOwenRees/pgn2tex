import { pgnReader, diagrams1 } from './pgn2tex_helper';
import Pgn2Tex from '../src/index';

describe('Pgn2Tex Class', () => {
  test('should create Pgn2Tex instance', () => {
    const pgn = pgnReader('tests/pgn_examples/1.pgn');
    const pgntex = new Pgn2Tex(pgn, []);
    expect(pgntex).toBeInstanceOf(Pgn2Tex);
  });
});

describe('Example PGNs', () => {
  test('Game 1 - renders board without move times', () => {
    const pgn = pgnReader('tests/pgn_examples/1.pgn');
    const pgn2Tex = new Pgn2Tex(pgn, diagrams1);
    const texString = pgn2Tex.toTex();
    expect(texString).not.toContain('\\par\\nobreak\\textbf');
    expect(texString).toContain('\\par\\chessboard[setfen=');
  });

  test('Game 2 - renders board with move times', () => {
    const pgn = pgnReader('tests/pgn_examples/2.pgn');
    const pgn2Tex = new Pgn2Tex(pgn, diagrams1, true);
    const texString = pgn2Tex.toTex();
    expect(texString).not.toContain('\\par\\chessboard[setfen=');
    expect(texString).toContain('\\par\\nobreak\\textbf');
  });

  test('Game 3 - Simple Game, no diagrams', () => {
    const pgn = pgnReader('tests/pgn_examples/3.pgn');
    const pgn2Tex = new Pgn2Tex(pgn, []);
    const texString = pgn2Tex.toTex();
    expect(texString).not.toContain('\\par\\nobreak\\textbf');
    expect(texString).not.toContain('\\par\\chessboard[setfen=');
  });

  test('Game 4 - Complex Game', () => {
    const pgn = pgnReader('tests/pgn_examples/4.pgn');
    const pgn2Tex = new Pgn2Tex(pgn, diagrams1);
    const texString = pgn2Tex.toTex();
    expect(texString).not.toContain('\\par\\nobreak\\textbf');
    expect(texString).toContain('\\par\\chessboard[setfen=');
  });

  test('Game 5 - No Date, do not render as undefined', () => {
    const pgn = pgnReader('tests/pgn_examples/5.pgn');
    const pgn2Tex = new Pgn2Tex(pgn, diagrams1);
    const texString = pgn2Tex.toTex();
    expect(texString).not.toContain('\\date{undefined, }');
  });

  test('Game 6 - same as game 5 but with a place name', () => {
    const pgn = pgnReader('tests/pgn_examples/6.pgn');
    const pgn2Tex = new Pgn2Tex(pgn, diagrams1);
    const texString = pgn2Tex.toTex();
    expect(texString).not.toContain('\\date{undefined, }');
    expect(texString).toContain('\\date{Terrassa}');
  });
});
