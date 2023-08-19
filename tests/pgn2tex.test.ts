import { pgn, diagrams } from './pgn2tex_helper';
import Pgn2Tex from '../src/pgn2tex';

describe('Pgn2Tex Class', () => {
  test('should create Pgn2Tex instance', () => {
    const pgn2Tex = new Pgn2Tex(pgn, diagrams);
    expect(pgn2Tex).toBeInstanceOf(Pgn2Tex);
  });

  // Add more test class/instance tests here
});

describe('Example game', () => {
  test('console.log tex', () => {
    const pgn2tex = new Pgn2Tex(pgn, diagrams);
    console.log(pgn2tex.toTex());
  });
});
