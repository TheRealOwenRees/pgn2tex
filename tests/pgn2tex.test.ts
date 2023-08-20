import { pgn, diagrams } from './pgn2tex_helper';
import Pgn2tex from '../src/pgn2tex';

describe('Pgn2Tex Class', () => {
  test('should create Pgn2Tex instance', () => {
    const pgn2Tex = new Pgn2tex(pgn, diagrams);
    expect(pgn2Tex).toBeInstanceOf(Pgn2tex);
  });

  // Add more test class/instance tests here
});

describe('Example game', () => {
  test('console.log tex', () => {
    const pgn2tex = new Pgn2tex(pgn, diagrams);
    console.log(pgn2tex.toTex());
  });
});
