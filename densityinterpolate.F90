subroutine densityinterpolate(rho,r,phi,z,rhoint)
  implicit none
  include "convertpar.h"
!###### Declare Input Variables ######

 double precision :: r            ! exact r
 double precision :: phi          ! exact phi
 double precision :: z            ! exact z

!###### Return variable
 double precision :: phiint

!###### Global Variables used ######
 integer :: nr,nphi,nz
 double precision :: rho(numr,numz,numphi)
 double precision :: dr,dz

!###### Derived from global variables ######
 double precision :: rho1         ! density at r(n),phi(n+1),z(n+1)
 double precision :: rho2         ! density at r(n),phi(n),z(n+1)
 double precision :: rho3         ! density at r(n),phi(n+1),z(n)
 double precision :: rho4         ! density at r(n),phi(n),z(n)

 double precision :: rho5         ! density at r(n+1),phi(n+1),z(n+1)
 double precision :: rho6         ! density at r(n+1),phi(n),z(n+1)
 double precision :: rho7         ! density at r(n+1),phi(n+1),z(n)
 double precision :: rho8         ! density at r(n+1),phi(n),z(n)

!###### Declare Output Variables ######

 double precision :: rhoint       ! final rho to return.

!###### Declare Other Variables ######

integer :: rn                    ! lower integer r
integer :: phin                  ! lower integer phi
integer :: zn                    ! lower integer z

integer :: phinplus


 double precision :: d1           ! distance from r(n),phi,z to rho1 point
 double precision :: d2           ! distance from r(n),phi,z to rho2 point
 double precision :: d3           ! distance from r(n),phi,z to rho3 point
 double precision :: d4           ! distance from r(n),phi,z to rho4 point

 double precision :: d5           ! distance from r(n+1),phi,z to rho5 point
 double precision :: d6           ! distance from r(n+1),phi,z to rho6 point
 double precision :: d7           ! distance from r(n+1),phi,z to rho7 point
 double precision :: d8           ! distance from r(n+1),phi,z to rho8 point

 double precision :: rho_n        ! interpolated rho at r(n)
 double precision :: rho_nplus1   ! interpolated rho at r(n+1)

 double precision :: V            ! volume of rho centered cell
 double precision :: Vn           ! volume of n cell
 double precision :: Vnplus1      ! volume of n+1 cell

!######testing
integer :: i,j,k
!#######



!#####################################

!###### Begin main program ######
  nr = numr
  nz=numz
  nphi=numphi
	
  dr = 1.0/numr	
  dz=dr
  
  rn=floor(r/dr+1/2)
  zn=floor(z/dz+1/2)
  phin=floor((phi)*(nphi/(2*pi)))

! take care of our periodic boundary conditions

  phinplus=phin+1

  if (phin == 0) then
    phin = nphi
  endif

  if (phin == 256) then
    phinplus = 1
  endif

! get some density values sorted out

!print*,phin,phinplus,rn,zn
!print*,r,z,phi

if ((z .lt. 0d0) .or. (z .gt. nz*dz) .or. (r .lt. 0d0) .or. (r .gt. nr*dr) ) then
   rhoint=1d-11
else

   rho1=rho(rn,zn+1,phinplus)
   rho2=rho(rn,zn+1,phin)
   rho3=rho(rn,zn,phinplus)
   rho4=rho(rn,zn,phin)
   
   rho5=rho(rn+1,zn+1,phinplus)
   rho6=rho(rn+1,zn+1,phin)
   rho7=rho(rn+1,zn,phinplus)
   rho8=rho(rn+1,zn,phin)

end if


!!$!undo the periodic boundary correction
if (phin == nphi) then
   phin = 0
endif

! Find rho_n

d1=sqrt(r*r*(phi-phin)**2+(z-(zn+1))**2)
d2=sqrt(r*r*(phi-phin-1)**2+(z-(zn+1))**2)
d3=sqrt(r*r*(phi-phin)**2+(z-(zn))**2)
d4=sqrt(r*r*(phi-phin-1)**2+(z-(zn))**2)

rho_n = (d1*rho1+d2*rho2+d3*rho3+d4*rho4)/(d1+d2+d3+d4)

!print*,'rho_n=',rho_n
! Find rho_nplus1

d5=sqrt(r*r*(phi-phin)**2+(z-(zn+1))**2)
d6=sqrt(r*r*(phi-phin-1)**2+(z-(zn+1))**2)
d7=sqrt(r*r*(phi-phin)**2+(z-(zn))**2)
d8=sqrt(r*r*(phi-phin-1)**2+(z-(zn))**2)

rho_nplus1 = (d5*rho5+d6*rho6+d7*rho7+d8*rho8)/(d5+d6+d7+d8)
!print*,'rho_nplus1=',rho_nplus1
! Find rhoint

V= (r+dr/2)**2-(r-dr/2)**2

!print*,'V=',V
Vn= (rn+dr/2)**2-(r-dr/2)**2
!print*,'Vn=',Vn
Vnplus1 = (r+dr/2)**2-(rn+dr/2)**2
!print*,'Vnplus1=',Vnplus1
rhoint = (Vn*rho_n+Vnplus1*rho_nplus1)/V

if (rhoint.gt.1d-8) then
print*,'rhoint=',rhoint
endif


!Plot this variable (debugging):
!rhoint=rho(rn,zn,phin)

if (isnan(rhoint)) then
   rhoint=1d4
endif

! set densities to ZERO if outside of cylindrical grid

if (rhoint .gt. 10) then
   rhoint=3d0
endif
if (rhoint .lt. 0) then
   rhoint=-3d0
endif



end subroutine densityinterpolate
