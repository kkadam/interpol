subroutine com_final(rho, com_new)
  implicit none
  include 'convertpar.h'

  double precision :: rho(numr,numz,numphi)
  double precision, dimension(numphi) :: cosine, phi
  integer :: I, J, K
  double precision, dimension(numr) :: r
  double precision :: x, dr, dz, dphi,total_mass, numarator, dm
  double precision, intent(out) :: com_new
!*
!********************************************************************************
!*
!* 
	
  total_mass=0.0
  numarator=0.0
  r=0.0
  com_new=0.0    

  dr=1.0/(numr-3.0)
  dz=dr
  dphi = 2.0*pi/numphi
  
  
  do i=1, numr
    r(i)=(i-1)*dr-dr/2
  enddo

  x = 0.0
  do i = 1, numphi
    phi(i) = x * dphi
    x = x + 1.0 
  enddo
 
  do i = 1, numphi
    cosine(i) = cos(phi(i))
  enddo
  
  do K = 1, numphi
    do J  = 2, numz-1
      do I = 2, numr-1  

          dm= rho(i,j,k)*r(i)*2*dr*dz*dphi
          total_mass=total_mass+dm  
          numarator=numarator+dm*r(i)*cosine(k)
          
      enddo
   enddo
  enddo  
  
  com_new=numarator/total_mass   
  
  
return
end subroutine com_final
