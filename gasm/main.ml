open Ast

external c_init : unit -> unit = "gasm_c_init"
external c_emit_mov : string -> string -> unit = "gasm_c_emit_mov"
external c_emit_add : string -> string -> unit = "gasm_c_emit_add"
external c_emit_sub : string -> string -> unit = "gasm_c_emit_sub"
external c_emit_invoke : string -> int -> unit = "gasm_c_emit_invoke"
external c_finalize : string -> unit = "gasm_c_finalize"

let reg_to_string = function
  | EAX -> "eax" | EBX -> "ebx" | ECX -> "ecx" | EDX -> "edx"
  | RAX -> "rax" | RBX -> "rbx" | RCX -> "rcx" | RDX -> "rdx"
  | AL  -> "al"  | BL  -> "bl"  | CL  -> "cl"  | DL  -> "dl"
  | AX  -> "ax"  | BX  -> "bx"  | CX  -> "cx"  | DX  -> "dx"

let operand_to_string = function
  | Reg r -> reg_to_string r
  | ImmInt n -> string_of_int n
  | ImmFloat f -> string_of_float f
  | Memory id -> id
  | Deref r -> "[" ^ reg_to_string r ^ "]"

let rec emit_statement = function
  | IncludeHeader path ->
      Printf.printf "Processing header: %s\n" path
  | ProgramDecl (name, _) ->
      Printf.printf "Assembling Program: %s\n" name
  | VariableDecl (name, t, v) ->
      Printf.printf "Allocating Var: %s (%s)\n" name t
  | ProcedureDecl (name, body) ->
      Printf.printf "Procedure: %s\n" name;
      List.iter emit_statement body
  | InstructionStmt inst ->
      match inst with
      | Mov (d, s) -> c_emit_mov (operand_to_string d) (operand_to_string s)
      | Add (d, s) -> c_emit_add (operand_to_string d) (operand_to_string s)
      | Sub (d, s) -> c_emit_sub (operand_to_string d) (operand_to_string s)
      | Lea (d, s) -> c_emit_mov (operand_to_string d) (operand_to_string s)
      | Invoke (fn, args) -> c_emit_invoke fn (List.length args)

let process_file file_path =
  let ic = open_in file_path in
  let lexbuf = Lexing.from_channel ic in
  try
    let ast = Parser.program_file Lexer.token lexbuf in
    close_in ic;
    c_init ();
    List.iter emit_statement ast;
    c_finalize "output.s"
  with e ->
    close_in ic;
    raise e

let () =
  if Array.length Sys.argv < 2 then
    Printf.printf "Usage: gasm <file.Gasm>\n"
  else
    process_file Sys.argv.(1)