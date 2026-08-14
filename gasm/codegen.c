#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "codegen.h"

static FILE* out_file = NULL;

void gasm_c_init(void) {
    out_file = fopen("output.s", "w");
    if (!out_file) return;
    fprintf(out_file, ".intel_syntax noprefix\n");
    fprintf(out_file, ".global main\n\n");
}

void gasm_c_emit_mov(const char* dest, const char* src) {
    if (out_file) {
        fprintf(out_file, "    mov %s, %s\n", dest, src);
    }
}

void gasm_c_emit_add(const char* dest, const char* src) {
    if (out_file) {
        fprintf(out_file, "    add %s, %s\n", dest, src);
    }
}

void gasm_c_emit_sub(const char* dest, const char* src) {
    if (out_file) {
        fprintf(out_file, "    sub %s, %s\n", dest, src);
    }
}

void gasm_c_emit_invoke(const char* name, int arg_count) {
    if (out_file) {
        fprintf(out_file, "    call %s\n", name);
    }
}

void gasm_c_finalize(const char* output_name) {
    if (out_file) {
        fclose(out_file);
        out_file = NULL;
    }
}