%{
  /* Aqui, pode-se inserir qualquer codigo C necessario ah compilacao
   * final do parser. Sera copiado tal como esta no inicio do y.tab.c
   * gerado por Yacc.
   */
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include "node.h"
  #include "lista.h"
  #include "symbol_table.h"

  #define UNDEFINED_SYMBOL_ERROR -21

  symbol_t s_table;
  Node* syntax_tree;
  int lineno;
  int desloc=0;
%}

%union {
  char* cadeia;
  Node* no;
}

%type <no> code
%type <no> declaracao
%type <no> declaracoes
%type <no> listadeclaracao
%type <no> tipo
%type <no> tipounico
%type <no> tipolista
%type <no> listadupla
%type <no> acoes
%type <no> comando
%type <no> lvalue
%type <no> listaexpr
%type <no> expr
%type <no> chamaproc
%type <no> enunciado
%type <no> fiminstcontrole
%type <no> expbool

%token <cadeia> ';'
%token <cadeia> ':'
%token <cadeia> ','
%token <cadeia> '['
%token <cadeia> ']'
%token <cadeia> '('
%token <cadeia> ')'
%token <cadeia> '{'
%token <cadeia> '}'
%token <cadeia> '=' 
%token <cadeia> '*' 
%token <cadeia> '/' 
%token <cadeia> '+' 
%token <cadeia> '-' 
%token <cadeia> '>' 
%token <cadeia> '<' 

%token <cadeia> IDF
%token <cadeia> INT
%token <cadeia> DOUBLE
%token <cadeia> REAL
%token <cadeia> CHAR
%token <cadeia> QUOTE
%token <cadeia> DQUOTE
%token <cadeia> LE
%token <cadeia> GE
%token <cadeia> EQ
%token <cadeia> NE
%token <cadeia> AND
%token <cadeia> OR
%token <cadeia> NOT
%token <cadeia> IF
%token <cadeia> THEN
%token <cadeia> ELSE
%token <cadeia> WHILE
%token <cadeia> INT_LIT
%token <cadeia> F_LIT
%token <cadeia> END
%token <cadeia> TRUE
%token <cadeia> FALSE
%token <cadeia> FOR
%token <cadeia> NEXT
%token <cadeia> REPEAT
%token <cadeia> UNTIL

%start code
 


 /* A completar com seus tokens - compilar com 'yacc -d' */



%%
code: declaracoes acoes {
				Node** children;
				pack_nodes(&children,0,$1);
				pack_nodes(&children,1,$2);
				$$ = create_node(lineno,program_node,"",NULL,2,children);
				syntax_tree = $$;
				//print_tree(syntax_tree);
				print_table(s_table);
				}
    | acoes {$$ = $1;
	     syntax_tree = $$;}
    ;

declaracoes: declaracao ';' {
				Node** children;
				pack_nodes(&children,0,$1);
				pack_nodes(&children,1,create_leaf(lineno,semicolon_node,";",NULL));
				$$ = create_node(lineno,decl_node,"",NULL,2,children);
				}
           | declaracoes declaracao ';'  {
						Node** children;
						pack_nodes(&children,0,$1);
						pack_nodes(&children,1,$2);
						pack_nodes(&children,2,create_leaf(lineno,semicolon_node,";",NULL));
						$$ = create_node(lineno,decl_node,"",NULL,3,children);
						}
           ;

declaracao: listadeclaracao ':' tipo  {
					Node** children;
					pack_nodes(&children,0,$1);
					pack_nodes(&children,1,create_leaf(lineno,colon_node,":",NULL));
					pack_nodes(&children,2,$3);
					$$ = create_node(lineno,decl_node,"",NULL,3,children);
					}

listadeclaracao: IDF {
			$$ = create_leaf(lineno,idf_node,$1,NULL);
			//printf("%s\n",$1);
			}
               | IDF ',' listadeclaracao  {
						Node** children;
						pack_nodes(&children,0,create_leaf(lineno,idf_node,$1,NULL));
						pack_nodes(&children,1,create_leaf(lineno,comma_node,",",NULL));
						pack_nodes(&children,2,$3);
						$$ = create_node(lineno,decl_list_node,"",NULL,3,children);
						}
               ;

