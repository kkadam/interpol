!Gridsize of the SCF code (input)
       integer, parameter :: scfr = 130!256
       integer, parameter :: scfz = 130!130!256
       integer, parameter :: numphi = 256

       double precision, parameter :: omega = 0.187582645012247 
       
!Gridsize of the hydro code (output)       
       integer, parameter :: numr = 130!130
       integer, parameter :: numz = 130!130
       
       integer, parameter :: numr_procs = 16
       integer, parameter :: numz_procs = 8
       
       integer, parameter :: numr_dd = ( (numr - 2)/numr_procs ) + 2
       integer, parameter :: numz_dd = ( (numz - 2)/numz_procs ) + 2
       
       double precision, parameter :: pi = acos(-1.0)
       



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


