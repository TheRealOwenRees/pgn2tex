# PGN to TeX

This is the project that powers the PGN to TeX string conversion for [chess-pdf-api](https://github.com/TheRealOwenRees/chess-pdf-api). It can be found on NPM as [owenrees/pgn2tex](https://www.npmjs.com/package/@owenrees/pgn2tex?activeTab=readme).

## Install
Install the NPM package as a dependency:
```bash
npm install owenrees/pgn2tex --save
```

Import it into your project:
```js
import Pgn2Tex from '@owenrees/pgn2tex';
```

## Reference

The Pgn2Tex class exposes a single method: `toTex()`. This method will convert the arguments provided to the constructor into a TeX string.

#### Generate TeX String

The Pgn2Tex class is used to generate a TeX string from a PGN file. It takes two arguments:

| Parameter      | Type      | Description                                                                                                                                                                                          |
|----------------|-----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `pgn`          | `string`  | **Required**. A valid PGN of a chess game.                                                                                                                                                           |
| `diagrams`     | `array`   | An array of objects, containing:<br/> - `ply`(integer): The move ply for a chess diagram.<br/> - `fen`(string): A FEN of the board position, for rendering the correct diagram at the ply specified. |
| `diagramClock` | `boolean` | Display move times above and below the chessboard. Default is `false`.                                                                                                                               |

The `diagrams` parameter is optional, and if not provided, the TeX string will not contain any diagrams.

#### Example Usage

```javascript
const gameTex = new Pgn2Tex(pgn, diagrams).toTex()
````

Example `pgn` and `diagram` arguments are defined as follows:
```javascript
const pgn = `[Event "URS-chJ"]
[Site "Kherson"]
[Date "1991.??.??"]
[Round "?"]
[White "Ibragimov, Ildar"]
[Black "Kramnik, Vladimir"]
[Result "0-1"]
[ECO "A88"]
[WhiteElo "2455"]
[BlackElo "2480"]
[PlyCount "110"]
[EventDate "1991.??.??"]
[Source "ChessBase"]

1. d4 {A88: Dutch Defence: Leningrad System: 5 Nf3 0-0 6 0-0 d6 7 Nc3 c6} d6 2. c4 f5 3. Nf3 Nf6 4. g3 g6 5. Bg2 Bg7 6. O-O O-O 7. Nc3 Qe8 8. b3 Na6 9. Ba3 c6 10. Qd3 Rb8 11. e4 fxe4 12. Nxe4 Bf5 13. Nxf6+ Bxf6 14. Qd2 Nc7 15. Rae1 Qd7 16. h4 b5 17. Re3 bxc4 18. bxc4 Bh3 19. Rfe1 Bxg2 {last book move} 20. Kxg2 Qf5 21. Re4 Rbe8 22. Rf4 Qc8 23. Qa5 d5 24. cxd5 Nxd5 25. Rfe4 {e7 seems the pivot of the position} Qf5 26. Qd2 ( 26. Qxa7$4 {taking the pawn is naive} Qxf3+ {Annihilates a defender: f3} 27. Kxf3 Bxd4+ 28. Kg4 Bxa7 29. Bxe7 Rxf2$19 ( 29... Rxe7 30. Rxe7 Bxf2 31. a4$19 ) ( 29... Nxe7$6 30. Rxe7 Rxe7 31. Rxe7 Bxf2 32. a4$19 ) ) Bg7 27. Nh2 Rf7 28. Bc5 {The white bishop on an outpost} Qd7 29. a4 Nf6 30. Re5 Nd5 31. R5e4 ( 31. R5e2 Rb8$14 ) Nf6$11 32. Re5 Kh8 ( 32... Nd5 33. R5e2$14 ) 33. Kg1 Nd5 {A valuable piece} 34. R5e2 a6 35. Qd3 Qh3 ( 35... Ra8$14 ) 36. Nf3 ( 36. Qxa6 Ref8 37. Qa5$14 ( 37. Qxc6 Rxf2 38. Rxf2 Qxg3+ 39. Kh1 Rxf2 ( 39... Qxf2$6 40. Rf1 Qa2 41. Rxf8+ Bxf8 42. Kg1$11 ) 40. Qa8+ Bf8 41. Qxf8+ Rxf8 42. Re2 Rf2 43. Rxf2 Qxf2 44. Ng4 Qf1+ 45. Kh2 Nf4 46. Ne3 Qf2+ 47. Kh1 Qxh4+ 48. Kg1 Qg3+ 49. Kf1 Qxe3 50. Bb6 Qe2+ 51. Kg1 Qg2# ) ( 37. Bxe7$4 {White will choke on that pawn} Rxf2 ( 37... Nxe7$6 38. Rd1$19 ) 38. Rxf2 Qxg3+ 39. Kh1 Rxf2 ( 39... Qxf2 40. Re2 Qxd4 41. Bxf8 Qd1+ 42. Kg2 Nf4+ 43. Kf3$11 ) 40. Qc8+ Bf8 41. Bf6+ Nxf6 42. Qxf8+ Ng8 43. Qxf2 Qxf2$19 ) ) Nf4$15 {Do you see the mate threat?} 37. gxf4 Rxf4 {The mate threat is Rg4} 38. Ne5 ( 38. Re4$5 {is worthy of consideration} Qg4+ 39. Kf1 Rxf3 40. Rxg4 Rxd3 41. Re6$15 ) Rg4+$1$17 {keeping the advantage} 39. Nxg4 {Theme: Deflection from d3} Qxd3 40. Re4 Qf3 41. Nh2 Qf5 42. Bxe7 ( 42. Kg2 Rf8 43. f3 Bf6$19 ) Kg8 43. f3 ( 43. R1e3 Qd5$19 ) Qh3$19 44. R1e2 ( 44. Kh1$19 ) Qg3+ 45. Rg2 Bxd4+$1 {a devastating blow} 46. Kh1 ( 46. Rxd4 {A deflection} Qe1+ {Theme: Double Attack} ) Qh3 47. Rgg4 ( 47. a5 Bc3$19 ) c5 48. h5 ( 48. Re1 {does not improve anything} Bf6 49. Rge4 Bxe7 50. Rxe7 Rxe7 51. Rxe7 Qxh4$19 ) Rb8 49. Re1 Be5 50. Rh4 Qf5 51. hxg6 hxg6 52. Re2 ( 52. Bxc5 {doesn't change the outcome of the game} Bg3 53. Rb4 Rc8$19 ( 53... Bxe1$6 {is clearly worse} 54. Rxb8+ Kh7 55. Rb7+ Kh8 56. Rb8+ Kg7 57. Rb7+ Kf6 58. Ng4+ Kg5 59. Be3+ Kh4 60. Kg2 Qc2+ 61. Nf2$15 ) ( 53... Qxc5$6 {is much worse} 54. Rxb8+ Bxb8 55. Re8+ Kf7 56. Rxb8$19 ) ) Rb1+ ( 52... Qb1+$5 {keeps an even firmer grip} 53. Kg2 Rb2 54. Rxb2 Qxb2+ 55. Kg1$19 ) 53. Kg2 Bd4 54. Ng4 ( 54. Rxd4 {no good, but what else?} cxd4 55. Ng4$19 ) Rg1+ 55. Kh2 ( 55. Kh3 {doesn't do any good} Qxf3+ 56. Kh2 Rh1# ) Qf4+ ( 55... Qf4+ 56. Kh3 Qg3# ) 0-1`;

const diagrams = [
  {
    ply: 6,
    fen: 'rnbqkb1r/ppp1p1pp/3p1n2/5p2/2PP4/5N2/PP2PPPP/RNBQKB1R w KQkq - 2 4',
  },
  {
    ply: 13,
    fen: 'rnbq1rk1/ppp1p1bp/3p1np1/5p2/2PP4/2N2NP1/PP2PPBP/R1BQ1RK1 b - - 5 7',
  },
];
```

On success, a TeX string is returned. Eg.
```tex
 \documentclass{article}
 \usepackage{xskak}
 \usepackage{multicol}
 \usepackage[a4paper]{geometry}
 \usepackage{parskip}
 \geometry{left=1.25cm,right=1.25cm,top=1.5cm,bottom=1.5cm,columnsep=1.2cm}
 \setlength{\parindent}{0pt}
 \title{Ibragimov, Ildar (2455) - Kramnik, Vladimir (2480)}
 \date{1991.??.??, Kherson}
 \author{URS-chJ}
 \begin{document}
 \begin{multicols}{2}
 \maketitle
 \newchessgame
 \textbf{1.} \textbf{d4} \newline A88: Dutch Defence: Leningrad System: 5 Nf3 0-0 6 0-0 d6 7 Nc3 c6 \par \textbf{1...}\textbf{d6} \textbf{2.}\textbf{c4} \textbf{f5} \textbf{3.}\textbf{Nf3} \textbf{Nf6} \par\chessboard[setfen=rnbqkb1r/ppp1p1pp/3p1n2/5p2/2PP4/5N2/PP2PPPP/RNBQKB1R w KQkq - 2 4]\par \textbf{4.}\textbf{g3} \textbf{g6} \textbf{5.}\textbf{Bg2} \textbf{Bg7} \textbf{6.}\textbf{O-O} \textbf{O-O} \textbf{7.}\textbf{Nc3} \par\chessboard[setfen=rnbq1rk1/ppp1p1bp/3p1np1/5p2/2PP4/2N2NP1/PP2PPBP/R1BQ1RK1 b - - 5 7]\par \textbf{7...}\textbf{Qe8} \textbf{8.}\textbf{b3} \textbf{Na6} \textbf{9.}\textbf{Ba3} \textbf{c6} \textbf{10.}\textbf{Qd3} \textbf{Rb8} \textbf{11.}\textbf{e4} \textbf{fxe4} \textbf{12.}\textbf{Nxe4} \textbf{Bf5} \textbf{13.}\textbf{Nxf6+} \textbf{Bxf6} \textbf{14.}\textbf{Qd2} \textbf{Nc7} \textbf{15.}\textbf{Rae1} \textbf{Qd7} \textbf{16.}\textbf{h4} \textbf{b5} \textbf{17.}\textbf{Re3} \textbf{bxc4} \textbf{18.}\textbf{bxc4} \textbf{Bh3} \textbf{19.}\textbf{Rfe1} \textbf{Bxg2} \newline last book move \par \textbf{20.}\textbf{Kxg2} \textbf{Qf5} \textbf{21.}\textbf{Re4} \textbf{Rbe8} \textbf{22.}\textbf{Rf4} \textbf{Qc8} \textbf{23.}\textbf{Qa5} \textbf{d5} \textbf{24.}\textbf{cxd5} \textbf{Nxd5} \textbf{25.}\textbf{Rfe4} \newline e7 seems the pivot of the position \par \textbf{25...}\textbf{Qf5} \textbf{26.}\textbf{Qd2} (26.Qxa7 Qxf3+ 27.Kxf3 Bxd4+ 28.Kg4 Bxa7 29.Bxe7 Rxf2 (...Rxe7 30.Rxe7 Bxf2 31.a4) (...Nxe7 30.Rxe7 Rxe7 31.Rxe7 Bxf2 32.a4)) \textbf{26...}\textbf{Bg7} \textbf{27.}\textbf{Nh2} \textbf{Rf7} \textbf{28.}\textbf{Bc5} \newline The white bishop on an outpost \par \textbf{28...}\textbf{Qd7} \textbf{29.}\textbf{a4} \textbf{Nf6} \textbf{30.}\textbf{Re5} \textbf{Nd5} \textbf{31.}\textbf{R5e4} (31.R5e2 Rb8) \textbf{31...}\textbf{Nf6} \textbf{32.}\textbf{Re5} \textbf{Kh8} (...Nd5 33.R5e2) \textbf{33.}\textbf{Kg1} \textbf{Nd5} \newline A valuable piece \par \textbf{34.}\textbf{R5e2} \textbf{a6} \textbf{35.}\textbf{Qd3} \textbf{Qh3} (...Ra8) \textbf{36.}\textbf{Nf3} (36.Qxa6 Ref8 37.Qa5 (37.Qxc6 Rxf2 38.Rxf2 Qxg3+ 39.Kh1 Rxf2 (...Qxf2 40.Rf1 Qa2 41.Rxf8+ Bxf8 42.Kg1)40.Qa8+ Bf8 41.Qxf8+ Rxf8 42.Re2 Rf2 43.Rxf2 Qxf2 44.Ng4 Qf1+ 45.Kh2 Nf4 46.Ne3 Qf2+ 47.Kh1 Qxh4+ 48.Kg1 Qg3+ 49.Kf1 Qxe3 50.Bb6 Qe2+ 51.Kg1 Qg2\#) (37.Bxe7 Rxf2 (...Nxe7 38.Rd1)38.Rxf2 Qxg3+ 39.Kh1 Rxf2 (...Qxf2 40.Re2 Qxd4 41.Bxf8 Qd1+ 42.Kg2 Nf4+ 43.Kf3)40.Qc8+ Bf8 41.Bf6+ Nxf6 42.Qxf8+ Ng8 43.Qxf2 Qxf2)) \textbf{36...}\textbf{Nf4} \newline Do you see the mate threat? \par \textbf{37.}\textbf{gxf4} \textbf{Rxf4} \newline The mate threat is Rg4 \par \textbf{38.}\textbf{Ne5} (38.Re4 Qg4+ 39.Kf1 Rxf3 40.Rxg4 Rxd3 41.Re6) \textbf{38...}\textbf{Rg4+} \newline keeping the advantage \par \textbf{39.}\textbf{Nxg4} \newline Theme: Deflection from d3 \par \textbf{39...}\textbf{Qxd3} \textbf{40.}\textbf{Re4} \textbf{Qf3} \textbf{41.}\textbf{Nh2} \textbf{Qf5} \textbf{42.}\textbf{Bxe7} (42.Kg2 Rf8 43.f3 Bf6) \textbf{42...}\textbf{Kg8} \textbf{43.}\textbf{f3} (43.R1e3 Qd5) \textbf{43...}\textbf{Qh3} \textbf{44.}\textbf{R1e2} (44.Kh1) \textbf{44...}\textbf{Qg3+} \textbf{45.}\textbf{Rg2} \textbf{Bxd4+} \newline a devastating blow \par \textbf{46.}\textbf{Kh1} (46.Rxd4 Qe1+) \textbf{46...}\textbf{Qh3} \textbf{47.}\textbf{Rgg4} (47.a5 Bc3) \textbf{47...}\textbf{c5} \textbf{48.}\textbf{h5} (48.Re1 Bf6 49.Rge4 Bxe7 50.Rxe7 Rxe7 51.Rxe7 Qxh4) \textbf{48...}\textbf{Rb8} \textbf{49.}\textbf{Re1} \textbf{Be5} \textbf{50.}\textbf{Rh4} \textbf{Qf5} \textbf{51.}\textbf{hxg6} \textbf{hxg6} \textbf{52.}\textbf{Re2} (52.Bxc5 Bg3 53.Rb4 Rc8 (...Bxe1 54.Rxb8+ Kh7 55.Rb7+ Kh8 56.Rb8+ Kg7 57.Rb7+ Kf6 58.Ng4+ Kg5 59.Be3+ Kh4 60.Kg2 Qc2+ 61.Nf2) (...Qxc5 54.Rxb8+ Bxb8 55.Re8+ Kf7 56.Rxb8)) \textbf{52...}\textbf{Rb1+} (...Qb1+ 53.Kg2 Rb2 54.Rxb2 Qxb2+ 55.Kg1) \textbf{53.}\textbf{Kg2} \textbf{Bd4} \textbf{54.}\textbf{Ng4} (54.Rxd4 cxd4 55.Ng4) \textbf{54...}\textbf{Rg1+} \textbf{55.}\textbf{Kh2} (55.Kh3 Qxf3+ 56.Kh2 Rh1\#) \textbf{55...}\textbf{Qf4+} (...Qf4+ 56.Kh3 Qg3\#) \textbf{0-1}
 \end{multicols}
 \end{document}
```

If you are using a custom TexLive server to generate a PDF from a string, you must ensure that the following packages are installed:

- parskip 
- pgf 
- chessboard 
- etoolbox 
- ifmtarg 
- xifthen 
- skaknew 
- lambda-lists 
- xkeyval 
- chessfss 
- skak 
- xskak

A custom Docker image of a TexLive with these packages installed is available [here](https://hub.docker.com/repository/docker/owenrees/node-xskak/general).