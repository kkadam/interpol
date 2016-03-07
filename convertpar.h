!Information from the SCF code (input)
       integer, parameter :: scfr = 130
       integer, parameter :: scfz = 64
       integer, parameter :: numphi = 256
       integer, parameter :: numr_deltar = 130     !Equatorial radius of single star
       integer, parameter :: deltar_parameter = 3.0   !1.5 for single star, 3 for binary
 
       double precision, parameter :: omega = 9.793983350312327E-002
       double precision, parameter :: pin = 1.5
       double precision, parameter :: kappac1 = 6.594760521067148E-003
       double precision, parameter :: kappae1 = 2.807214856112265E-002
       double precision, parameter :: kappac2 = 8.417951518691534E-003
       double precision, parameter :: kappae2 = 3.384277152837496E-002
       double precision, parameter :: rho_c1d = 0.414877713475908
       double precision, parameter :: rho_1d = 0.207438856737954
       double precision, parameter :: rho_c2e = 0.492460580603390
       double precision, parameter :: rho_2e = 0.246230290301695
       double precision, parameter :: pres_d = 2.109163616551090E-003
       double precision, parameter :: pres_e = 3.379888460625053E-003
       double precision, parameter :: L1 = 4.330708661417323E-002
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