tipo: tipounico {
			$$ = $1;
			}
    | tipolista {
			$$ = $1;
			}
    ;

tipounico: INT {
		entry_t entry;
		entry.name=$1;
		entry.type=int_node;
		entry.size=4;
		entry.desloc=desloc;
		desloc+=4;
		entry.extra=NULL;
		insert(&s_table,&entry);
		$$ = create_leaf(lineno,int_node,"int",NULL);
		//printf("%s\n",$1);
		}
         | DOUBLE {
			entry_t entry;
			entry.name=$1;
			entry.type=double_node;
			entry.size=8;
			entry.desloc=desloc;
			desloc+=8;
			entry.extra=NULL;
			insert(&s_table,&entry);
			$$ = create_leaf(lineno,double_node,"double",NULL);
			}
         | REAL {
			entry_t entry;
			entry.name=$1;
			entry.type=real_node;
			entry.size=4;
			entry.desloc=desloc;
			desloc+=4;
			entry.extra=NULL;
			insert(&s_table,&entry);
			$$ = create_leaf(lineno,real_node,"real",NULL);
			}
         | CHAR {
			entry_t entry;
			entry.name=$1;
			entry.type=char_node;
			entry.size=1;
			entry.desloc=desloc;
			desloc+=1;
			entry.extra=NULL;
			insert(&s_table,&entry);
			$$ = create_leaf(lineno,char_node,"char",NULL);
			}
         ;

tipolista: INT '[' listadupla ']' {
					Node** children;
					pack_nodes(&children,0,create_leaf(lineno,int_node,"int",NULL));
					pack_nodes(&children,1,create_leaf(lineno,abre_col_node,"[",NULL));
					pack_nodes(&children,2,$3);
					pack_nodes(&children,3,create_leaf(lineno,fecha_col_node,"]",NULL));
					$$ = create_node(lineno,tipolista_node,"",NULL,4,children);
					}
         | DOUBLE '[' listadupla ']' {
					Node** children;
					pack_nodes(&children,0,create_leaf(lineno,double_node,"double",NULL));
					pack_nodes(&children,1,create_leaf(lineno,abre_col_node,"[",NULL));
					pack_nodes(&children,2,$3);
					pack_nodes(&children,3,create_leaf(lineno,fecha_col_node,"]",NULL));
					$$ = create_node(lineno,tipolista_node,"",NULL,4,children);
					}
         | REAL '[' listadupla ']' {
					Node** children;
					pack_nodes(&children,0,create_leaf(lineno,real_node,"real",NULL));
					pack_nodes(&children,1,create_leaf(lineno,abre_col_node,"[",NULL));
					pack_nodes(&children,2,$3);
					pack_nodes(&children,3,create_leaf(lineno,fecha_col_node,"]",NULL));
					$$ = create_node(lineno,tipolista_node,"",NULL,4,children);
					}
         | CHAR '[' listadupla ']' {
					Node** children;
					pack_nodes(&children,0,create_leaf(lineno,char_node,"char",NULL));
					pack_nodes(&children,1,create_leaf(lineno,abre_col_node,"[",NULL));
					pack_nodes(&children,2,$3);
					pack_nodes(&children,3,create_leaf(lineno,fecha_col_node,"]",NULL));
					$$ = create_node(lineno,tipolista_node,"",NULL,4,children);
					}
         ;

listadupla: INT_LIT ':' INT_LIT {
					Node** children;
					pack_nodes(&children,0,create_leaf(lineno,int_lit_node,$1,NULL));
					pack_nodes(&children,1,create_leaf(lineno,colon_node,":",NULL));
					pack_nodes(&children,2,create_leaf(lineno,int_lit_node,$3,NULL));
					$$ = create_node(lineno,listadupla_node,"",NULL,3,children);
					}
          | INT_LIT ':' INT_LIT ',' listadupla {
						Node** children;
						pack_nodes(&children,0,create_leaf(lineno,int_lit_node,$1,NULL));
						pack_nodes(&children,1,create_leaf(lineno,colon_node,":",NULL));
						pack_nodes(&children,2,create_leaf(lineno,int_lit_node,$3,NULL));
						pack_nodes(&children,3,create_leaf(lineno,comma_node,",",NULL));
						pack_nodes(&children,4,$5);
						$$ = create_node(lineno,listadupla_node,"",NULL,5,children);
						}
          ;

