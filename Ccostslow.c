#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <time.h>



void cslwcost_(int *N_atoms, int *Size_trj, bool mask[3][*N_atoms],
	       double xyz[3][*N_atoms][*Size_trj], double cost[*Size_trj],
	       double *ctime){
  /*  A c module to be called from the
    subroutine Most_Representative_Configuration
    in stat.f (or statslw.f).

    Input: Adresses of Number of Atoms (N_Atoms),
    Size of Trajectorie Size_trj
    Boolean Mask (3, Numbe of atoms)
    Positions xyz (3, Number of atoms, Size of trj)
    Cost array

    Output: Sums the costs of each position in xyz(:,:, i1) in the cost(i1)*/
  
  int i1,i2,j,k;
  double soma;
  clock_t t;


  soma = 0;
  t = clock();
  for (i1 = 0  ; i1 < *Size_trj  ; ++i1) {    
    for (i2 = 0;   i2< *Size_trj  ; ++i2) {
      if(i1 != i2){
	soma = 0;
	for(j=0;   j<*N_atoms;   j++){
	  for(k=0;   k<3;    k++){

	     if(  mask [k] [j] ){
	       soma+=(xyz[k][j][i1] - xyz[k][j][i2])*(xyz[k][j][i1] - xyz[k][j][i2]);
	     }
	    
	  } //for k
	} //for j
       	cost[i1]+=soma;
      } //for if
    } //for i2
  } //for i1
  t = clock() - t;
  *ctime = (double) t/CLOCKS_PER_SEC;
}
  
  /*
  FILE *fpCost;
  fpCost = fopen("tst/Ccostcpu.dat", "w+");
  for(i1 = 0;   i1<*Size_trj;    ++i1)
  fprintf(fpCost, "%d \t %f \n",     i1,  cost[i1] ); */



  

 





//TESTS ===========================
  
  /* FILE *fp; */
  /* fp = fopen("tst/maksCtst.dat", "w+"); */

  //Test for xyz being passed corretclty from fortran to the C moduel
  
  /* for (i1 = 0; i1 < *Size_trj; i1+=103) { */
  /*   for(j =0; j< *N_atoms; j+=101){ */
  /*     for(k=0; k<3; k++){ */
  /* 	fprintf(fp, "%d %d: %f" , i1,j, xyz[k][j][i1]); */
  /*     } */
  /*     fprintf(fp, "\n"); */
  /*   } */
  /*   fprintf(fp, "\n"); */
  /* } */



  /* for (i1 = 0; i1 < *Size_trj; ++i1) { */
  /*   fprintf(fp, "%d : %f\n",i1, cost[i1]); */
  /* } */
