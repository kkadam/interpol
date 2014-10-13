!Information from the SCF code (input)
       integer, parameter :: scfr = 130
       integer, parameter :: scfz = 130
       integer, parameter :: numphi = 256
       integer, parameter :: numr_deltar = 60
       double precision, parameter :: deltar_parameter = 1.5      !1.5 for single star

       double precision, parameter :: omega = 5.491239714772673E-003
       double precision, parameter :: pin = 1.5
       double precision, parameter :: kappa1 = 0.239857137710960
       double precision, parameter :: kappa2 = 0.239857137710960
       double precision, parameter :: kappac1 = 4.543891552918972E-002
       double precision, parameter :: kappac2 = 4.543891552918972E-002
       double precision, parameter :: rho_c1 = 0.2
       double precision, parameter :: rho_c2 = 0.2
       double precision, parameter :: np1 = 3.0
       double precision, parameter :: np2 = 1.5
       
       logical, parameter :: bipoly = .true.
       logical, parameter :: binary_system = .false.
!Gridsize of the hydro code (output)       
       integer, parameter :: numr = 130
       integer, parameter :: numz = 130
       
       integer, parameter :: numr_procs = 8
       integer, parameter :: numz_procs = 8
       
       
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


