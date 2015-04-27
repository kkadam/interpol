subroutine com_final(rho_pad, com)
  implicit none
  include 'convertpar.h'

  double precision, intent(in) :: rho_pad(padr,scfz,numphi)
  double precision, intent(out) :: com

  double precision, dimension(numphi) :: cosine, phi
  integer :: I, J, K
  double precision, dimension(numr) :: rh
  double precision :: x, dr, dz, dphi, dm, total_mass, numarator
!*
!********************************************************************************
!*
!* 
	
  total_mass=0.0
  numarator=0.0
  rh=0.0
  com=0.0    

  dr=1.0/(padr-3.0)
  dz=dr
  dphi = 2.0*pi/numphi
  
  
  do i=1, padr
    rh(i)=(i-1)*dr-dr/2
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
    do J  = 2, scfz-1
      do I = 2, padr-1  

          dm= rho_pad(i,j,k)*rh(i)*2*dr*dz*dphi
          total_mass=total_mass+dm  
          numarator=numarator+dm*rh(i)*cosine(k)
          
      enddo
   enddo
  enddo  
  
  com=numarator/total_mass
  
return
end subroutine com_final


