       integer, parameter :: numr = 514
       integer, parameter :: numz = 258
       integer, parameter :: numphi = 512
       integer, parameter :: oldnumr = 258
       double precision, parameter :: deltar_parameter = 3.0   !1.5 for single star
       double precision, parameter :: reallyadrag =  0.0 !% of AM removed/orbit
       double precision, parameter :: dragtime = 1.6 !number of orbits
 
       integer, parameter :: numr_procs = 16
       integer, parameter :: numz_procs = 8

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
!         data redistribution in the Poisson solver
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