acoes: comando ';' {
			Node** children;
			pack_nodes(&children,0,$1);
			pack_nodes(&children,1,create_leaf(lineno,semicolon_node,";",NULL));
			$$ = create_node(lineno,acoes_node,"",NULL,2,children);
			}
    | comando ';' acoes  {
				Node** children;
				pack_nodes(&children,0,$1);
				pack_nodes(&children,1,create_leaf(lineno,semicolon_node,";",NULL));
				pack_nodes(&children,2,$3);
				$$ = create_node(lineno,acoes_node,"",NULL,3,children);
				}
    ;

comando: lvalue '=' expr  {
				Node** children;
				pack_nodes(&children,0,$1);
				pack_nodes(&children,1,create_leaf(lineno,atrib_node,"=",NULL));
				pack_nodes(&children,2,$3);
				$$ = create_node(lineno,comando_node,"",NULL,3,children);
				}
     | enunciado {
			$$ = $1;
			}
     ;

lvalue: IDF {
		entry_t* entry;
		entry = lookup(s_table,$1);
		if (entry == NULL) {
		  printf("UNDEFINED SYMBOL. A variavel %s nao foi declarada.\n", $1);
		  return UNDEFINED_SYMBOL_ERROR;
		}
		$$ = create_leaf(lineno,lvalue_node,$1,NULL);
		}
     | IDF '[' listaexpr ']' {
				entry_t* entry;
				entry = lookup(s_table,$1);
				if (entry == NULL) {
				  printf("UNDEFINED SYMBOL. A variavel %s nao foi declarada.\n", $1);
				  return UNDEFINED_SYMBOL_ERROR;
				}
				Node** children;
				pack_nodes(&children,0,create_leaf(lineno,idf_node,$1,NULL));
				pack_nodes(&children,1,create_leaf(lineno,abre_col_node,"[",NULL));
				pack_nodes(&children,2,$3);
				pack_nodes(&children,3,create_leaf(lineno,fecha_col_node,"]",NULL));
				$$ = create_node(lineno,lvalue_node,"",NULL,4,children);
				}
     ;

listaexpr: expr  {
			$$ = $1;
			}
	 | expr ',' listaexpr {
				Node** children;
				pack_nodes(&children,0,$1);
				pack_nodes(&children,1,create_leaf(lineno,comma_node,",",NULL));
				pack_nodes(&children,2,$3);
				$$ = create_node(lineno,listaexpr_node,"",NULL,3,children);
				}
	 ;

