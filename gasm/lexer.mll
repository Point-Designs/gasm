{
  open Parser
}

let whitespace = [' ' '\t' '\r']+
let newline = '\n'
let digit = ['0'-'9']
let alpha = ['a'-'z' 'A'-'Z' '_']
let identifier = alpha (alpha | digit)*
let number = digit+
let hex_number = "0x" ['0'-'9' 'a'-'f' 'A'- me'-'F']+

rule token = parse
  | whitespace { token lexbuf }
  | newline    { Lexing.new_line lexbuf; token lexbuf }
  | "program"  { PROGRAM }
  | "include"  { INCLUDE }
  | "start"    { START }
  | "proc"     { PROC }
  | "var"      { VAR }
  | "invoke"   { INVOKE }
  | "mov"      { MOV }
  | "add"      { ADD }
  | "sub"      { SUB }
  | "lea"      { LEA }
  | "eax"      { REG_EAX }
  | "ebx"      { REG_EBX }
  | "ecx"      { REG_ECX }
  | "edx"      { REG_EDX }
  | "rax"      { REG_RAX }
  | "rbx"      { REG_RBX }
  | "rcx"      { REG_RCX }
  | "rdx"      { REG_RDX }
  | "al"       { REG_AL }
  | "bl"       { REG_BL }
  | "cl"       { REG_CL }
  | "dl"       { REG_DL }
  | "ax"       { REG_AX }
  | "bx"       { REG_BX }
  | "cx"       { REG_CX }
  | "dx"       { REG_DX }
  | "("        { LPAREN }
  | ")"        { RPAREN }
  | "{"        { LBRACE }
  | "}"        { RBRACE }
  | "["        { LBRACK }
  | "]"        { RBRACK }
  | ":"        { COLON }
  | ";"        { SEMICOLON }
  | ","        { COMMA }
  | "="        { ASSIGN }
  | "\""       { read_string (Buffer.create 16) lexbuf }
  | number as n { INT_LIT (int_of_string n) }
  | hex_number as h { INT_LIT (int_of_string h) }
  | identifier as id { IDENT id }
  | eof        { EOF }
  | _          { failwith ("Unexpected character: " ^ Lexing.lexeme lexbuf) }

and read_string buf = parse
  | '"'           { STRING_LIT (Buffer.contents buf) }
  | '\\' '/'      { Buffer.add_char buf '/'; read_string buf lexbuf }
  | '\\' '\\'     { Buffer.add_char buf '\\'; read_string buf lexbuf }
  | '\\' 'n'      { Buffer.add_char buf '\n'; read_string buf lexbuf }
  | [^ '"' '\\']+ as str { Buffer.add_string buf str; read_string buf lexbuf }
  | eof           { failwith "Unterminated string literal" }
  | _             { failwith "Illegal string character" }