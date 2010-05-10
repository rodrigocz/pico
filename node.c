#include "node.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Pode ser util...*/
static int __nodes_ids__ = 0;



// Funcionando
Node* create_node(int nl, Node_type t, char* lex, 
                  void* att, int nbc, Node** children) {
    
    // Testes nbc = numero de filhos
    if (nbc >= MAX_CHILDREN_NUMBER) {
        printf("ERRO! Número de filhos da árvore é maior que o permitido."); 
	exit(-1);
    }
    else if (nbc <= 0) {
	printf("ERRO! Número de filhos deve ser maior ou igual a 0.");
	exit(-1);
    }  // Testa o tipo do nodo
    else if ((t < 299) || (t > 363)) { 
        printf("ERRO! Tipo do nodo incorreto.");
        exit(-1);
    }
    
    // Cria novo nodo e aloca memória
    Node * newNode = create_leaf(nl, t, lex, att);  

    // Termina de repassar últimos atributos recebidos na função     
    newNode->num_child = nbc;
    newNode->child     = children;
    
    // Retorna o novo nodo criado
    return newNode;

}


// Funcionando
Node* create_leaf(int nl, Node_type t, char* lex, void* att) {
   
    // Testa o tipo da folha
    if ((t < 299) || (t > 363)) { 
 	printf("ERRO! Tipo do nodo incorreto");
        exit(-1); 
    }
  
    // Cria novo nodo e aloca memória
    Node * newNode;
    newNode = malloc(sizeof(Node));

    // Repassa atributos recebidos na função
    newNode->num_line = nl;
    newNode->type     = t;

    // Aloca o espaco necessario e passa a string lex 
    newNode->lexeme = malloc(sizeof(char) * strlen(lex));   
    memcpy((void *)newNode->lexeme,(void *) lex, sizeof(char)*strlen(lex));    

    // Termina de repassar atributos recebidos na função
    newNode->attribute = att;     
 
    // É zero pois uma folha não tem filhos
    newNode->num_child = 0;
    // Setado em NULL pois função não recebe nodo pai
    newNode->child = NULL;
   
    // Retorna o novo nodo folha criado
    return newNode;
}




// Funcionando
int nb_of_children(Node* n) {
    // Testa se o argumento dado é NULL
    if (n == NULL) {
        printf("ERRO! Apontador para numero de filhos NULL.");
	exit(-1);
    }
    else return n->num_child;
}



// Funcionando
Node* child(Node* n, int i) {
    // Testa se o ponteiro dado é NULL
    if (n == NULL) {
        printf("ERRO! Ponteiro dado é NULL");
        exit(-1);                
    }

    // Testa se i está dentro do num_child do nodo recebido como parametro
    if ( (i < 0) || (i >= nb_of_children(n)) ) {
	printf("ERRO! Número índice incorreto (Fora do intervalo de filhos)");
        exit(-1);
    }
    // Retorna i-ésimo filho requerido
    return n->child[i];

}
 


// MAIS OU MENOS... TESTAR
// Return 0, ok...
int deep_free_node(Node* n) {
    //Testa se o ponteiro dado é NULL
    if (n == NULL) {
        printf("ERRO! Ponteiro dado é NULL");
        exit(-1);                
    }

    int i;         // iterador de laço
    
    //  Testa se existem filhos para serem desalocados
    //  Não sei se precisaria disso...
//    if ( n->num_child == 0 ) {
//        free(n);      // Desaloca n, e retorna zero (n não possui filhos)
//        return 0;
//    }
    // Caso contrário, vai liberando para cada filho, recursivamente
    for (i=0; i < n->num_child; i++) {
        deep_free_node(n->child[i]);
    }
    
    // Desaloca o nodo corrente
    free(n);
    return 0; // tanto faz
}


// Funcionando
int height(Node *n) {
    
    // Testa se o ponteiro é NULL... OBS: RETORNAR ERRO OU ZERO (ÁRVORE VAZIA)?
    if (n == NULL) {
        printf("ERRO! Ponteiro dado é NULL");
        exit(-1);                
    }
    
    int i;		// contador
    int alt;		// altura da subárvore corrente
    int alt_max = 0;    // altura da maior (sub)árvore encontrada entre os filhos de n
        
    // Caso seja uma folha, retorna altura igual a 1
    if (nb_of_children(n) == 0) { return 1; }       
    // Senão calcula recursivamente 
    else {
        // Calcula a altura da maior subárvore
        for (i = 0; i < nb_of_children(n); i++) {
            alt = height(child(n,i));

            // Se altura calculada é maior que máxima já encontrada até agora, armazena o novo valor
	    if (alt > alt_max) {
                alt_max = alt;
//		printf("Passou height()"); 
	    }
	}
    }
    // Retorna a altura da maior subárvore + 1 (nodo pai)
    return alt_max + 1;
}


// TESTAR e AJEITAR... 
int pack_nodes(Node*** array_of_nodes, const int cur_size, Node* n) {
     // Testa se ponteiro dado é NULL
    if (n == NULL){
        printf("ERRO! Ponteiro dado é NULL");
        exit(-1);                        
    }
    if ((cur_size < 0) || (cur_size > MAX_CHILDREN_NUMBER)) {
        printf("ERRO! Tamanho do array de nodos ultrapassou limite permitido.");
        exit(-1);        
    }   
   
    // Cria e aloca memória para o novo nodo    
    Node ** newArray = malloc(sizeof(Node *) * (cur_size + 1));
    
    // Primeiro nodo a ser alocado
    if (cur_size == 0) {                                      
        *array_of_nodes = malloc(sizeof(Node *));                 
    } 
    // Caso contrario, se é maior que zero, não é o primeiro nodo alocado
    else if (cur_size > 0) {   
        // Copia os valores dos ponteiros para o array antigo              
        memcpy(newArray, *array_of_nodes, cur_size * sizeof(Node *));   
    }
    
    // Insere o novo nodo no array criado
    newArray[cur_size] = n;
    // Libera memória do array repassado por parâmetro
    free(*array_of_nodes);          
    // Corrige o ponteiro para o novo array criado
    *array_of_nodes = newArray;          
    
    return cur_size + 1;
}


void print_tree(Node *n) {
    if(n == NULL){
        return;
    }
    /*imprime em pós-ordem*/
    int i;
    for(i=0; i< n->num_child; i++)
        print_tree(n->child[i]);

    if(n->num_child == 0){ /*só imprime se for uma folha*/
      if (!strcmp(n->lexeme, ";")){
	  fprintf(stdout, "%s\n", n->lexeme);
      }	else {
	  fprintf(stdout, "%s ", n->lexeme);
      }
    }
}

