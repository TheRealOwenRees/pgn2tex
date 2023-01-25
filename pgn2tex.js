const { parse } = require('@mliebelt/pgn-parser');

// PGN for testing purposes
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

1. d4 {A88: Dutch Defence: Leningrad System: 5 Nf3 0-0 6 0-0 d6 7 Nc3 c6} 1...
d6 2. c4 f5 3. Nf3 Nf6 4. g3 g6 5. Bg2 Bg7 6. O-O O-O 7. Nc3 Qe8 8. b3 Na6 9.
Ba3 c6 10. Qd3 Rb8 11. e4 fxe4 12. Nxe4 Bf5 13. Nxf6+ Bxf6 14. Qd2 Nc7 15. Rae1
Qd7 16. h4 b5 17. Re3 bxc4 18. bxc4 Bh3 19. Rfe1 19... Bxg2 {last book move}
20. Kxg2 Qf5 21. Re4 Rbe8 22. Rf4 Qc8 23. Qa5 d5 24. cxd5 Nxd5 25. Rfe4 {
e7 seems the pivot of the position} 25... Qf5 26. Qd2 (26. Qxa7 $4 {
taking the pawn is naive} 26... Qxf3+ {Annihilates a defender: f3} 27. Kxf3
Bxd4+ 28. Kg4 Bxa7 29. Bxe7 29... Rxf2 $19 (29... Rxe7 30. Rxe7 Bxf2 31. a4 $19
) (29... Nxe7 $6 30. Rxe7 Rxe7 31. Rxe7 Bxf2 32. a4 $19)) 26... Bg7 27. Nh2 Rf7
28. Bc5 {The white bishop on an outpost} 28... Qd7 29. a4 Nf6 30. Re5 Nd5 31.
R5e4 (31. R5e2 31... Rb8 $14) 31... Nf6 $11 32. Re5 Kh8 (32... Nd5 33. R5e2 $14
) 33. Kg1 33... Nd5 {A valuable piece} 34. R5e2 a6 35. Qd3 Qh3 (35... Ra8 $14)
36. Nf3 (36. Qxa6 36... Ref8 37. Qa5 $14 (37. Qxc6 Rxf2 38. Rxf2 Qxg3+ 39. Kh1
Rxf2 (39... Qxf2 $6 40. Rf1 Qa2 41. Rxf8+ Bxf8 42. Kg1 $11) 40. Qa8+ Bf8 41.
Qxf8+ Rxf8 42. Re2 Rf2 43. Rxf2 Qxf2 44. Ng4 Qf1+ 45. Kh2 Nf4 46. Ne3 Qf2+ 47.
Kh1 Qxh4+ 48. Kg1 Qg3+ 49. Kf1 Qxe3 50. Bb6 Qe2+ 51. Kg1 Qg2#) (37. Bxe7 $4 {
White will choke on that pawn} 37... Rxf2 (37... Nxe7 $6 38. Rd1 $19) 38. Rxf2
Qxg3+ 39. Kh1 Rxf2 (39... Qxf2 40. Re2 Qxd4 41. Bxf8 Qd1+ 42. Kg2 Nf4+ 43. Kf3
$11) 40. Qc8+ Bf8 41. Bf6+ Nxf6 42. Qxf8+ Ng8 43. Qxf2 43... Qxf2 $19)) 36...
Nf4 $15 {Do you see the mate threat?} 37. gxf4 37... Rxf4 {
The mate threat is Rg4} 38. Ne5 (38. Re4 $5 {is worthy of consideration} 38...
Qg4+ 39. Kf1 Rxf3 40. Rxg4 Rxd3 41. Re6 $15) 38... Rg4+ $1 $17 {
keeping the advantage} 39. Nxg4 {Theme: Deflection from d3} 39... Qxd3 40. Re4
Qf3 41. Nh2 Qf5 42. Bxe7 (42. Kg2 Rf8 43. f3 43... Bf6 $19) 42... Kg8 43. f3 (
43. R1e3 43... Qd5 $19) 43... Qh3 $19 44. R1e2 (44. Kh1 $19) 44... Qg3+ 45. Rg2
45... Bxd4+ $1 {a devastating blow} 46. Kh1 (46. Rxd4 {A deflection} 46... Qe1+
{Theme: Double Attack}) 46... Qh3 47. Rgg4 (47. a5 47... Bc3 $19) 47... c5 48.
h5 (48. Re1 {does not improve anything} 48... Bf6 49. Rge4 Bxe7 50. Rxe7 Rxe7
51. Rxe7 51... Qxh4 $19) 48... Rb8 49. Re1 Be5 50. Rh4 Qf5 51. hxg6 hxg6 52.
Re2 (52. Bxc5 {doesn't change the outcome of the game} 52... Bg3 53. Rb4 53...
Rc8 $19 (53... Bxe1 $6 {is clearly worse} 54. Rxb8+ Kh7 55. Rb7+ Kh8 56. Rb8+
Kg7 57. Rb7+ Kf6 58. Ng4+ Kg5 59. Be3+ Kh4 60. Kg2 Qc2+ 61. Nf2 $15) (53...
Qxc5 $6 {is much worse} 54. Rxb8+ Bxb8 55. Re8+ Kf7 56. Rxb8 $19)) 52... Rb1+ (
52... Qb1+ $5 {keeps an even firmer grip} 53. Kg2 Rb2 54. Rxb2 Qxb2+ 55. Kg1
$19) 53. Kg2 Bd4 54. Ng4 (54. Rxd4 {no good, but what else?} 54... cxd4 55. Ng4
$19) 54... Rg1+ 55. Kh2 (55. Kh3 {doesn't do any good} 55... Qxf3+ 56. Kh2 Rh1#
) 55... Qf4+ (55... Qf4+ 56. Kh3 Qg3#) 0-1`;

const game = parse(pgn);

const header = game[0].tags;
const { moves } = game[0];

// write variations to string, adding move numbers and ...
const writeVariations = (move, index) => {
  let result = '';
  if (move.turn === 'b' && index === 0) result += '...';
  if (move.turn === 'w') result += `${move.moveNumber}.`;
  result += `${move.notation.notation} `;
  return result;
};

// initial tex to setup the document
const texStart = `\\documentclass{article}
\\usepackage{xskak}
\\usepackage{multicol}
\\usepackage[a4paper]{geometry}
\\usepackage{parskip}
\\geometry{left=1.25cm,right=1.25cm,top=1.5cm,bottom=1.5cm,columnsep=1.2cm}
\\setlength{\\parindent}{0pt} 
\\title{${header.White} (${header.WhiteElo}) - ${header.Black} (${header.BlackElo})}
\\date{${header.Date.value}, ${header.Site}}
\\author{${header.Event}}
\\begin{document}
\\begin{multicols}{2}
\\maketitle
\\newchessgame`;

// closing tex
const texEnd = `\n\\end{multicols}
\\end{document}`;

// build tex for the moves/comments/diagrams
const moveText = (diagrams) => {
  let moveStr = '';
  moves.forEach((move, index) => {
    // add numbers to move pairs
    if (move.turn === 'w') moveStr += `\\textbf{${move.moveNumber}.}`;
    // add move to string
    moveStr += `\\textbf{${move.notation.notation}} `;
    // add comments after move - TODO add comments before as well
    if (move.commentAfter) {
      moveStr += `\\newline ${move.commentAfter.trim()} \\par `;
      if (move.turn === 'w') moveStr += `\\textbf{${move.moveNumber}...}`;
    }
    // display chessboard diagram at ply - object (ply/fen) to be passed as function parameter
    const diagramExists = diagrams.find((x) => x.ply === index + 1);
    if (diagramExists) {
      moveStr += `\\par\\chessboard[setfen=${diagramExists.fen}]\\par `;
      // TODO check if the diagram was at the last move
      // add ...dots if it is black to move next when resuming mainline
      if (move.turn === 'w') moveStr += `\\textbf{${move.moveNumber}...}`;
    }
    // Variations - TODO comments
    let variationString = '('; // with starting parenthesis
    // variation depth 1
    if (move.variations.length > 0) {
      move.variations.forEach((variationDepth1) => {
        variationDepth1.forEach((moveDepth1, indexDepth1) => {
          variationString += writeVariations(moveDepth1, indexDepth1);
          // variation depth 2
          if (moveDepth1.variations.length > 0) {
            moveDepth1.variations.forEach((variationDepth2) => {
              variationString += '(';
              variationDepth2.forEach((moveDepth2, indexDepth2) => {
                variationString += writeVariations(moveDepth2, indexDepth2);
                // variation depth 3
                if (moveDepth2.variations.length > 0) {
                  moveDepth2.variations.forEach((variationDepth3) => {
                    variationString += '(';
                    variationDepth3.forEach((moveDepth3, indexDepth3) => {
                      variationString += writeVariations(moveDepth3, indexDepth3);
                    });
                    variationString = `${variationString.trim()}) `;
                  });
                }
              });
              variationString = `${variationString.trim()}) `;
            });
          }
        });
        variationString = `${variationString.trim()}`;
      });
      moveStr += `${variationString.trim()}) `; // with ending parenthesis
      if (move.turn === 'w') moveStr += `\\textbf{${move.moveNumber}...}`;
    }
  });
  // end of moveStr
  moveStr += `\\textbf{${header.Result}}`;
  return moveStr;
};

// ply numbers + FEN where diagrams should be displayed
const diagrams = [
  {
    ply: 3,
    fen: 'r4rk1/5pbp/2p1p1p1/pq6/8/1P2B3/R4PPP/3QR1K1 w - - 2 23',
  },
  {
    ply: 10,
    fen: 'r4rk1/5pbp/2p1p1p1/pq6/8/1P2B3/R4PPP/3QR1K1 w - - 2 23',
  },
  {
    ply: 30,
    fen: 'r4rk1/5pbp/2p1p1p1/pq6/8/1P2B3/R4PPP/3QR1K1 w - - 2 23',
  },
  {
    ply: 45,
    fen: 'r4rk1/5pbp/2p1p1p1/pq6/8/1P2B3/R4PPP/3QR1K1 w - - 2 23',
  },
];

const texOutput = texStart + moveText(diagrams) + texEnd;

console.log(texOutput);
