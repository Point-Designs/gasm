%{
  open Ast
%}

%token <string> IDENT STRING_LIT
%token <int> INT_LIT
%token PROGRAM INCLUDE START PROC VAR INVOKE
%token MOV ADD SUB LEA
%token REG_EAX REG_EBX REG_ECX REG_EDX
%token REG_RAX REG_RBX REG_RCX REG_RDX
%token REG_AL REG_BL REG_CL REG_DL
%token REG_AX REG_BX REG_CX REG_DX
%token LPAREN RPAREN LBRACE RBRACE LBRACK RBRACK COLON SEMICOLON COMMA ASSIGN EOF

%start <Ast.program> program_file

%%

program_file:
  | stmts = list(stmt); EOF { stmts }

stmt:
  | INCLUDE; LPAREN; path = STRING_LIT; RPAREN; SEMICOLON
      { IncludeHeader path }
  | PROGRAM; LPAREN; name = IDENT; RPAREN; SEMICOLON
      { ProgramDecl (name, []) }
  | VAR; name = IDENT; COLON; t = IDENT; ASSIGN; v = operand; SEMICOLON
      { VariableDecl (name, t, v) }
  | PROC; name = IDENT; LBRACE; body = list(stmt); RBRACE
      { ProcedureDecl (name, body) }
  | START; COMMA; LBRACE; body = list(stmt); RBRACE
      { ProcedureDecl ("start", body) }
  | inst = instr; SEMICOLON
      { InstructionStmt inst }

instr:
  | MOV; dest = operand; COMMA; src = operand { Mov (dest, src) }
  | ADD; dest = operand; COMMA; src = operand { Add (dest, src) }
  | SUB; dest = operand; COMMA; src = operand { Sub (dest, src) }
  | LEA; dest = operand; COMMA; src = operand { Lea (dest, src) }
  | INVOKE; fn = IDENT; args = separated_list(COMMA, operand) { Invoke (fn, args) }

operand:
  | REG_EAX { Reg EAX } | REG_EBX { Reg EBX } | REG_ECX { Reg ECX } | REG_EDX { Reg EDX }
  | REG_RAX { Reg RAX } | REG_RBX { Reg RBX } | REG_RCX { Reg RCX } | REG_RDX { Reg RDX }
  | REG_AL  { Reg AL }  | REG_BL  { Reg BL }  | REG_CL  { Reg CL }  | REG_DL  { Reg DL }
  | REG_AX  { Reg AX }  | REG_BX  { Reg BX }  | REG_CX  { Reg CX }  | REG_DX  { Reg DX }
  | n = INT_LIT { ImmInt n }
  | id = IDENT { Memory id }
  | LBRACK; r = reg_token; RBRACK { Deref r }
  | LBRACK; id = IDENT; RBRACK { Memory id }

reg_token:
  | REG_EAX { EAX } | REG_EBX { EBX } | REG_ECX { ECX } | REG_EDX { EDX }
  | REG_RAX { RAX } | REG_RBX { RBX } | REG_RCX { RCX } | REG_RDX { RDX }
  | REG_AL  { AL }  | REG_BL  { BL }  | REG_CL  { CL }  | REG_DL  { DL }
  | REG_AX  { AX }  | REG_BX  { BX }  | REG_CX  { CX }  | REG_DX  { DX }