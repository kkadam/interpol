interpol
========
//Kundan Kadam July 15 2014

Purpose:
1. Shifts center of the cylindrical grid to the center of mass of the binary.
2. Changes the r and z resolution to a desired value. Does not change phi.
3. Changes the equatorial symmetry to no symmetry.
4. Writes input files for hydro code.

Required:
1. A binary density file (density.bin) from SCF code with equatorial symmetry. Resolution scfr, scfz, numphi.
2. Numerical values of omega, kappa1, kappac1, kappa2, kappac2, n1, nc1, n2, nc2 from SCF code.

How to use:
1. Edit convertpar.h file to specify required parameters from the SCF code and gridsize of the hydro code.
2. Make sure density file is in the correct format.
3. Make sure makefile uses correct compiler.
4. Do:
   >>make cl
   >>make
   >>./conv

