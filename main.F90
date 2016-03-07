program main
  implicit none
  include "convertpar.h"

  double precision :: rho_pad(padr,scfz,numphi)
  double precision :: rho_temp(scfr,scfz,numphi)

  double precision :: pres_pad(padr,scfz,numphi)
  double precision :: pres_temp(scfr,scfz,numphi)

  double precision :: rho_combine(padr,scfz,numphi)
  double precision, dimension(numr,numz,numphi) :: density

  integer :: i,j,k,l, maxit, q
  double precision :: dr, com1, com_i, com_temp
         

!########################### Start Program #########################  

  print*, '============================================================='
  print*, "Conversion started"
  print*, '============================================================='
  
  dr=1.0/(numr_deltar-deltar_parameter)
  
!#### Read density file and print 2d slices ####

  open(unit=8,file='density.bin',                                   &
  form='unformatted',convert='BIG_ENDIAN',status='unknown')
    read(8) rho_temp
  close(8)

  call print2d("star1",rho_temp,scfr,scfz,numphi,1)
  call print2d("star2",rho_temp,scfr,scfz,numphi,numphi/2+1)


!#### Processing and interpolation for binary systems ####

  if (binary_system) then       

!#### Read pressure file and print 2d slices ####
    open(unit=8,file='pressure.bin',                                   &
    form='unformatted',convert='BIG_ENDIAN',status='unknown')
      read(8) pres_temp
    close(8)
       
!    call print2d("pres1i",pres_temp,scfr,scfz,numphi,1)
!    call print2d("pres2i",pres_temp,scfr,scfz,numphi,numphi/2+1)


!#### Add padding to avoid clipping while interpolating ####
    pres_pad=0.0
    do i=1,scfr
      do j=1,scfz 
        do k=1,numphi
           pres_pad(i,j,k)=pres_temp(i,j,k)
        enddo
      enddo
    enddo

    rho_pad=0.0
    do i=1,scfr
      do j=1,scfz
        do k=1,numphi
           rho_pad(i,j,k)=rho_temp(i,j,k)
        enddo
      enddo
    enddo


!  call print2d("rho1p",rho_pad,padr,scfz,numphi,1)
!  call print2d("rho2p",rho_pad,padr,scfz,numphi,numphi/2+1)

!  call print2d("pres1p",pres_pad,padr,scfz,numphi,1)
!  call print2d("pres2p",pres_pad,padr,scfz,numphi,numphi/2+1)


!#### Find center of mass of the initial system ####  
    call com_initial(rho_temp, com_i)  
    print*, "Initial CoM = ",com_i


!#### Shift the grid to com iteratively ####
    print*, '============================================================='
    print*, "Shifting the CoM iteratively..."

    com_temp = com_i
    maxit = 1               ! Ghost structures appear after iterations?

    do q = 1, maxit
       call cubic_translation(pres_pad, com_temp)   !!!
       call compute_density(rho_pad,pres_pad,com_i)  !!!     
       call com_final(rho_pad, com_temp)

       print*,"com_temp", com_temp
       
       if ( com_temp .lt. 1e-5 ) then
           exit
       endif
 
    enddo

    print*,"Cubic interpolation performed"


!#### Find center of mass of the new system ####

!     call compute_density(rho_pad,pres_pad,com_i)
     call com_final(rho_pad, com1)

     print*, "Final CoM= ",com1   
   else
     print*, "Cubic interpolation NOT performed for the single star"


!#### Add padding because initial_conditions takes padded density ####

    rho_pad=0.0
    do i=1,scfr
      do j=1,scfz
        do k=1,numphi
           rho_pad(i,j,k)=rho_temp(i,j,k)
        enddo
      enddo
    enddo

   endif

     
!#### Find center of mass of the new system ####  

   print*, "Normalized dr = ", dr!*numr/scfr

   
!#### Call initial condition function ####   

  call initial_conditions(rho_pad,density)
  
  call print2d("star1o",density,numr,numz,numphi,1)
  call print2d("star2o",density,numr,numz,numphi,numphi/2+1)


!#### Print fort.7 file ####   
  if (bipoly) then
     if (const_gamma) then
        call fort_const_gamma(com_i)
     else
        call fort(com_i)
     endif
  else
     call fort_old
  endif   
      
  print*, '============================================================='

end program main
