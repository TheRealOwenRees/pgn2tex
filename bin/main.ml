open Js_of_ocaml
open Pgn_logic

let parse_diagram_json json_str =
  let js_json_str = Js.string json_str in
  let js_obj = Js._JSON##parse js_json_str in
  let keys = Js.object_keys js_obj |> Js.to_array |> Array.to_list in

  List.fold_left
    (fun acc js_key ->
      let key_str = Js.to_string js_key in
      let js_value = Js.Unsafe.get js_obj js_key in
      let value_str = Js.to_string js_value in

      match int_of_string_opt key_str with
      | Some k -> Pgn2tex.MoveMap.add k value_str acc
      | None -> acc)
    Pgn2tex.MoveMap.empty keys

let convert_js pgn_js diagram_json_js =
  let pgn = Js.to_string pgn_js in
  let json_str = Js.to_string diagram_json_js in

  let diagram_data =
    if json_str = "" || json_str = "{}" then Pgn2tex.MoveMap.empty
    else parse_diagram_json json_str
  in

  let result = Pgn2tex.to_tex pgn diagram_data in
  Js.string result

(* Exporting the module to the global JavaScript scope *)
let () =
  Js.export "Pgn2tex"
    (object%js
       method convert pgn diagram_json clock = convert_js pgn diagram_json
    end)
