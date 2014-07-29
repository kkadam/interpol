subroutine shift(density,com)
  implicit none
  include "convertpar.h"

  double precision, dimension(numr,numz,numphi) :: density, newdensity
  double precision, dimension(numr) :: r
  double precision, dimension(numphi) :: phi  
!  double precision, dimension(numz) :: z
  double precision :: dr, dphi, com_norm, x, y0, x0, r0, phi0, &
                      rho1, rho2, rho3, rho4, x1, x2, x3, x4,  &
                      y1, y2, y3, y4, d1, d2, d3, d4,          &
                      rhos, rhol, vs, vl, v, test, com
  double precision :: rho5, rho6, rho7, rho8, w1, w2, w3, w4 
  
  
  integer :: i, j, k, l, rconv, rs, phis, rl, phil,p
  
!########################### Start Subroutine #########################
!  p=2	
	
  dr = 1.0/numr	
  dphi = 2.0*pi/numphi
  com_norm=com*scfr/numr
  
!#### Set up arrays ####   

  r(1) = dr/2.0
  do i = 2,numr
    r(i) = r(i-1) + dr 
  enddo  
  
  phi(1) = dphi/2.0
  do i = 2,numphi
    phi(i) = phi(i-1) + dphi
  enddo

!##### Visualize input ####
!  open(unit=10,file="star1i")
!         do j=1,numz
!           do i=1,numr  
!             write(10,*) i,j,density(i,j,1) 
!           enddo
!           write(10,*)
!         enddo
!  print*, "star1i"	

         
!  open(unit=10,file="star2i")
!         do j=1,numz
!           do i=1,numr  
!             write(10,*) i,j,density(i,j,numphi/2) 
!           enddo
!           write(10,*)
!         enddo
!       close(10) 
!  print*, "star2i"  
  
  
!#### Iterate over newdensity ####

  newdensity = 0.0	

  do i=1, numr
    do j=1, numz
      do k=1, numphi
      
        x = r(i)*cos(phi(k))
        y0 = r(i)*sin(phi(k))
        x0 = x-com_norm                  
        
        r0 = sqrt(x0**2 + y0**2)
        phi0 = atan2(y0,x0)+pi
        

        if (r0.lt.1.0) then
          
          rs=floor(r0/dr+1/2) !!	
          phis=floor(phi0/dphi) !!
          
          rl=rs+1 !!
          phil=phis+1 !!
          
          if (phis == 0) then !!
            phis = numphi !!
          endif !!

          if (phis == numphi) then !!
            phil = 1 !!
          endif !!
	  
	
  
!  print*,"floor r",floor(r0/dr+1/2),r0/dr+1/2,r0/dr+1/2.0, 1/2,1/2.0!"loop rs",rs, "r0", r0*512
!  print*,"floor z",floor(z0/dz+1/2),"loop zs",zs
!  print*,"floor phi",floor((phi0)*(numphi/(2*pi))),"loop phis", phis           
!        if (j==256) then
!          print*, rs,rl,phis,phil, phi0  !weirdass phi0's!
!        endif        
	
          
          rho1=density(rs,j,phis)      !
          rho2=density(rs,j,phil)      !
          rho3=density(rl,j,phis)      !
          rho4=density(rl,j,phil)      !  
        
          d1=r0*abs(phi0-phi(phis))
          d2=r0*abs(phi0-phi(phil))
          d3=r0*abs(phi0-phi(phis))
          d4=r0*abs(phi0-phi(phil))
        
          rhos=(rho1*d1+rho2*d2)/(d1+d2)
          rhol=(rho3*d3+rho4*d4)/(d3+d4)
          
         vs=(r(rs)+dr/2)**2-(r0-dr/2)**2   !
          vl=(r0+dr/2)**2-(r(rs)+dr/2)**2   !
	
          v=(r0+dr/2)**2-(r0-dr/2)**2          
          
          newdensity(i,j,k) = (rhol*vl+rhos*vs)/v
 
         else
            newdensity(i,j,k)=1d-10
         endif
        
      enddo
    enddo
  enddo


!#### Visualize output ####  
  
  do i=1, numr
    do j=1, numz
      do k=1, numphi
        density(i,j,k) = newdensity(i,j,k)
      enddo
    enddo
  enddo	
	
  
!  open(unit=10,file="star1o")
!         do j=1,numz
!           do i=1,numr  
!             write(10,*) i,j,density(i,j,1) 
!             enddo
!           write(10,*)
!         enddo
!  close(10) 
!  print*, "star1o"
         
!  open(unit=12,file="star2o")
!         do j=1,numz
!           do i=1,numr  
!             write(12,*) i,j,density(i,j,numphi/2) 
!           enddo
!           write(12,*)
!         enddo
!  close(12) 
!  print*, "star2o"  

  
end subroutine shift
