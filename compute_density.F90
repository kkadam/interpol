subroutine compute_density(rho_pad,pres_pad,com)
  implicit none
  include "convertpar.h"

!#### Subroutine parameters ####
  double precision, intent(out) :: rho_pad(padr,scfz,numphi)      ! Density with corrected CoM
  double precision, intent(in) :: pres_pad(padr,scfz,numphi)
  double precision, intent(in) :: com

!#### Local variables ####
  double precision :: phi(numphi), rhf(padr), xhf(padr,numphi) 
  double precision :: gammae1, gammae2, gammac1, gammac2
  double precision :: x, dr, dphi
  integer :: i, l, j, k
  
! L1 is separation point which separates the two stars
! and specify pressure by hand


! Calculate radius array
!  dr = 1.0 / (scfr - 3.0)
       dr = 1.0 / (numr_deltar-deltar_parameter)

  x = 0.0
  do j = 1, padr
    rhf(j) = x * dr - dr/2
    x = x + 1.0
  enddo

! Calculate phi array
  dphi = 2.0 * pi / numphi
  x = 0.0
  do L = 1, numphi
    phi(L) = x * dphi
    x = x + 1.0
  enddo

! Calculate X array
  do l = 1, numphi
    do j = 2, padr
       xhf(j,l) = rhf(j) * cos(phi(l))
    enddo
  enddo

! Calculate gammas
  gammac1 = 1.0+1/nc1
  gammae1 = 1.0+1/ne1
  gammac2 = 1.0+1/nc2
  gammae2 = 1.0+1/ne1

!  do i=1, padr
!    print*, xhf(i,1), i
!  enddo

  rho_pad = 0.0

! Calculate density array
       do l = 1, numphi
          do k = 1, scfz
             do j = 2, padr
                if ( xhf(j,l) .gt. (com*(-1.0)) ) then
!rho_test(j,k,l)= 0.1
                   if ( pres_pad(j,k,l) .gt. pres_d ) then
                      rho_pad(j,k,l) = ( pres_pad(j,k,l)/kappac1 )**(1.0/gammac1)
                   else
                      rho_pad(j,k,l) = ( pres_pad(j,k,l)/kappae1 )**(1.0/gammae1)
                   endif

                else
!rho_test(j,k,l)= 0.2
                   if ( pres_pad(j,k,l) .gt. pres_e ) then
                      rho_pad(j,k,l) = ( pres_pad(j,k,l)/kappac2 )**(1.0/gammac2)
                   else
                      rho_pad(j,k,l) = ( pres_pad(j,k,l)/kappae2 )**(1.0/gammae2)
                   endif

                endif
             enddo
          enddo
       enddo


! Set density floor
       do l = 1, numphi
          do k = 1, scfz
             do j = 2, padr
                if ( rho_pad(j,k,l) .lt. 1d-10 ) then
                   rho_pad(j,k,l) = 1d-10
                endif
             enddo
          enddo
       enddo


!call print2d("rho1t",rho_test,padr,scfz,numphi,1)
!call print2d("rho2t",rho_test,padr,scfz,numphi,numphi/2+1)


end subroutine compute_density
