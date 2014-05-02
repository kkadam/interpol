       integer, parameter :: scfr = 256
       integer, parameter :: scfz = 256
       integer, parameter :: numphi = 512
       
       integer, parameter :: numr = 512 !256
       integer, parameter :: numz = 2*scfz-2
       
       integer, parameter :: numr_procs = 16
       integer, parameter :: numz_procs = 8
       
       integer, parameter :: numr_dd = ( (numr - 2)/numr_procs ) + 2
       integer, parameter :: numz_dd = ( (numz - 2)/numz_procs ) + 2
       
       double precision, parameter :: pi = acos(-1.0)
       
       double precision, parameter :: omega = abs(sqrt(0.0336))
       double precision, parameter :: com = -0.388452020466794 
