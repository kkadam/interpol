subroutine fort_const_gamma(com_i)
  implicit none
  include "convertpar.h"

  double precision, intent(in) :: com_i

  integer :: isym, model_type, tstart, tstop, do_diag, isoadi, call_pot, &
             zero_out, bc1, bc2, bc3
  double precision :: vmax, constp, densmin, taumin, rho_boundary, q,    &
                      viscosity, gammac1, gammae1, gammac2, gammae2,     &
                      rho_th1, rho_th2
  double precision :: tauarray(4)


  densmin = 1.0e-10 

  rho_th1=(rho_c1d+rho_1d)/2
  rho_th2=(rho_c2e+rho_2e)/2

  gammac1 = 1.0+1/nc1
  gammae1 = 1.0+1/ne1
  gammac2 = 1.0+1/nc2
  gammae2 = 1.0+1/ne1

  tauarray(1) = (kappae1/(gammae1-1))**(1/gammae1)*densmin
  tauarray(2) = (kappae2/(gammae2-1))**(1/gammae2)*densmin
  tauarray(3) = (kappac1/(gammac1-1))**(1/gammac1)*densmin
  tauarray(4) = (kappac2/(gammac2-1))**(1/gammac2)*densmin

  taumin = minval(tauarray)

  OPEN(UNIT=10,FILE="template/run/fort.7")
  
  isym = 1
  model_type = 0
  WRITE(10,*) isym, model_type                             !1
  
  tstart = 1
  tstop = 900001
  do_diag = 100
  WRITE(10,*) tstart, tstop, do_diag                	   !2
  
  isoadi = 3
  call_pot = 1
  zero_out = 0
  WRITE(10,*) isoadi, call_pot, zero_out                   !3 
  
  WRITE(10,*) pin, gamma                                     !8

  WRITE(10,*) kappae1, kappae2                               !5

  WRITE(10,*) kappac1, kappac2                             !6

  WRITE(10,*) rho_th1, rho_th2                             !7

  WRITE(10,*) nc1, ne1                             !7
  
  if (omega.lt.1d-2) then
    WRITE(10,*) omega, 120, 0.4                            !9
  else
    WRITE(10,*) omega, 120, omega
  endif

  vmax = 5.0                   
  constp = 0.0
  WRITE(10,*) vmax, constp                                 !10  

  WRITE(10,*) densmin, taumin                              !11
  
  bc1 = 3
  bc2 = 3
  bc3 = 3
  WRITE(10,*) bc1, bc2, bc3                                !12
  
  rho_boundary = 1.0e-5 
  q = 0.0000000001
  viscosity = 2.0
  WRITE(10,*) rho_boundary, q, viscosity                   !13 

  WRITE(10,*) com_i                                        !14


  CLOSE(10)
  write(*,*) "File fort.7 printed"	  
  
end subroutine fort_const_gamma

!*
!*********************************************************************************
!*
!*  Expected format of input file called fort.7
!*
!  isym                         model_type
!  1 => no symmetry             0 => an initital binary model
!  2 => equatorial symmetry     1 => continuation of evolution
!  3 => pi symmetry             2 => debugging model
!
!  tstart               tstop                   do_diag
!  starting timestep #  ending timestep #       call diagnostic program
!                                               every do_diag timesteps
!
!  isoadi               call_pot                zero_out
!  3 => polytropic      0 => not self-          0 => don't zero out at axis
!  evolution            gravitating             # => zero out variables for
!                       1 => solve for          inner zero_out zones in j 
!                       self-gravity            for all k and l
!                       potential of fluid
!
!  n(1)                         n(2) 
!  Structural polytropic        Structural polytropic
!  index of the core of         index of envelope of
!  star1                        star1
!
!
!  n(3)                         n(4) 
!  Structural polytropic        Structural polytropic
!  indx of the core of          indx of the envelope of
!  star2                        star2
!                                                            
!
! kappa(1)                      kappa(2)                        !bipoly 
! polytropic constant for       polytropic constant for 
! core, star1                   envelope, star1
!        
!
! kappa(3)                      kappa(4)                        !bipoly 
! polytropic constant for       polytropic constant for 
! core, star2                   envelope, star2
!                               
!
! rho_c1                        rho_c2
! threshold density above       threshold density above
! which the material            which the material
! belongs to the core for       belongs to the core for
! star1                         star2
!
!
!  omgfrm               intrvl                  scfomega
!  angular frequency    number of frames to     angular frequency of
!  of rotating frame    output per orbit        initial model
!  omgfrm = 0 =>
!  inertial frame
!  calculation
!
!  vmax                         constp
!  maximum allowed velocity     to simulate a uniform
!  for material above           pressure background, set
!  den_cutoff                   p to constp if p is less
!                               than constp
!
!  densmin                      taumin
!  floor value for density      floor value for tau = (rho eps)**1/gamma
!  shouldn't change the values of taumin and densmin during a run
!
!  boundary_condition(1)        boundary_consition(2)   boundary_condition(3)
!  bottom of grid               side of grid            top of grid
!
!  for all boundary condition entries a value of: 
!                                        1 => wall boundary
!                                        2 => free boundary
!                                        3 => dirichlet boundary condition
!                                             or the free flow off grid
!                                             condition
!
!  rho_boundary                 q
!  value of the density         a parameter that divides the grid between
!  that marks the transition    the two stars.  It appears in the equation
!  from the star to the         of the line connecting the center of mass
!  envelope                     of the system and the maximum density point
!                               on the grid.  0 <= q <= 1
!
!
!  viscosity
!  isotropic coeeficient of the 
!  artificial viscosity
!
!*
!*********************************************************************************      
