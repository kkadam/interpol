!Gridsize of the SCF code (input)
       integer, parameter :: scfr = 128!130!256
       integer, parameter :: scfz = 130!130!256
       integer, parameter :: numphi = 256!512

       double precision, parameter :: omega = 0.226163454382543 
       
!Gridsize of the hydro code (output)       
       integer, parameter :: numr = 130!354
       integer, parameter :: numz = 10!2*scfz-2!258 
       
       integer, parameter :: numr_procs = 16
       integer, parameter :: numz_procs = 8
       
       integer, parameter :: numr_dd = ( (numr - 2)/numr_procs ) + 2
       integer, parameter :: numz_dd = ( (numz - 2)/numz_procs ) + 2
       
       double precision, parameter :: pi = acos(-1.0)
       

!       double precision, parameter :: com = -0.388452020466794 


! restrictions on the above parameters:
!
!  numphi must be a power of two
!
!  (numr - 2) must be evenly divisible by numr_procs
!
!  (numz - 2) must be evenly divisible by numz_procs
!
!  numphi has to be evenly divisible by numr_procs for the
!         data redistribution in the Poisson solver,
!         keep it same as scf code
!
!  (numr-2) must be evenly divisible by numz_procs for the
!           data redistribution in the Poisson solver
!
!  numr_procs must be greater than or equal to two
!
!  numz_procs must be greater than or equal to two
!
!  numr_procs must be an even number
!
!  numz_procs must be an even number
