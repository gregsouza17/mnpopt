#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>



void cslwcost_(int *Msize, _Bool mask[*Msize][3]){
  int i1,i2;

  //Printar num arquivo pra testar
  
  printf("Hi, im in C!!!\n");
  
    for (i1 = 0; i1 <10 ; ++i1) {
      printf("\t");
      for(i2=0; i2 < 3; ++i2){
	printf("%d ", mask[i1][i2]);	     
      }
    }
}