expr: expr '+' expr  {
			Node** children;
			pack_nodes(&children,0,$1);
			pack_nodes(&children,1,create_leaf(lineno,plus_node,"+",NULL));
			pack_nodes(&children,2,$3);
			$$ = create_node(lineno,expr_node,"",NULL,3,children);
			/*char* aux;
			aux = (char *)malloc((strlen($1) + strlen($3) + 1)*sizeof(char));
			strcpy(aux, $1);
			strcat(aux, $3);
			strcat(aux, "+");
			$$ = aux;*/	
    			}
    | expr '-' expr {
			Node** children;
			pack_nodes(&children,0,$1);
			pack_nodes(&children,1,create_leaf(lineno,minus_node,"-",NULL));
			pack_nodes(&children,2,$3);
			$$ = create_node(lineno,expr_node,"",NULL,3,children);
			/*char* aux;
			aux = (char *)malloc((strlen($1) + strlen($3) + 1)*sizeof(char));
			strcpy(aux, $1);
			strcat(aux, $3);
			strcat(aux, "-");
			$$ = aux;*/
			}
    | expr '*' expr {
			Node** children;
			pack_nodes(&children,0,$1);
			pack_nodes(&children,1,create_leaf(lineno,mult_node,"*",NULL));
			pack_nodes(&children,2,$3);
			$$ = create_node(lineno,expr_node,"",NULL,3,children);
			/*char* aux;
			aux = (char *)malloc((strlen($1) + strlen($3) + 1)*sizeof(char));
			strcpy(aux, $1);
			strcat(aux, $3);
			strcat(aux, "*");
			$$ = aux;*/
			}
    | expr '/' expr {
			Node** children;
			pack_nodes(&children,0,$1);
			pack_nodes(&children,1,create_leaf(lineno,div_node,"/",NULL));
			pack_nodes(&children,2,$3);
			$$ = create_node(lineno,expr_node,"",NULL,3,children);
			/*char* aux;
			aux = (char *)malloc((strlen($1) + strlen($3) + 1)*sizeof(char));
			strcpy(aux, $1);
			strcat(aux, $3);
			strcat(aux, "/");
			$$ = aux;*/
			}
    | '(' expr ')' {
			Node** children;
			pack_nodes(&children,0,create_leaf(lineno,abre_par_node,"(",NULL));
			pack_nodes(&children,1,$2);
			pack_nodes(&children,2,create_leaf(lineno,fecha_par_node,")",NULL));
			$$ = create_node(lineno,lvalue_node,"",NULL,3,children);
			/*$$ = $2;*/
			}
    | INT_LIT  {
		$$ = create_leaf(lineno,int_lit_node,$1,NULL);
		}
    | F_LIT {
		$$ = create_leaf(lineno,f_lit_node,$1,NULL);
		}
    | lvalue {
		$$ = $1;
		}
    | chamaproc {
			$$ = $1;
			}
    ;

chamaproc: IDF '(' listaexpr ')' {
					Node** children;
					pack_nodes(&children,0,create_leaf(lineno,idf_node,$1,NULL));
					pack_nodes(&children,1,create_leaf(lineno,abre_par_node,"(",NULL));
					pack_nodes(&children,2,$3);
					pack_nodes(&children,3,create_leaf(lineno,fecha_par_node,")",NULL));
					$$ = create_node(lineno,chamaproc_node,"",NULL,4,children);
					}
         ;

enunciado: expr {
			$$ = $1;
			/* printf("Expressão decomposta: %s\n ", $1);*/
			}
    | IF '(' expbool ')' THEN acoes fiminstcontrole {
							Node** children;
							pack_nodes(&children,0,create_leaf(lineno,if_node,"if",NULL));
							pack_nodes(&children,1,create_leaf(lineno,abre_par_node,"(",NULL));
							pack_nodes(&children,2,$3);
							pack_nodes(&children,3,create_leaf(lineno,fecha_par_node,")",NULL));
							pack_nodes(&children,4,create_leaf(lineno,then_node,"then",NULL));
							pack_nodes(&children,5,$6);
							pack_nodes(&children,6,$7);
							$$ = create_node(lineno,enunciado_node,"",NULL,7,children);
							}
    | WHILE '(' expbool ')' '{' acoes '}' {
						Node** children;
						pack_nodes(&children,0,create_leaf(lineno,while_node,"while",NULL));
						pack_nodes(&children,1,create_leaf(lineno,abre_par_node,"(",NULL));
						pack_nodes(&children,2,$3);
						pack_nodes(&children,3,create_leaf(lineno,fecha_par_node,")",NULL));
						pack_nodes(&children,4,create_leaf(lineno,abre_cha_node,"{",NULL));
						pack_nodes(&children,5,$6);
						pack_nodes(&children,6,create_leaf(lineno,fecha_cha_node,"}",NULL));
						$$ = create_node(lineno,enunciado_node,"",NULL,7,children);
						}
    ;

fiminstcontrole: END {
			$$ = create_leaf(lineno,end_node,"end",NULL);
			}
               | ELSE acoes END {
					Node** children;
					pack_nodes(&children,0,create_leaf(lineno,else_node,"else",NULL));
					pack_nodes(&children,1,$2);
					pack_nodes(&children,2,create_leaf(lineno,end_node,"end",NULL));
					$$ = create_node(lineno,fiminstcontrole_node,"",NULL,3,children);
					}
               ;

