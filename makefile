#compiler
FC=/opt/intel/composerxe-2011.5.209/bin/intel64/ifort

F90FILES= main.F90 shift.F90 densityinterpolate.F90

# driver8.F90

OFILES= $(F90FILES:.F90=.o) 

scf:$(OFILES)
	$(FC) $(OFILES) -O3 -o conv 

$(OFILES):$(F90FILES)
	$(FC) -g -c -r8 -O3 $(F90FILES)
	
#$(OFILES): startup.f prmtr.h

#.f.o: prmtr.h startup.F90
#	$(FC) -O3 -qarch=pwr3 -qtune=pwr3 -qhot -qfixed=132 -c $<

cl:
	rm -f *.o conv 
