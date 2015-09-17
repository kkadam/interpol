!Information from the SCF code (input)
       integer, parameter :: scfr = 258
       integer, parameter :: scfz = 258
       integer, parameter :: numphi = 512
       integer, parameter :: numr_deltar = 258     !Equatorial radius of single star
       integer, parameter :: deltar_parameter = 3.0   !1.5 for single star, 3 for binary
 
       double precision, parameter :: omega = 4.404728829210553E-002
       double precision, parameter :: pin = 1.5
       double precision, parameter :: kappac1 = 1.231708746466757E-003
       double precision, parameter :: kappae1 = 1.266267491908497E-002
       double precision, parameter :: kappac2 = 3.745880949439993E-003
       double precision, parameter :: kappae2 = 2.348778438870338E-002
       double precision, parameter :: rho_c1d = 2.945083967952876E-002
       double precision, parameter :: rho_1d = 1.472541983976438E-002
       double precision, parameter :: rho_c2e = 0.129803300551594
       double precision, parameter :: rho_2e = 6.490165027579706E-002
       double precision, parameter :: pres_d = 1.120224158043775E-005
       double precision, parameter :: pres_e = 2.461887961747880E-004
       double precision, parameter :: L1 = 0.209803921568627
       double precision, parameter :: nc1 = 3.00000000000000
       double precision, parameter :: ne1 = 1.50000000000000
       double precision, parameter :: nc2 = 3.00000000000000
       double precision, parameter :: ne2 = 1.50000000000000
 
       logical, parameter :: bipoly = .true.
       logical, parameter :: binary_system =.true.
 
!Gridsize of the hydro code (output)
       integer, parameter :: numr = 514
       integer, parameter :: numz = 258
 
       integer, parameter :: numr_procs = 32
       integer, parameter :: numz_procs = 16
       

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


