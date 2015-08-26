!Information from the SCF code (input)
       integer, parameter :: scfr = 130
       integer, parameter :: scfz = 130
       integer, parameter :: numphi = 256
       integer, parameter :: numr_deltar = 130     !Equatorial radius of single star
       integer, parameter :: deltar_parameter = 3.0   !1.5 for single star, 3 for binary
 
       double precision, parameter :: omega = 5.993518241988084E-002
       double precision, parameter :: pin = 1.5
       double precision, parameter :: kappa1 = 1.156969134062987E-002
       double precision, parameter :: kappa2 = 1.897421743375748E-002
       double precision, parameter :: kappac1 = 2.577671422755799E-003
       double precision, parameter :: kappac2 = 4.205512553511600E-003
       double precision, parameter :: rho_c1d = 0.353889217105572
       double precision, parameter :: rho_1d = 0.176944608552786
       double precision, parameter :: rho_c2e = 0.348429694600532
       double precision, parameter :: rho_2e = 0.174214847300266
       double precision, parameter :: pres_d = 6.452341278929113E-004
       double precision, parameter :: pres_e = 1.031111935575959E-003
       double precision, parameter :: L1 = 0.106299212598425
       double precision, parameter :: np1 = 3.00000000000000
       double precision, parameter :: np2 = 1.50000000000000
 
       logical, parameter :: bipoly = .true.
       logical, parameter :: binary_system =.true.
 
!Gridsize of the hydro code (output)
       integer, parameter :: numr = 258
       integer, parameter :: numz = 130
 
       integer, parameter :: numr_procs = 16
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


