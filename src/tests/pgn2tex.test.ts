import { pgn, diagrams } from './pgn2tex_helper';
import Pgn2Tex from '../pgn2tex';

describe('Pgn2Tex', () => {
  test('should create Pgn2Tex instance', () => {
    const pgn2Tex = new Pgn2Tex(pgn, diagrams);
    expect(pgn2Tex).toBeInstanceOf(Pgn2Tex);
  });

  // Add more test cases as needed
});
