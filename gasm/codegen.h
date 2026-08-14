#ifndef GASM_CODEGEN_H
#define GASM_CODEGEN_H

#include <stdint.h>

void gasm_c_init(void);
void gasm_c_emit_mov(const char* dest, const char* src);
void gasm_c_emit_add(const char* dest, const char* src);
void gasm_c_emit_sub(const char* dest, const char* src);
void gasm_c_emit_invoke(const char* name, int arg_count);
void gasm_c_finalize(const char* output_name);

#endif