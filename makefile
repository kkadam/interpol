#compiler
#FC=/opt/intel/composerxe-2011.5.209/bin/intel64/ifort
#FC=/usr/local/bin/gfortran
#FC=/usr/bin/ifort
FC=/usr/local/compilers/Intel/intel_fc_11.1/bin/intel64/ifort

F90FILES= main.F90 initial_conditions.F90 com_initial.F90 fort.F90 fort_old.F90 cubic.F90




OFILES= $(F90FILES:.F90=.o) 

scf:$(OFILES)
#	$(FC) $(OFILES) -O3 -o conv 
#	$(FC) $(OFILES) -o conv
	$(FC) $(OFILES) -O0 -o conv


$(OFILES):$(F90FILES)
#	$(FC) -g -c -r8 -O3 $(F90FILES)
#	$(FC) -c $(F90FILES)
	$(FC) -c -O0 -r8 $(F90FILES)
	
#$(OFILES): startup.f prmtr.h

#.f.o: prmtr.h startup.F90
#	$(FC) -O3 -qarch=pwr3 -qtune=pwr3 -qhot -qfixed=132 -c $<

cl:
	rm -f *.o conv 
