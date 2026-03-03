open OUnit2
open Pgn_logic
open Ast

let ae expected actual = assert_equal ~printer:(fun x -> x) expected actual

let diagram_data =
  MoveMap.empty
  |> MoveMap.add 5
       "rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 3"
  |> MoveMap.add 6
       "rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 3"
  |> MoveMap.add 10
       "r1bqkbnr/pp1ppppp/2n5/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 3 5"
  |> MoveMap.add 15
       "r1bqkb1r/pp1ppppp/2n5/2p5/4P3/2N2N2/PPPP1PPP/R1BQKB1R b KQkq - 5 7"

let test_basic_pgn_to_tex _ctxt =
  let filename = "pgn_examples/1.pgn" in
  let ic = In_channel.open_text filename in
  let input_string = In_channel.input_all ic in
  let actual = Pgn2tex.to_tex input_string ~diagram_data ~clock:false in
  let expected =
    {|\title{URS-chJ}
\author{Ibragimov, Ildar (2455)\\Kramnik, Vladimir (2480)}
\date{1991.??.??, Kherson}\maketitle
\newchessgame
\textbf{1.} \textbf{d4} \newline A88: Dutch Defence: Leningrad System: 5 Nf3 0-0 6 0-0 d6 7 Nc3 c6\par \textbf{\ldots{}d6} \textbf{2.} \textbf{c4} \textbf{f5} \textbf{3.} \textbf{Nf3}
\par\nobreak\medskip\chessboard[setfen=rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 3, vmargin=false]\par\medskip
 \textbf{\ldots{}}\textbf{Nf6}
\par\nobreak\medskip\chessboard[setfen=rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 3, vmargin=false]\par\medskip
 \textbf{4.} \textbf{g3} \textbf{g6} \textbf{5.} \textbf{Bg2} \textbf{Bg7}
\par\nobreak\medskip\chessboard[setfen=r1bqkbnr/pp1ppppp/2n5/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 3 5, vmargin=false]\par\medskip
 \textbf{6.} \textbf{O-O} \textbf{O-O} \textbf{7.} \textbf{Nc3} \textbf{Qe8} \textbf{8.} \textbf{b3}
\par\nobreak\medskip\chessboard[setfen=r1bqkb1r/pp1ppppp/2n5/2p5/4P3/2N2N2/PPPP1PPP/R1BQKB1R b KQkq - 5 7, vmargin=false]\par\medskip
 \textbf{\ldots{}}\textbf{Na6} \textbf{9.} \textbf{Ba3} \textbf{c6} \textbf{10.} \textbf{Qd3} \textbf{Rb8} \textbf{11.} \textbf{e4} \textbf{fxe4} \textbf{12.} \textbf{Nxe4} \textbf{Bf5} \textbf{13.} \textbf{Nxf6+} \textbf{Bxf6} \textbf{14.} \textbf{Qd2} \textbf{Nc7} \textbf{15.} \textbf{Rae1} \textbf{Qd7} \textbf{16.} \textbf{h4} \textbf{b5} \textbf{17.} \textbf{Re3} \textbf{bxc4} \textbf{18.} \textbf{bxc4} \textbf{Bh3} \textbf{19.} \textbf{Rfe1} \textbf{Bxg2} \newline last book move\par \textbf{20.} \textbf{Kxg2} \textbf{Qf5} \textbf{21.} \textbf{Re4} \textbf{Rbe8} \textbf{22.} \textbf{Rf4} \textbf{Qc8} \textbf{23.} \textbf{Qa5} \textbf{d5} \textbf{24.} \textbf{cxd5} \textbf{Nxd5} \textbf{25.} \textbf{Rfe4} \newline e7 seems the pivot of the position\par \textbf{\ldots{}Qf5} \textbf{26.} \textbf{Qd2} ( 26. Qxa7  ??{} taking the pawn is naive Qxf3+ Annihilates a defender: f3 27. Kxf3 Bxd4+ 28. Kg4 Bxa7 29. Bxe7 Rxf2  -+{} ( 29... Rxe7 30. Rxe7 Bxf2 31. a4  -+{} ) ( 29... Nxe7  ?!{} 30. Rxe7 Rxe7 31. Rxe7 Bxf2 32. a4  -+{} ) ) \textbf{Bg7} \textbf{27.} \textbf{Nh2} \textbf{Rf7} \textbf{28.} \textbf{Bc5} \newline The white bishop on an outpost\par \textbf{\ldots{}Qd7} \textbf{29.} \textbf{a4} \textbf{Nf6} \textbf{30.} \textbf{Re5} \textbf{Nd5} \textbf{31.} \textbf{R5e4} ( 31. R5e2 Rb8  \wbetter{} ) \textbf{Nf6}  {} \textbf{32.} \textbf{Re5} \textbf{Kh8} ( 32... Nd5 33. R5e2  \wbetter{} ) \textbf{33.} \textbf{Kg1} \textbf{Nd5} \newline A valuable piece\par \textbf{34.} \textbf{R5e2} \textbf{a6} \textbf{35.} \textbf{Qd3} \textbf{Qh3} ( 35... Ra8  \wbetter{} ) \textbf{36.} \textbf{Nf3} ( 36. Qxa6 Ref8 37. Qa5  \wbetter{} ( 37. Qxc6 Rxf2 38. Rxf2 Qxg3+ 39. Kh1 Rxf2 ( 39... Qxf2  ?!{} 40. Rf1 Qa2 41. Rxf8+ Bxf8 42. Kg1  {} ) 40. Qa8+ Bf8 41. Qxf8+ Rxf8 42. Re2 Rf2 43. Rxf2 Qxf2 44. Ng4 Qf1+ 45. Kh2 Nf4 46. Ne3 Qf2+ 47. Kh1 Qxh4+ 48. Kg1 Qg3+ 49. Kf1 Qxe3 50. Bb6 Qe2+ 51. Kg1 Qg2\# ) ( 37. Bxe7  ??{} White will choke on that pawn Rxf2 ( 37... Nxe7  ?!{} 38. Rd1  -+{} ) 38. Rxf2 Qxg3+ 39. Kh1 Rxf2 ( 39... Qxf2 40. Re2 Qxd4 41. Bxf8 Qd1+ 42. Kg2 Nf4+ 43. Kf3  {} ) 40. Qc8+ Bf8 41. Bf6+ Nxf6 42. Qxf8+ Ng8 43. Qxf2 Qxf2  -+{} ) ) \textbf{Nf4}  \bbetter{} \newline Do you see the mate threat?\par \textbf{37.} \textbf{gxf4} \textbf{Rxf4} \newline The mate threat is Rg4\par \textbf{38.} \textbf{Ne5} ( 38. Re4  !?{} is worthy of consideration Qg4+ 39. Kf1 Rxf3 40. Rxg4 Rxd3 41. Re6  \bbetter{} ) \textbf{Rg4+}  !{}  \ensuremath{\mp}{} \newline keeping the advantage\par \textbf{39.} \textbf{Nxg4} \newline Theme: Deflection from d3\par \textbf{\ldots{}Qxd3} \textbf{40.} \textbf{Re4} \textbf{Qf3} \textbf{41.} \textbf{Nh2} \textbf{Qf5} \textbf{42.} \textbf{Bxe7} ( 42. Kg2 Rf8 43. f3 Bf6  -+{} ) \textbf{Kg8} \textbf{43.} \textbf{f3} ( 43. R1e3 Qd5  -+{} ) \textbf{Qh3}  -+{} \textbf{44.} \textbf{R1e2} ( 44. Kh1  -+{} ) \textbf{Qg3+} \textbf{45.} \textbf{Rg2} \textbf{Bxd4+}  !{} \newline a devastating blow\par \textbf{46.} \textbf{Kh1} ( 46. Rxd4 A deflection Qe1+ Theme: Double Attack ) \textbf{Qh3} \textbf{47.} \textbf{Rgg4} ( 47. a5 Bc3  -+{} ) \textbf{c5} \textbf{48.} \textbf{h5} ( 48. Re1 does not improve anything Bf6 49. Rge4 Bxe7 50. Rxe7 Rxe7 51. Rxe7 Qxh4  -+{} ) \textbf{Rb8} \textbf{49.} \textbf{Re1} \textbf{Be5} \textbf{50.} \textbf{Rh4} \textbf{Qf5} \textbf{51.} \textbf{hxg6} \textbf{hxg6} \textbf{52.} \textbf{Re2} ( 52. Bxc5 doesn't change the outcome of the game Bg3 53. Rb4 Rc8  -+{} ( 53... Bxe1  ?!{} is clearly worse 54. Rxb8+ Kh7 55. Rb7+ Kh8 56. Rb8+ Kg7 57. Rb7+ Kf6 58. Ng4+ Kg5 59. Be3+ Kh4 60. Kg2 Qc2+ 61. Nf2  \bbetter{} ) ( 53... Qxc5  ?!{} is much worse 54. Rxb8+ Bxb8 55. Re8+ Kf7 56. Rxb8  -+{} ) ) \textbf{Rb1+} ( 52... Qb1+  !?{} keeps an even firmer grip 53. Kg2 Rb2 54. Rxb2 Qxb2+ 55. Kg1  -+{} ) \textbf{53.} \textbf{Kg2} \textbf{Bd4} \textbf{54.} \textbf{Ng4} ( 54. Rxd4 no good, but what else? cxd4 55. Ng4  -+{} ) \textbf{Rg1+} \textbf{55.} \textbf{Kh2} ( 55. Kh3 doesn't do any good Qxf3+ 56. Kh2 Rh1\# ) \textbf{Qf4+} ( 55... Qf4+ 56. Kh3 Qg3\# ) \textbf{0-1}|}
  in
  ae expected actual;
  close_in ic

let test_pgn_with_clock_to_tex _ctxt =
  let filename = "pgn_examples/2.pgn" in
  let ic = In_channel.open_text filename in
  let input_string = In_channel.input_all ic in
  let actual = Pgn2tex.to_tex input_string ~diagram_data ~clock:true in
  let expected =
    {|\title{Casual Rapid game}
\author{montillo2015 (1919)\\reassessyourchess (1869)}
\date{2023.12.03, https://lichess.org/9Z0taHcG}\maketitle
\newchessgame
\textbf{1.} \textbf{d4} \textbf{1...} \textbf{Nf6} \textbf{2.} \textbf{Nf3} \textbf{2...} \textbf{d5} \textbf{3.} \textbf{e3}\par\medskip\noindent\begin{minipage}{\linewidth}0:10:01\par\nopagebreak\smallskip
\chessboard[setfen=rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 3, vmargin=false]\par\nopagebreak\vspace{1em}
0:10:00\end{minipage}\par\medskip \textbf{3...} \textbf{e6}\par\medskip\noindent\begin{minipage}{\linewidth}0:10:01\par\nopagebreak\smallskip
\chessboard[setfen=rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 3, vmargin=false]\par\nopagebreak\vspace{1em}
0:10:01\end{minipage}\par\medskip \newline D05 Queen's Pawn Game: Colle System\par \textbf{4.} \textbf{a3} \textbf{4...} \textbf{c5} \textbf{5.} \textbf{c4} \textbf{5...} \textbf{Nc6}\par\medskip\noindent\begin{minipage}{\linewidth}0:10:02\par\nopagebreak\smallskip
\chessboard[setfen=r1bqkbnr/pp1ppppp/2n5/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 3 5, vmargin=false]\par\nopagebreak\vspace{1em}
0:10:02\end{minipage}\par\medskip \textbf{6.} \textbf{dxc5} \textbf{6...} \textbf{Bxc5} \textbf{7.} \textbf{b4} \textbf{7...} \textbf{Be7} \textbf{8.} \textbf{Bb2}\par\medskip\noindent\begin{minipage}{\linewidth}0:10:00\par\nopagebreak\smallskip
\chessboard[setfen=r1bqkb1r/pp1ppppp/2n5/2p5/4P3/2N2N2/PPPP1PPP/R1BQKB1R b KQkq - 5 7, vmargin=false]\par\nopagebreak\vspace{1em}
0:10:03\end{minipage}\par\medskip \textbf{8...} \textbf{dxc4} \textbf{9.} \textbf{Qxd8+} \textbf{9...} \textbf{Nxd8} \textbf{10.} \textbf{Bxc4} \textbf{10...} \textbf{O-O} \textbf{11.} \textbf{O-O} \textbf{11...} \textbf{a6} \textbf{12.} \textbf{Nc3} \textbf{12...} \textbf{b5} \textbf{13.} \textbf{Be2} \textbf{13...} \textbf{Bb7} \textbf{14.} \textbf{Nd4} \textbf{14...} \textbf{Ne4} \textbf{15.} \textbf{Nxe4} \textbf{15...} \textbf{Bxe4} \textbf{16.} \textbf{Bf3} \textbf{16...} \textbf{Bxf3} \textbf{17.} \textbf{Nxf3} \textbf{17...} \textbf{Nc6} \textbf{18.} \textbf{Rac1} \textbf{18...} \textbf{Rac8} \textbf{19.} \textbf{Rfd1} \textbf{19...} \textbf{Rfd8} \textbf{20.} \textbf{Rxd8+} \textbf{20...} \textbf{Rxd8} \textbf{21.} \textbf{g3} \textbf{21...} \textbf{Nb8} \textbf{22.} \textbf{Rc7} \textbf{22...} \textbf{Bd6} \textbf{23.} \textbf{Rc2} \textbf{23...} \textbf{f6} \textbf{24.} \textbf{Kg2} \textbf{24...} \textbf{e5} \textbf{25.} \textbf{h4} \textbf{25...} \textbf{e4} \textbf{26.} \textbf{Nd4} \textbf{26...} \textbf{Kf7} \textbf{27.} \textbf{Nf5} \textbf{27...} \textbf{Nd7} \textbf{28.} \textbf{Nxd6+} \newline Black resigns.\par \textbf{1-0}|}
  in
  ae expected actual;
  close_in ic

let test_pgn_with_unsupported_text _ctxt =
  let filename = "pgn_examples/4.pgn" in
  let ic = In_channel.open_text filename in
  let input_string = In_channel.input_all ic in
  let actual = Pgn2tex.to_tex input_string ~diagram_data ~clock:true in
  (* let expected =
    {|\title{Casual Rapid game}
\author{montillo2015 (1919) vs. reassessyourchess (1869)}
\date{2023.12.03, https://lichess.org/9Z0taHcG}\maketitle
\newchessgame
\textbf{1.} \textbf{d4} \textbf{1...} \textbf{Nf6} \textbf{2.} \textbf{Nf3} \textbf{2...} \textbf{d5} \textbf{3.} \textbf{e3}\par\nobreak 0:10:01\par\nobreak\chessboard[setfen=rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 3, vmargin=false]\par\medskip\nobreak\ 0:10:00\par \textbf{3...} \textbf{e6}\par\nobreak 0:10:01\par\nobreak\chessboard[setfen=rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 3, vmargin=false]\par\medskip\nobreak\ 0:10:01\par \newline D05 Queen's Pawn Game: Colle System\par \textbf{4.} \textbf{a3} \textbf{4...} \textbf{c5} \textbf{5.} \textbf{c4} \textbf{5...} \textbf{Nc6}\par\nobreak 0:10:02\par\nobreak\chessboard[setfen=rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 3, vmargin=false]\par\medskip\nobreak\ 0:10:02\par \textbf{6.} \textbf{dxc5} \textbf{6...} \textbf{Bxc5} \textbf{7.} \textbf{b4} \textbf{7...} \textbf{Be7} \textbf{8.} \textbf{Bb2}\par\nobreak 0:10:00\par\nobreak\chessboard[setfen=rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 3, vmargin=false]\par\medskip\nobreak\ 0:10:03\par \textbf{8...} \textbf{dxc4} \textbf{9.} \textbf{Qxd8+} \textbf{9...} \textbf{Nxd8} \textbf{10.} \textbf{Bxc4} \textbf{10...} \textbf{O-O} \textbf{11.} \textbf{O-O} \textbf{11...} \textbf{a6} \textbf{12.} \textbf{Nc3} \textbf{12...} \textbf{b5} \textbf{13.} \textbf{Be2} \textbf{13...} \textbf{Bb7} \textbf{14.} \textbf{Nd4} \textbf{14...} \textbf{Ne4} \textbf{15.} \textbf{Nxe4} \textbf{15...} \textbf{Bxe4} \textbf{16.} \textbf{Bf3} \textbf{16...} \textbf{Bxf3} \textbf{17.} \textbf{Nxf3} \textbf{17...} \textbf{Nc6} \textbf{18.} \textbf{Rac1} \textbf{18...} \textbf{Rac8} \textbf{19.} \textbf{Rfd1} \textbf{19...} \textbf{Rfd8} \textbf{20.} \textbf{Rxd8+} \textbf{20...} \textbf{Rxd8} \textbf{21.} \textbf{g3} \textbf{21...} \textbf{Nb8} \textbf{22.} \textbf{Rc7} \textbf{22...} \textbf{Bd6} \textbf{23.} \textbf{Rc2} \textbf{23...} \textbf{f6} \textbf{24.} \textbf{Kg2} \textbf{24...} \textbf{e5} \textbf{25.} \textbf{h4} \textbf{25...} \textbf{e4} \textbf{26.} \textbf{Nd4} \textbf{26...} \textbf{Kf7} \textbf{27.} \textbf{Nf5} \textbf{27...} \textbf{Nd7} \textbf{28.} \textbf{Nxd6+} \newline Black resigns.\par \textbf{1-0}|} *)
  (* in
  ae expected actual; *)
  print_endline actual;
  close_in ic

let test_pgn_with_custom_headers _ctxt =
  let filename = "pgn_examples/7.pgn" in
  let ic = In_channel.open_text filename in
  let input_string = In_channel.input_all ic in
  let actual = Pgn2tex.to_tex input_string ~diagram_data ~clock:false in
  (* let expected =
    {|\title{Casual Rapid game}
\author{montillo2015 (1919) vs. reassessyourchess (1869)}
\date{2023.12.03, https://lichess.org/9Z0taHcG}\maketitle
\newchessgame
\textbf{1.} \textbf{d4} \textbf{1...} \textbf{Nf6} \textbf{2.} \textbf{Nf3} \textbf{2...} \textbf{d5} \textbf{3.} \textbf{e3}\par\nobreak 0:10:01\par\nobreak\chessboard[setfen=rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 3, vmargin=false]\par\medskip\nobreak\ 0:10:00\par \textbf{3...} \textbf{e6}\par\nobreak 0:10:01\par\nobreak\chessboard[setfen=rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 3, vmargin=false]\par\medskip\nobreak\ 0:10:01\par \newline D05 Queen's Pawn Game: Colle System\par \textbf{4.} \textbf{a3} \textbf{4...} \textbf{c5} \textbf{5.} \textbf{c4} \textbf{5...} \textbf{Nc6}\par\nobreak 0:10:02\par\nobreak\chessboard[setfen=rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 3, vmargin=false]\par\medskip\nobreak\ 0:10:02\par \textbf{6.} \textbf{dxc5} \textbf{6...} \textbf{Bxc5} \textbf{7.} \textbf{b4} \textbf{7...} \textbf{Be7} \textbf{8.} \textbf{Bb2}\par\nobreak 0:10:00\par\nobreak\chessboard[setfen=rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 3, vmargin=false]\par\medskip\nobreak\ 0:10:03\par \textbf{8...} \textbf{dxc4} \textbf{9.} \textbf{Qxd8+} \textbf{9...} \textbf{Nxd8} \textbf{10.} \textbf{Bxc4} \textbf{10...} \textbf{O-O} \textbf{11.} \textbf{O-O} \textbf{11...} \textbf{a6} \textbf{12.} \textbf{Nc3} \textbf{12...} \textbf{b5} \textbf{13.} \textbf{Be2} \textbf{13...} \textbf{Bb7} \textbf{14.} \textbf{Nd4} \textbf{14...} \textbf{Ne4} \textbf{15.} \textbf{Nxe4} \textbf{15...} \textbf{Bxe4} \textbf{16.} \textbf{Bf3} \textbf{16...} \textbf{Bxf3} \textbf{17.} \textbf{Nxf3} \textbf{17...} \textbf{Nc6} \textbf{18.} \textbf{Rac1} \textbf{18...} \textbf{Rac8} \textbf{19.} \textbf{Rfd1} \textbf{19...} \textbf{Rfd8} \textbf{20.} \textbf{Rxd8+} \textbf{20...} \textbf{Rxd8} \textbf{21.} \textbf{g3} \textbf{21...} \textbf{Nb8} \textbf{22.} \textbf{Rc7} \textbf{22...} \textbf{Bd6} \textbf{23.} \textbf{Rc2} \textbf{23...} \textbf{f6} \textbf{24.} \textbf{Kg2} \textbf{24...} \textbf{e5} \textbf{25.} \textbf{h4} \textbf{25...} \textbf{e4} \textbf{26.} \textbf{Nd4} \textbf{26...} \textbf{Kf7} \textbf{27.} \textbf{Nf5} \textbf{27...} \textbf{Nd7} \textbf{28.} \textbf{Nxd6+} \newline Black resigns.\par \textbf{1-0}|} *)
  (* in
  ae expected actual; *)
  print_endline actual;
  close_in ic

let test_pgn_with_different_unsupported_text _ctxt =
  let filename = "pgn_examples/10.pgn" in
  let ic = In_channel.open_text filename in
  let input_string = In_channel.input_all ic in
  let actual = Pgn2tex.to_tex input_string ~diagram_data ~clock:false in
  (* let expected =
    {|\title{Casual Rapid game}
\author{montillo2015 (1919) vs. reassessyourchess (1869)}
\date{2023.12.03, https://lichess.org/9Z0taHcG}\maketitle
\newchessgame
\textbf{1.} \textbf{d4} \textbf{1...} \textbf{Nf6} \textbf{2.} \textbf{Nf3} \textbf{2...} \textbf{d5} \textbf{3.} \textbf{e3}\par\nobreak 0:10:01\par\nobreak\chessboard[setfen=rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 3, vmargin=false]\par\medskip\nobreak\ 0:10:00\par \textbf{3...} \textbf{e6}\par\nobreak 0:10:01\par\nobreak\chessboard[setfen=rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 3, vmargin=false]\par\medskip\nobreak\ 0:10:01\par \newline D05 Queen's Pawn Game: Colle System\par \textbf{4.} \textbf{a3} \textbf{4...} \textbf{c5} \textbf{5.} \textbf{c4} \textbf{5...} \textbf{Nc6}\par\nobreak 0:10:02\par\nobreak\chessboard[setfen=rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 3, vmargin=false]\par\medskip\nobreak\ 0:10:02\par \textbf{6.} \textbf{dxc5} \textbf{6...} \textbf{Bxc5} \textbf{7.} \textbf{b4} \textbf{7...} \textbf{Be7} \textbf{8.} \textbf{Bb2}\par\nobreak 0:10:00\par\nobreak\chessboard[setfen=rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 3, vmargin=false]\par\medskip\nobreak\ 0:10:03\par \textbf{8...} \textbf{dxc4} \textbf{9.} \textbf{Qxd8+} \textbf{9...} \textbf{Nxd8} \textbf{10.} \textbf{Bxc4} \textbf{10...} \textbf{O-O} \textbf{11.} \textbf{O-O} \textbf{11...} \textbf{a6} \textbf{12.} \textbf{Nc3} \textbf{12...} \textbf{b5} \textbf{13.} \textbf{Be2} \textbf{13...} \textbf{Bb7} \textbf{14.} \textbf{Nd4} \textbf{14...} \textbf{Ne4} \textbf{15.} \textbf{Nxe4} \textbf{15...} \textbf{Bxe4} \textbf{16.} \textbf{Bf3} \textbf{16...} \textbf{Bxf3} \textbf{17.} \textbf{Nxf3} \textbf{17...} \textbf{Nc6} \textbf{18.} \textbf{Rac1} \textbf{18...} \textbf{Rac8} \textbf{19.} \textbf{Rfd1} \textbf{19...} \textbf{Rfd8} \textbf{20.} \textbf{Rxd8+} \textbf{20...} \textbf{Rxd8} \textbf{21.} \textbf{g3} \textbf{21...} \textbf{Nb8} \textbf{22.} \textbf{Rc7} \textbf{22...} \textbf{Bd6} \textbf{23.} \textbf{Rc2} \textbf{23...} \textbf{f6} \textbf{24.} \textbf{Kg2} \textbf{24...} \textbf{e5} \textbf{25.} \textbf{h4} \textbf{25...} \textbf{e4} \textbf{26.} \textbf{Nd4} \textbf{26...} \textbf{Kf7} \textbf{27.} \textbf{Nf5} \textbf{27...} \textbf{Nd7} \textbf{28.} \textbf{Nxd6+} \newline Black resigns.\par \textbf{1-0}|} *)
  (* in
  ae expected actual; *)
  print_endline actual;
  close_in ic

let suite =
  "pgn2tex tests"
  >::: [
         "basic_pgn_to_tex" >:: test_basic_pgn_to_tex;
         "pgn_with_clock_to_tex" >:: test_pgn_with_clock_to_tex;
         (* "pgn_with_unsupported_text" >:: test_pgn_with_unsupported_text; *)
         (* "pgn_with_custom_headers" >:: test_pgn_with_custom_headers; *)
         "pgn_with_different_unsupported_text"
         >:: test_pgn_with_different_unsupported_text;
       ]

let () = run_test_tt_main suite
