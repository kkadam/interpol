!Information from the SCF code (input)
       integer, parameter :: scfr = 130
       integer, parameter :: scfz = 130
       integer, parameter :: numphi = 256
       integer, parameter :: numr_deltar = 130     !Equatorial radius of single star
       integer, parameter :: deltar_parameter = 3.0   !1.5 for single star, 3 for binary
 
       double precision, parameter :: omega = 9.024581800413496E-002
       double precision, parameter :: pin = 1.5
       double precision, parameter :: kappa1 = 3.372451912042818E-002
       double precision, parameter :: kappa2 = 2.463955123797566E-002
       double precision, parameter :: kappac1 = 8.106846554468953E-003
       double precision, parameter :: kappac2 = 5.773672023224734E-003
       double precision, parameter :: rho_c1 = 0.222248349191165
       double precision, parameter :: rho_c2 = 0.205862826412886
       double precision, parameter :: np1 = 3.00000000000000
       double precision, parameter :: np2 = 1.50000000000000
 
       logical, parameter :: bipoly = .true.
       logical, parameter :: binary_system =.true.
 
!Gridsize of the hydro code (output)
       integer, parameter :: numr = 162
       integer, parameter :: numz = 98
 
       integer, parameter :: numr_procs = 8
       integer, parameter :: numz_procs = 8
       

       integer, parameter :: padr = 2*numr   !Introduced to avoid clipping while interpolating
       
!Various useless parameters
       double precision, parameter :: pi = acos(-1.0)
       
       double precision, parameter :: gamma = 1+1.0/pin
       
       integer, parameter :: numr_dd = ( (numr - 2)/numr_procs ) + 2

       integer, parameter :: numz_dd = ( (numz - 2)/numz_procs ) + 2

       integer, parameter :: rlwb = 2, rupb = numr_dd - 1

       integer, parameter :: zlwb = 2, zupb = numz_dd - 1

       integer, parameter :: philwb = 1, phiupb = numphi

       integer, parameter :: numr_dd_z = (numr-2)/numz_procs + 2

       integer, parameter :: numphi_dd = numphi/numr_procs

       integer, parameter :: numphi_by_two = numphi / 2

       integer, parameter :: numphi_by_four = numphi / 4

       real, parameter :: numphiinv = 1.0 / numphi


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


