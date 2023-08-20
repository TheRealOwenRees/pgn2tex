import { pgn, diagrams } from './pgn2tex_helper';
import Index from '../src/index';

describe('Pgn2Tex Class', () => {
  test('should create Pgn2Tex instance', () => {
    const pgn2Tex = new Index(pgn, diagrams);
    expect(pgn2Tex).toBeInstanceOf(Index);
  });

  // Add more test class/instance tests here
});

describe('Example game', () => {
  test('console.log tex', () => {
    const pgn2tex = new Index(pgn, diagrams);
    console.log(pgn2tex.toTex());
  });
});
