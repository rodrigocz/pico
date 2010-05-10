#include "symbol_table.h"
#include <stdlib.h>
#include <string.h>

// Funcao hash retirada do livro do dragao
int hashpjw(char* s){
  char* p;
  unsigned h = 0, g;
  for (p = s; *p != '\0'; p = p+1) {
    h = (h << 4) + (*p);
    if (g = h&0xf0000000) {
      h = h ^ (g >> 24);
      h = h ^ g;
    }
  }
  return h % 211;
}

// Inicializa todos os ponteiros das listas do array de listas list com NULL
int init_table(symbol_t* table){
  int i;
  for (i=0; i<=210; i++) {
    table->list[i]=NULL;
  }
  return 0;
}

// Libera a memoria alocada as listas do array de listas list
void free_table(symbol_t* table) {
  node* aux_node;
  int i;
  node* temp;
  entry_t* aux_entry;
  for (i=0; i<=210; i++) {
    if (table->list[i]!=NULL) {
      aux_node=table->list[i];
      while (aux_node != NULL) {
        temp=aux_node->next;
        aux_entry=aux_node->data;
        free(aux_entry);
        free(aux_node);
        aux_node=temp;
      }
      table->list[i]=NULL;
    }
  }
}

// Verifica se a entrada name esta contida na tabela table
entry_t* lookup(symbol_t table, char* name) {
  int bucket = hashpjw(name);                   // Calcula o inteiro associado a name
  if (table.list[bucket] == NULL) {            // Se o ponteiro associado ao bucket correspondente
    return NULL;                                // a name for NULL retorna NULL
  }
  node* aux;                                    // Senao cria um ponteiro auxiliar
  aux = table.list[bucket];                    // que recebe o ponteiro associado a lista da tabela
  while (aux != NULL) {                         // Percorre a lista verificando se name já esta
    if (strcmp(name,aux->data->name) == 0) {    // contido nela
      return aux->data;                         // Retorna o ponteiro dela caso esteja
    }
    else {
      aux = aux->next;                          // Caso percorra toda lista  e nao encontre
    }                                           // nenhuma entrada igual a name retorna NULL
  }
  return NULL;
}

// Funcao de insercao de uma entrada na tabela
int insert(symbol_t* table, entry_t* entry) {
  if ( lookup(*table,entry->name) != NULL ) {    // Verifica se name esta contida em table
    return -1;                                  // Retorna com erro
  }
  int bucket = hashpjw(entry->name);            // Calcula o hash de name e salva em bucket
  if ( table->list[bucket] == NULL ) {          // Se a lista correspondente a bucket estiver vazia
    table->list[bucket]=(node*)malloc(sizeof(node)); // aloca memoria e insere um novo nodo na lista
    table->list[bucket]->next=NULL;
    table->list[bucket]->data=(entry_t*)malloc(sizeof(entry_t));
    *table->list[bucket]->data=*entry;
    return 0;                                   // Retorna com sucesso
  }
  node* aux;                                    // Senao cria o ponteiro auxiliar aux
  aux = table->list[bucket];                    // que recebe o ponteiro da lista em questao
  while (aux->next != NULL) {                   // e a percorre ate achar o ultimo nodo
    aux = aux->next;
  }
  node* novo;                                   // Entao cria um novo ponteiro
  novo=(node*)malloc(sizeof(node));             // Aloca memoria e insere os dados correspondentes
  novo->next=NULL;                              // a entrada entry
  novo->data=(entry_t*)malloc(sizeof(entry_t));
  *novo->data=*entry;
  aux->next=novo;                               // e termina ligando o ultimo nodo da lista 
  return 0;                                     // apontado por aux com o novo nodo
}                                               // e retornando com sucesso

// Funcao de impressao da tabela na tela
int print_table(symbol_t table){
  int i;
  symbol_t* p_table;
  int size=0;
  node* aux;
  p_table=&table;
  for (i=0; i<=210; i++) {                      // Percorre o array verificando se ha entradas
    if (p_table->list[i] != NULL) {             // Se houver imprime seu conteudo na tela
      aux = p_table->list[i];
//      printf("slot %d\n",i);
      printf("%s\n",aux->data->name);
      printf("%d\n",aux->data->type);
      printf("%d\n",aux->data->size);
      printf("%d\n",aux->data->desloc);
      size++;                                   // aumenta a variavel size
      while (aux->next != NULL) {               // Verifica e imprimi os outros nodos da lista
        aux = aux->next;                        // se houverem
        printf("%s\n",aux->data->name);
        size++;                                 // e incrementa a variavel size
      }
//      printf("\n");
    }
  }
  return size;                                  // Retorna o numero de entrada da tabela
}

// Funcao de impressao da tabela em um arquivo apontado por out
int print_file_table(FILE* out, symbol_t table) {
  int i;
  symbol_t* p_table;
  int size=0;
  node* aux;
  p_table=&table;
  for (i=0; i<=210; i++) {                      // Percorre o array verificando se ha entradas
    if (p_table->list[i] != NULL) {             // Se houver imprime seu conteudo no arquivo
      aux = p_table->list[i];
      fprintf(out,"%s\n",aux->data->name);
      size++;                                   // aumenta a variavel size
      while (aux->next != NULL) {               // Verifica e imprimi os outros nodos da lista
        aux = aux->next;                        // se houverem
        fprintf(out,"%s\n",aux->data->name);
        size++;                                 // e incrementa a variavel size
      }
    }
  }
  return size;                                  // Retorna o numero de entrada da tabela
}

/*--------------------------TESTES--------------------------*/
/*int main(){
  symbol_t tabela;
  entry_t entrada;
  entry_t* p_entrada;
  char* palavra;
  
  init_table(&tabela);
  entrada.name="lkioo";
  p_entrada=&entrada;
  insert(&tabela,p_entrada);
  entrada.name="op";
  insert(&tabela,p_entrada);
  entrada.name="formula";
  insert(&tabela,p_entrada);
  entrada.name="aviao";
  insert(&tabela,p_entrada);
  print_table(tabela);
  
  FILE* arq;
  arq = fopen("saida.txt","w");
  print_file_table(arq,tabela);
  
  free_table(&tabela);
  printf("\n");
  system("pause");
}*/
