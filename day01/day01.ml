open Core

module type Search = sig
  val forward_search : string -> char option
  val backward_search : string -> char option
end

module Solution (M : Search) = struct
  let get_value s =
    match (M.forward_search s, M.backward_search s) with
    | None, None -> 0
    | Some n, Some m -> ((int_of_char n - 48) * 10) + (int_of_char m - 48)
    (* Not possible to only find a digit on one side and not other *)
    | None, Some _
    | Some _, None ->
        print_endline s;
        assert false

  let solve () =
    [%file "input.txt"]
    |> String.split_lines
    |> List.fold ~init:0 ~f:(fun sum line -> sum + get_value line)
    |> string_of_int
    |> print_endline
end

module Part1Search : Search = struct
  let forward_search s =
    String.lfindi s ~f:(fun _ c -> Char.is_digit c)
    |> Option.map ~f:(fun i -> s.[i])

  let backward_search s =
    String.rfindi s ~f:(fun _ c -> Char.is_digit c)
    |> Option.map ~f:(fun i -> s.[i])
end

(* Part 2 *)
module Part2Search : Search = struct
  let window = 5

  let match_three_letters s i =
    match s.[i] with
    | 'o' ->
        if Char.equal s.[i + 1] 'n' && Char.equal s.[i + 2] 'e' then Some '1'
        else None
    | 't' ->
        if Char.equal s.[i + 1] 'w' && Char.equal s.[i + 2] 'o' then Some '2'
        else None
    | 's' ->
        if Char.equal s.[i + 1] 'i' && Char.equal s.[i + 2] 'x' then Some '6'
        else None
    | _ -> None

  let match_four_letters s i =
    match s.[i] with
    | 'f' ->
        if
          Char.equal s.[i + 1] 'o'
          && Char.equal s.[i + 2] 'u'
          && Char.equal s.[i + 3] 'r'
        then Some '4'
        else if
          Char.equal s.[i + 1] 'i'
          && Char.equal s.[i + 2] 'v'
          && Char.equal s.[i + 3] 'e'
        then Some '5'
        else None
    | 'n' ->
        if
          Char.equal s.[i + 1] 'i'
          && Char.equal s.[i + 2] 'n'
          && Char.equal s.[i + 3] 'e'
        then Some '9'
        else None
    | _ -> None

  let match_five_letters s i =
    match s.[i] with
    | 't' ->
        if
          Char.equal s.[i + 1] 'h'
          && Char.equal s.[i + 2] 'r'
          && Char.equal s.[i + 3] 'e'
          && Char.equal s.[i + 4] 'e'
        then Some '3'
        else None
    | 's' ->
        if
          Char.equal s.[i + 1] 'e'
          && Char.equal s.[i + 2] 'v'
          && Char.equal s.[i + 3] 'e'
          && Char.equal s.[i + 4] 'n'
        then Some '7'
        else None
    | 'e' ->
        if
          Char.equal s.[i + 1] 'i'
          && Char.equal s.[i + 2] 'g'
          && Char.equal s.[i + 3] 'h'
          && Char.equal s.[i + 4] 't'
        then Some '8'
        else None
    | _ -> None

  let lex s start len ~offset =
    if len < 3 then None
    else if len = 3 then match_three_letters s start
    else if len = 4 then
      match match_three_letters s (start + (offset * 1)) with
      | Some x -> Some x
      | None -> match_four_letters s start
    else
      match match_three_letters s (start + (offset * 2)) with
      | Some x -> Some x
      | None -> (
          match match_four_letters s (start + (offset * 1)) with
          | Some x -> Some x
          | None -> match_five_letters s start)

  let forward_search s =
    let len = String.length s in
    let rec inner start_pos end_pos =
      if end_pos = len then None
      else if Char.is_digit s.[end_pos] then Some s.[end_pos]
      else
        let substr_len = end_pos - start_pos + 1 in
        match lex s start_pos substr_len ~offset:1 with
        | Some n -> Some n
        | None ->
            if substr_len = window then inner (start_pos + 1) (end_pos + 1)
            else inner start_pos (end_pos + 1)
    in
    inner 0 0

  let backward_search s =
    let len = String.length s in
    let rec inner start_pos end_pos =
      if start_pos = -1 then None
      else if Char.is_digit s.[start_pos] then Some s.[start_pos]
      else
        let substr_len = end_pos - start_pos + 1 in
        match lex s start_pos substr_len ~offset:0 with
        | Some n -> Some n
        | None ->
            if substr_len = window then inner (start_pos - 1) (end_pos - 1)
            else inner (start_pos - 1) end_pos
    in
    inner (len - 1) (len - 1)
end

module Part1 = Solution (Part1Search)
module Part2 = Solution (Part2Search)

let main () =
  Part1.solve ();
  Part2.solve ()

let%expect_test "part2" =
  [
    "two1nine";
    "eightwothree";
    "abcone2threexyz";
    "xtwone3four";
    "4nineeightseven2";
    "zoneight234";
    "7pqrstsixteen";
  ]
  |> List.map ~f:Part2.get_value
  |> List.fold ~init:0 ~f:( + )
  |> Int.to_string
  |> print_endline;
  [%expect {| 281 |}]
