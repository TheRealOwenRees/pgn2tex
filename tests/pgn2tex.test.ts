import { pgn, pgnMoveTimes, diagrams } from './pgn2tex_helper';
import Pgn2Tex from '../src/index';

describe('Pgn2Tex Class', () => {
  test('should create Pgn2Tex instance', () => {
    const pgn2Tex = new Pgn2Tex(pgn, diagrams);
    expect(pgn2Tex).toBeInstanceOf(Pgn2Tex);
  });
});

describe('Example game', () => {
  it('renders board without move times', () => {
    const pgn2tex = new Pgn2Tex(pgnMoveTimes, diagrams);
    const texString = pgn2tex.toTex();
    expect(texString).not.toContain('\\par\\nobreak\\textbf');
    expect(texString).toContain('\\par\\chessboard[setfen=');
  });

  it('renders board with move times', () => {
    const pgn2tex = new Pgn2Tex(pgnMoveTimes, diagrams, true);
    const texString = pgn2tex.toTex();
    expect(texString).not.toContain('\\par\\chessboard[setfen=');
    expect(texString).toContain('\\par\\nobreak\\textbf');
  });
});
