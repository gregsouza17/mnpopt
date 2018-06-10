#

SUFFIX=.f

#FC=/opt/intel/composer_xe_2015.1.133/bin/intel64/ifort
FC = ifort
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
		 stat.o \
		 trj.o \
		 multiple_trj.o \
		 occupation_bin.o \
                 aminoacids.o \
		 edview.o

a: $(SOURCE)  
	rm -f a
	$(FC) $(INCS) -o a $(SOURCE) $(LIB) 
	-rm -f *.log
.f.o:
	$(FC) $(FFLAGS) $(INCS) -c $*$(SUFFIX)

fcv:
	$(FC) -v

clean: 
	-rm -f *.o *.mod; touch *.f *~
