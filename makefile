#

SUFFIX=.f
CFIX=.c
#FC=/opt/intel/composer_xe_2015.1.133/bin/intel64/ifort
FC = ifort
CFC= nvcc
SAFE = -g -traceback
FFLAGS = -xhost -qopenmp -fpp -O3 -free $(SAFE)

LIB    =  -liomp5
INCS   = 

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
	@echo "!!!Compilling the C Stuff!!!"
	$(CFC) -c $*$(CFIX)



fcv:
	$(FC) -v
ccv:
	$(CFC) -V	
clean: 
	-rm -f *.o *.mod; touch *.f *~
