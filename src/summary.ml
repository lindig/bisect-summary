
(** This is a small utility to report the code coverage of a project from
 * data produced by code instrumentation with [bisect_ppx]. Unlike
 * [bisect-ppx-report], this tool only reads the [bisect-*.out] files
 * produced at runtime and doesn't require access to the  [*.cmp] files
 * produced at compile time. In exchange, the report is less detailed.
 *
 * Usage: summary bisect*out
 *
 * ocamlbuild -use-ocamlfind -pkg bisect_ppx summary.native
 *)

[@@@ocaml.warning "-3"]

(* these are the types used by [bisect_ppx] *)
type file     = string
type count    = int
type runtime  = (file * count array) list

(** [minmax x y] orders two arrays by length and returns them as (x,
 * y) if x is the shorter one, and as (y, x) otherwise *)
let minmax
  : 'a array -> 'a array -> 'a array * 'a array
  = fun x y ->
  if Array.length x < Array.length y then x, y else y, x

(** [add x y] combines two [int array] values by adding them point-wise.
* The shorter array is assumed to contain zero in all index positions
* beyond its range. The result is a new array with the same length as
* the longer array. *)
let add
  : int array -> int array -> int array
  = fun x y ->
  let min, max = minmax x y in
  let result   = Array.copy max in
  ( Array.iteri (fun i m -> result.(i) <- result.(i) + m) min
  ; result
  )

(* [merge x y] merges two runtime data sets into one. When data is
 * present in two sets for one source file, [add] is used to combine
 * them. Otherwise this is merge sort of sorted lists. This could be
 * simplified by using [Map.S.union] but it only became available with
 * OCaml 4.03.
 *)
let merge
  : runtime -> runtime -> runtime
  = fun rx ry ->
  let compare x y  = String.compare (fst x) (fst y) in
  let sort runtime = List.sort compare runtime in
  let rec loop rx ry = match rx, ry with
    | [], ry -> ry
    | rx, [] -> rx
    | (fx, px)::rx, (fy, py)::ry          when fx = fy ->
      (fx, add px py) :: loop rx ry
    | (fx, px)::rx, ((fy, _)::_ as yy)  when fx < fy ->
      (fx, px) :: loop rx yy
    | xx, (fy, py)::ry ->                 (*   fx > fy *)
      (fy, py) :: loop xx ry
  in
    loop (sort rx) (sort ry)

(* [read files] combines runtime data. The result is a association list
 * of filename and count data, representing a set of files. *)
let read
  : string list -> runtime
  = fun files ->
  files
  |> List.map Bisect.Common.read_runtime_data
  |> List.fold_left merge []

(** [popcount array] returns the number of non-zero entries in an array
 * *)
let popcount counters =
  let add pop = function
    | 0 -> pop
    | _ -> pop + 1
  in
    Array.fold_left add 0 counters

(** [report name counters] reports the coverage for [file]. It computes
 * the ratio of non-zero counters to total number of counters.
 *)
let report
  : string -> count array -> unit
  = fun name counters ->
  let total   = Array.length counters in
  let nonzero = popcount counters in
  let ratio = match total with
    | 0 -> 0.0
    | _ -> 100.0 *. float_of_int nonzero /. float_of_int total
  in
    Printf.printf "%5.1f%% [%4d/%-4d] %s\n" ratio nonzero total name

(** [process files] processes a list of files with runtime coverage data
 **)
let process
  : file list -> unit
  = fun files ->
  let runtime  = read files in
  let all      = runtime |> List.map snd |> Array.concat in
    ( report "# Overall Coverage" all
    ; print_endline "--------------------------------------"
    ; List.iter (fun (name, counters) -> report name counters) runtime
    )

let main () =
  let args = Array.to_list Sys.argv in
  let this = Sys.executable_name in
  match args with
  | [_] | [] -> Printf.eprintf "usage: %s bisect.out ...\n" this; exit 1
  | _::files -> process files

let init name =
  let (//)    = Filename.concat in
  let tmpdir  = Filename.get_temp_dir_name () in
    try
      ignore (Sys.getenv "BISECT_FILE")
    with Not_found ->
      Unix.putenv "BISECT_FILE" (tmpdir // Printf.sprintf "bisect-%s-" name)

let () =
  try
    ( init "summary"
    ; main ()
    ; exit 0
    )
  with
    e -> Printf.eprintf "Error: %s\n" (Printexc.to_string e); exit 1
