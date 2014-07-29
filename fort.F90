subroutine fort
  implicit none
  include "convertpar.h"
  
  double precision :: temp_dbl1, temp_dbl2, temp_dbl3, temp_dbl4
  integer :: temp_int1, temp_int2, temp_int3, temp_int4



  OPEN(UNIT=10,FILE="fort.7")
  temp_int1 = 1
  temp_int2 = 0
  WRITE(10,*) temp_int1,temp_int2                          !1
  temp_int1 = 100001
  temp_int2 = 110001
  temp_int3 = 100
  WRITE(10,*) temp_int1, temp_int2, temp_int3     	   !2
  temp_int1 = 3 
  temp_int2 = 1
  temp_int3 = 0
  WRITE(10,*) temp_int1, temp_int2, temp_int3              !3 
  temp_dbl1 = 1.5
  temp_dbl2 = 1.6666666666666667
  temp_dbl3 = 0.0                                          !No kappas
  WRITE(10,*) temp_dbl1, temp_dbl2, temp_dbl3, temp_dbl3   !4
  temp_dbl1 = 120.0
  WRITE(10,*) omega, temp_dbl1, omega                      !5
  temp_dbl1 = 5.0
  temp_dbl2 = 0.0
  WRITE(10,*) temp_dbl1, temp_dbl2                         !6
  temp_dbl1 = 1.0e-10
  temp_dbl2 = 1.0e-11
  WRITE(10,*) temp_dbl1, temp_dbl2                         !7 
  temp_int1 = 3
  WRITE(10,*) temp_int1, temp_int1, temp_int1              !8
  temp_dbl1 = 1.0e-5 
  temp_dbl2 = 0.19000000000
  temp_dbl3 = 2.0
  WRITE(10,*) temp_dbl1, temp_dbl2, temp_dbl3              !9 

  CLOSE(10)
  write(*,*) "File fort.7 printed"	  
  
end subroutine fort  


!*
!*********************************************************************************
!*
!*  Expected format of input file called fort.7
!*
!  isym				model_type
!  1 => no symmetry		0 => an initital binary model
!  2 => equatorial symmetry	1 => continuation of evolution
!  3 => pi symmetry		2 => debugging model
!
!  tstart		tstop			do_diag
!  starting timestep #  ending timestep #	call diagnostic program
!						every do_diag timesteps
!
!  isoadi		call_pot		zero_out
!  3 => polytropic	0 => not self-		0 => don't zero out at axis
!  evolution		gravitating		# => zero out variables for
!                       1 => solve for		inner zero_out zones in j 
!                       self-gravity		for all k and l
!                       potential of fluid
!
!  pin			gamma		 
!  polytropic   	polytropic 	
!  index		exponent	
!                               
!                             
!
! kappa1			kappa2	
! polytropic constant for 	polytropic constant for	
! 0 <= phi < pi/2		pi/2 <= phi < 3 pi/2
! 3 pi/2 <= phi < 0       
!
!                               
! kappac1			kappac2	
! polytropic constant for	polytropic constant for	
! the core 			the core
! 0 <= phi < pi/2		pi/2 <= phi < 3 pi/2
! 3 pi/2 <= phi < 0   	
!
!
! rho_c1			rho_c2
! threshold density above 	threshold density above
! which the material		which the material
! belongs to the core for 	belongs to the core for
! star1				star2
!	
!		
!  omgfrm		intrvl			scfomega
!  angular frequency	number of frames to	angular frequency of
!  of rotating frame	output per orbit	initial model
!  omgfrm = 0 =>
!  inertial frame
!  calculation
!
!  vmax				constp
!  maximum allowed velocity	to simulate a uniform
!  for material above		pressure background, set
!  den_cutoff			p to constp if p is less
!				than constp
!
!  densmin			taumin
!  floor value for density	floor value for tau = (rho eps)**1/gamma
!  shouldn't change the values of taumin and densmin during a run
!
!  boundary_condition(1)	boundary_consition(2)	boundary_condition(3)
!  bottom of grid		side of grid		top of grid
!
!  for all boundary condition entries a value of: 
!                                        1 => wall boundary
!  					 2 => free boundary
!					 3 => dirichlet boundary condition
!					      or the free flow off grid
!					      condition
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
	
