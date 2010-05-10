#ifndef _LISTA_H_
#define _LISTA_H_

#include <stdio.h>

struct tac {
   char* op;   /* "+", "-", ":=", "if", etc... */
   char* res;  /* "TMP100" */
   char* arg1; /* "TMP0"   */
   char* arg2; /* "TMP1"   */
};

struct tac* create_inst_tac(const char* res, const char* arg1,const char* op, const char* arg2);
void print_inst_tac(FILE* out, struct tac i);

struct node_tac {
   struct tac * inst;
   struct node_tac* next;
   struct node_tac* prev;
};

void print_tac(FILE* out, struct node_tac * code);

/** Insere no fim da lista 'code' o elemento 'inst'. 
 * @param code lista (possivelmente vazia) inicial, em entrada. Na saida, contem *         a mesma lista, com mais um elemento inserido no fim.
 * @inst  o elemento inserido no fim da lista.
 */
void append_inst_tac(struct node_tac ** code, struct tac * inst);

/** Concatena a lista 'code_a' com a lista 'code_b'.
 * @param code_a lista (possivelmente vazia) inicial, em entrada. Na saida, contem 
 *         a mesma lista concatenada com 'code_b'.
 * @param code_b a lista concatenada com 'code_a'.
 */
void cat_tac(struct node_tac ** code_a, struct node_tac ** code_b);

#endif
