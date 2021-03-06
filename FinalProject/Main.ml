open Event
(* open Command.Spec *) 
open Str 
open Helpers
  
(* populates the board *)
(* 
let set_alive () =
for c = 0 to 1 do
let x = Random.int World.size in
let y = Random.int World.size in
match World.get (x,y) with
|a::b -> Helpers.with_inv_probability World.rand 5 
(fun () -> a#switch_status; print_string (string_of_int(x));
print_string (string_of_int(y)); flush_all();)
|_ -> ()
done *)
  
let part1_initializer () = 
    let social_probability : int ref = ref 0 in

    (*let history = Sys.argv(2) in *)
    let fa = Helpers.website_counter Sys.argv(2) "facebook" in
    let tw = Helpers.website_conter Sys.argv(2) "twitter" in
    let tu = Helpers.website_counter Sys.argv(2) "tumblr" in
    let insta = Helpers.website_counter Sys.argv(2) "instagram" in

  if (fa > tw && fa > insta && fa > tu) then social_probability := 100 
  else if (tw > fa && tw > insta && tw > tu) then social_probability := 50
  else if (tu > tw && tu > insta && tu > fa) then social_probability := 20
  else if (insta > tw && insta > fa && insta > tu) then social_probability := 70; 

  for x = 0 to World.size -1 do
    for y = 0 to World.size -1 do
      ignore (new Alive.alive (x,y));
      match World.get (x,y) with
      |a::b -> Helpers.with_inv_probability World.rand !social_probability  
        (fun () -> a#switch_status; print_string (string_of_int(x));
        print_string (string_of_int(y)); flush_all();)
      |_ -> ()
    done; 
  done


(* set_alive *)
	
(* Function that is called continuously while the simulation is running. *)
let event_loop part () : unit =
  Graphics.clear_graph () ;
  if part >= 2 then Event.fire_event World.action_event () ;print_string ("fired"); flush_all();
  (* draw loop *)
  begin
  for x = 0 to World.size -1 do
    for y = 0 to World.size -1 do
      List.iter (fun w -> w#drawalive) 
      (List.filter (fun x -> x#get_status = "alive") (World.get (x,y)))
    done
  done
  end



(* Parse command-line arguments. Returns the appropriate initialization
   function to run and the current part. *)
let parse_args () : (unit -> unit)=
  let usage () = Printf.printf "usage: %s argument\n" Sys.argv.(0); exit 1 in
  if Array.length Sys.argv <> 3 then usage (); 
  (*Sys.argv(2) = anon ("webhistory" %: string)*)
  let webhistory = Sys.argv(2) in 
  let standard =  Str.regexp "^[a-zA-Z0-9-.]+.(com|org|net|mil|edu|COM|ORG|NET|MIL|EDU)$" in
  (* match Sys.argv(2) with *)
  if Not_found <> Str.search_forward standard webhistory 0 then 
    match Sys.argv(1) with "part2" -> part1_initializer
  else usage ()

    
let run () : unit =
  let initialize, part = parse_args () in
  UI.run_world initialize (event_loop part)
;;

run () ;;
