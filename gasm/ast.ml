type register =
  | EAX | EBX | ECX | EDX
  | RAX | RBX | RCX | RDX
  | AL  | BL  | CL  | DL
  | AX  | BX  | CX  | DX

type operand =
  | Reg of register
  | ImmInt of int
  | ImmFloat of float
  | Memory of string
  | Deref of register

type instruction =
  | Mov of operand * operand
  | Add of operand * operand
  | Sub of operand * operand
  | Lea of operand * operand
  | Invoke of string * operand list

type statement =
  | IncludeHeader of string
  | VariableDecl of string * string * operand
  | ProcedureDecl of string * statement list
  | ProgramDecl of string * statement list
  | InstructionStmt of instruction

type program = statement list