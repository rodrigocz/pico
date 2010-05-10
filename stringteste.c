#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main() {
  char* str1 = "20";
  char* str2 = "5";
  char* str3;

  str3 = (char *)malloc((strlen(str1) + strlen(str2) + 2)*sizeof(char));

  strcpy(str3, str1);
  strcat(str3, str2);
  strcat(str3, "+");
  
  printf("str3: %s\n", str3);

  free(str3);

}



/*
main()
{
	char* aux;
	char* s1;
	char* s2;
	char* s3;

	s1 = "20";
	s2 = "15";
	printf("%d ", (strlen(s1) + strlen(s2) + 1));
	
	printf("%s ", s3);

 	aux = malloc(sizeof(char) * (strlen(s1) + strlen(s2) + 1));
	s3 = strcat(s3, s1);
// 	memcpy((void*) aux,(void*) s3, sizeof(char)*strlen(s1));

	printf("%d ", strlen(aux));
       
//	aux = strcat(s1, s2);
	
//	printf("%d ", strlen(aux));

//	printf("aux: %s\n", aux)
	aux = strcat(s1, s2);
//	printf("aux: %s\n", aux);

}
*/
