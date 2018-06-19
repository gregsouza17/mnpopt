#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <time.h>
#include <cuda.h>
#include <cuda_runtime.h>


extern __shared__ double cache[];

__global__ void kernel(int *Ss, int *Nn, int *mask, double *xyz,
		       double *cost){

  //block idx in 0, S
  //thread idx X 0,S and thread Idx Y 0,N
  //mask (N*k + j), cost( i1) xyz (N*S*k + S*j + i2)
  //cache =[threadIdx.x + threadIdx.y*blockDim.x]

  double temp=0;
  long int i1,i2,j, joffset=blockDim.y,i2offset=blockDim.x;
  int k, N=*Nn, S = *Ss, cacheIndex, cIndexMax;
  i1 = blockIdx.x; i2 = threadIdx.x;

  cacheIndex = threadIdx.x + threadIdx.y*blockDim.x;
  cIndexMax = blockDim.x*blockDim.y;


  while(i2<S){
   
    j = threadIdx.y;
    while(j<N){
      if (i1!=i2){ 
	// temp=0; 
	for(k=0; k<3; k++){
      
	  if( mask[k*N+j] ){ 
	
	//	temp+=1; 

	    //  printf("%f \t", xyz[i1+S*(j+N*k)]);
	    temp+=
	      (xyz[i1+S*(j+N*k)] - xyz[i2+S*(j+N*k)])* 
	      (xyz[i1+S*(j+N*k)] - xyz[i2+S*(j+N*k)]) ; 
	
	  } //if mask 
	  __syncthreads();
	} //k

      } //if i1!=i2
  
   
      __syncthreads();
      j+=joffset;
  } //while j<N;
    __syncthreads();
   i2+=i2offset;
  } //while i2<S

  __syncthreads();
   cache[cacheIndex]+= temp;


 

 
  //Somar todos os indices do cache aqui
  //ofset separado

   __syncthreads();
  int i = cIndexMax/2;
  while (i != 0) {
    if (cacheIndex < i)
      cache[cacheIndex] += cache[cacheIndex + i];
    __syncthreads();
    i /= 2;
    
  }


  __syncthreads();

  cost[i1] = cache[0];
 
}




extern "C"
void cslwcost_(int *N_atoms, int *Size_trj, int mask[],
	       double xyz[], double cost[], double *ctime)
{
  /*  A c module to be called from the
    subroutine Most_Representative_Configuration
    in stat.f (or statslw.f).

    Input: Adresses of Number of Atoms (N_Atoms),
    Size of Trajectorie Size_trj
    Boolean Mask (3, Numbe of atoms)
    Positions xyz (3, Number of atoms, Size of trj)
    Cost array

    Output: Sums the costs of each position in xyz(:,:, i1) in the cost(i1)*/
  
  int *dev_S, *dev_N;

  cudaMalloc((void **)&dev_S, sizeof(int));
  cudaMalloc((void **)&dev_N, sizeof(int));

  cudaMemcpy(dev_S, Size_trj, sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(dev_N, N_atoms, sizeof(int), cudaMemcpyHostToDevice);

  int *dev_mask;

  cudaMalloc((void **)&dev_mask, 3*(*N_atoms)*sizeof(int));
  
  cudaMemcpy(dev_mask,  mask,  3*(*N_atoms)*sizeof(int),
	     cudaMemcpyHostToDevice);

  double *dev_xyz, *dev_cost;

  cudaMalloc((void **)&dev_xyz, 3*(*N_atoms)*(*Size_trj)*sizeof(double));

  cudaMalloc((void **)&dev_cost, *Size_trj*sizeof(double));

  cudaMemcpy(dev_xyz, xyz, 3*(*N_atoms)*(*Size_trj)*sizeof(double),
	     cudaMemcpyHostToDevice);

  int trdX = 2, trdY=2, cacheSize;
  cacheSize = trdX*trdY;

  dim3 threads(trdX, trdY);

  kernel<<<*Size_trj, threads, cacheSize*sizeof(double)>>>
    (dev_S, dev_N, dev_mask, dev_xyz, dev_cost);

  cudaMemcpy(cost, dev_cost, *Size_trj*sizeof(double),
	     cudaMemcpyDeviceToHost);
  

    FILE *fp; 
   fp = fopen("tst/GPU_RMSDCPU.dat", "w+"); 
   int i1;
   for(i1=0; i1<*Size_trj; i1++) 
     fprintf(fp, "%d %f \n", i1, cost[i1]); 
  
  cudaFree(dev_S); cudaFree(dev_N); cudaFree(dev_xyz);
  cudaFree(dev_cost); cudaFree(dev_mask);

  

  



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


 //Cost computing
  /* soma = 0; */

  /* for (i1 = 0  ; i1 < *Size_trj  ; ++i1) { */
  /*   for (i2 = 0;   i2< *Size_trj  ; ++i2) { */
  /*     if(i1 != i2){ */
  /* 	soma = 0; */
  /* 	for(j=0;   j<*N_atoms;   j++){ */
  /* 	  for(k=0;   k<3;    k++){ */

  /* 	     if(  mask [k*N+j] ){ */
  /* 	       soma+=(xyz[i1+ S*(j + N*k)] -xyz[i2+ S*(j + N*k)])* */
  /* 		 (xyz[i1+ S*(j + N*k)] -xyz[i2+ S*(j + N*k)]) ; */
  /* 	     } */
	    
  /* 	  } //for k */
  /* 	} //for j */
  /*      	cost[i1]+=soma; */
  /*     } //for if */
  /*   } //for i2 */
  /* } //for i1 */


/*   t = clock() - t; */
/*   *ctime = (double) t/CLOCKS_PER_SEC; */
