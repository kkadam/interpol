!Information from the SCF code (input)
       integer, parameter :: scfr = 130
       integer, parameter :: scfz = 130
       integer, parameter :: numphi = 256
       integer, parameter :: numr_deltar = 130     !Equatorial radius of single star
       double precision, parameter :: deltar_parameter = 3.0   !1.5 for single star, 3 for binary
 
       double precision, parameter :: omega = 8.550655988880393E-002
       double precision, parameter :: pin = 1.5
       double precision, parameter :: kappac1 = 7.519362931687612E-003
       double precision, parameter :: kappae1 = 3.087168650100215E-002
       double precision, parameter :: kappac2 = 5.761107721195464E-003
       double precision, parameter :: kappae2 = 2.673249687769376E-002
       double precision, parameter :: rho_c1d = 0.462393854652452
       double precision, parameter :: rho_1d = 0.231196927326226
       double precision, parameter :: rho_c2e = 0.320294433680240
       double precision, parameter :: rho_2e = 0.160147216840120
       double precision, parameter :: pres_d = 2.688626357476500E-003
       double precision, parameter :: pres_e = 1.262520728894580E-003
       double precision, parameter :: L1 = 0.0
       double precision, parameter :: nc1 = 3.00000000000000
       double precision, parameter :: ne1 = 1.50000000000000
       double precision, parameter :: nc2 = 3.00000000000000
       double precision, parameter :: ne2 = 1.50000000000000
 
       logical, parameter :: bipoly = .true.
       logical, parameter :: binary_system =.true.
 
!Gridsize of the hydro code (output)
       integer, parameter :: numr = 258
       integer, parameter :: numz = 130
 
       integer, parameter :: numr_procs = 16
       integer, parameter :: numz_procs = 16
 
       logical, parameter :: const_gamma = .true. 

       integer, parameter :: padr = 2*scfr   !Introduced to avoid clipping while interpolating


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