expbool: TRUE  {
		$$ = create_leaf(lineno,true_node,"true",NULL);
		}
       | FALSE {
		$$ = create_leaf(lineno,false_node,"false",NULL);
		}
       | '(' expbool ')' {
				Node** children;
				pack_nodes(&children,0,create_leaf(lineno,abre_par_node,"(",NULL));
				pack_nodes(&children,1,$2);
				pack_nodes(&children,2,create_leaf(lineno,fecha_par_node,")",NULL));
				$$ = create_node(lineno,expbool_node,"",NULL,3,children);
				}
       | expbool AND expbool {
				Node** children;
				pack_nodes(&children,0,$1);
				pack_nodes(&children,1,create_leaf(lineno,and_node,"&",NULL));
				pack_nodes(&children,2,$3);
				$$ = create_node(lineno,expbool_node,"",NULL,3,children);
				}
       | expbool OR expbool {
				Node** children;
				pack_nodes(&children,0,$1);
				pack_nodes(&children,1,create_leaf(lineno,or_node,"|",NULL));
				pack_nodes(&children,2,$3);
				$$ = create_node(lineno,expbool_node,"",NULL,3,children);
				}
       | NOT expbool {
			Node** children;
			pack_nodes(&children,0,create_leaf(lineno,not_node,"!",NULL));
			pack_nodes(&children,1,$2);
			$$ = create_node(lineno,expbool_node,"",NULL,2,children);
			}
       | expr '>' expr {
			Node** children;
			pack_nodes(&children,0,$1);
			pack_nodes(&children,1,create_leaf(lineno,sup_node,">",NULL));
			pack_nodes(&children,2,$3);
			$$ = create_node(lineno,expbool_node,"",NULL,3,children);
			}
       | expr '<' expr {
			Node** children;
			pack_nodes(&children,0,$1);
			pack_nodes(&children,1,create_leaf(lineno,inf_node,"<",NULL));
			pack_nodes(&children,2,$3);
			$$ = create_node(lineno,expbool_node,"",NULL,3,children);
			}
       | expr LE expr {
			Node** children;
			pack_nodes(&children,0,$1);
			pack_nodes(&children,1,create_leaf(lineno,inf_eq_node,"<=",NULL));
			pack_nodes(&children,2,$3);
			$$ = create_node(lineno,expbool_node,"",NULL,3,children);
			}
       | expr GE expr {
			Node** children;
			pack_nodes(&children,0,$1);
			pack_nodes(&children,1,create_leaf(lineno,sup_eq_node,">=",NULL));
			pack_nodes(&children,2,$3);
			$$ = create_node(lineno,expbool_node,"",NULL,3,children);
			}
       | expr EQ expr {
			Node** children;
			pack_nodes(&children,0,$1);
			pack_nodes(&children,1,create_leaf(lineno,eq_node,"==",NULL));
			pack_nodes(&children,2,$3);
			$$ = create_node(lineno,expbool_node,"",NULL,3,children);
			}
       | expr NE expr {
			Node** children;
			pack_nodes(&children,0,$1);
			pack_nodes(&children,1,create_leaf(lineno,neq_node,"!=",NULL));
			pack_nodes(&children,2,$3);
			$$ = create_node(lineno,expbool_node,"",NULL,3,children);
			}
       ;
%%
 /* A partir daqui, insere-se qlqer codigo C necessario.
  */

char* progname;
extern FILE* yyin;

int main(int argc, char* argv[]) 
{
   if (argc != 2) {
     printf("uso: %s <input_file>. Try again!\n", argv[0]);
     exit(-1);
   }
   yyin = fopen(argv[1], "r");
   if (!yyin) {
     printf("Uso: %s <input_file>. Could not find %s. Try again!\n", 
         argv[0], argv[1]);
     exit(-1);
   }

   progname = argv[0];

   if (!yyparse()) 
      printf("OKAY.\n");
   else 
      printf("ERROR.\n");

   return(0);
}

yyerror(char* s) {
  fprintf(stderr, "%s: %s", progname, s);
  fprintf(stderr, "line %d\n", lineno);
}
