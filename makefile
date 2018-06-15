#

SUFFIX=.f

#FC=/opt/intel/composer_xe_2015.1.133/bin/intel64/ifort
FC = ifort
SAFE = -g -traceback
FFLAGS = -xhost -qopenmp -fpp -O3 -free $(SAFE)

LIB    =  -liomp5
INCS   = 

CFIX=.c
CFC = nvcc
#CFC = gcc
#GCC: CFLAGS = -O3 -funsafe-loop-optimizations -ftree-parallelize-loops=1024
CFLAGS = -O3 -m 64

#-----------------------------------------------------------------------
# general rules
#-----------------------------------------------------------------------

SOURCE = types_m.o \
		 constants_m.o \
		 diagnosis.o \
		 parms.o \
		 tuning.o \
		 topol.o \
		 RW.o \
		 gmx.o \
		 EDT.o \
		 crystal.o \
		 solvent.o \
		 elastic.o \
		 correlation.o \
		 statslw.o \
		 trj.o \
		 multiple_trj.o \
		 occupation_bin.o \
                 aminoacids.o \
		 edview.o

CSOURCE = Ccostslow.o

a: $(CSOURCE) $(SOURCE)  
	rm -f a
	$(FC) $(INCS) -o a $(SOURCE) $(CSOURCE) $(LIB) 
	-rm -f *.log



.f.o: $(CSOURCE)
	$(FC) $(FFLAGS) $(INCS) -c $*$(SUFFIX)


.c.o:
	$(CFC) -c $(CFLAGS) $*$(CFIX)



fcv:
	$(FC) -v
ccv:
	$(CFC) -V	
clean: 
	-rm -f *.o *.mod; touch *.f *~
