module type DB = Caqti_lwt.CONNECTION

module R = Caqti_request
module T = Caqti_type

let list_comments =
  let query =
    R.collect T.unit T.(tup2 int string) "SELECT id, text FROM comments"
  in
  fun (module Db : DB) ->
    let%lwt comments_or_error = Db.collect_list query () in
    Caqti_lwt.or_fail comments_or_error

type message = { id : int; text : string } [@@deriving yojson]

(* let render comments request =  *)

let () =
  Dream.run ~interface:"0.0.0.0"
  @@ Dream.logger
  (* @@ Dream.sql_pool (Sys.getenv "DATABASE_URL")
  @@ Dream.sql_sessions *)
  @@ Dream.router
       [
         Dream.get "/" (fun _ ->
             Dream.html "Dream started by Docker Compose, built with esy!");
         (* Dream.get "/comments" (fun request ->
             let%lwt comments = Dream.sql request list_comments in

             let a = List.map (fun (id, text) -> { id; text }) comments in

             let json = [%yojson_of: message list] a in

             json |> Yojson.Safe.to_string |> Dream.json); *)
       ]
  @@ Dream.not_found
