open Core

let regex =
  Re.Perl.compile_pat
    ("(?:1[3-9]|[2-9][0-9]) red"
    ^ "|(?:1[4-9]|[2-9][0-9]) green"
    ^ "|(?:1[5-9]|[2-9][0-9]) blue")

let part1 () =
  String.split_lines [%file "input.txt"]
  |> List.filter_mapi ~f:(fun i l ->
         if Re.execp regex l then None else Some (i + 1))
  |> List.reduce_exn ~f:( + )
  |> Int.to_string
  |> print_endline

let capture_red = Re.Perl.compile_pat "([1-9][0-9]?) red"
let capture_green = Re.Perl.compile_pat "([1-9][0-9]?) green"
let capture_blue = Re.Perl.compile_pat "([1-9][0-9]?) blue"
let match_as_int group = Re.Group.get group 1 |> int_of_string

let extract_max re s =
  Re.all re s
  |> List.map ~f:match_as_int
  |> List.max_elt ~compare:Int.compare
  |> Option.value_exn

let part2 () =
  String.split_lines [%file "input.txt"]
  |> List.map ~f:(fun l ->
         extract_max capture_red l
         * extract_max capture_green l
         * extract_max capture_blue l)
  |> List.reduce_exn ~f:( + )
  |> Int.to_string
  |> print_endline

let main () =
  part1 ();
  part2 ()
