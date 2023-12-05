export interface Diagram {
  ply: number
  fen: string
}
export default class Pgn2Tex {
  private readonly pgn
  private diagrams
  private readonly game
  private moveStr
  private readonly texStart
  private readonly texEnd
  private readonly header
  private moves
  constructor(pgn: string, diagrams: Diagram[])
  private addThreeDots
  private sideToMove
  private commentsAfter
  private diagram
  private variations
  private format
  toTex(): string
}
