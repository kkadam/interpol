program main
  implicit none
  include "convertpar.h"
  double precision :: density(numr,numz,numphi)
  double precision :: rho_temp(scfr,scfz,numphi)
  double precision :: rho_pad(padr,scfz,numphi)

  integer :: i,j,k
  double precision :: dr, com, com_new
         

!########################### Start Program #########################  

  print*, '============================================================='
  print*, "Conversion started"
  print*, '============================================================='
  
  dr=1.0/(numr_deltar-deltar_parameter)
  
!#### Read from input file ####

       open(unit=8,file='density.bin',                                   &
           form='unformatted',convert='BIG_ENDIAN',status='unknown')
       read(8) rho_temp
       close(8)
       
       
!#### Print input files ####     

  open(unit=12,file="star1")
         do j=1,scfz
           do i=1,scfr
             write(12,*) i,j,rho_temp(i,j,1)
           enddo
           write(12,*)
         enddo
  close(12)         
  print*,"File star1 printed"     

    open(unit=12,file="star2")
         do j=1,scfz
           do i=1,scfr
             write(12,*) i,j,rho_temp(i,j,numphi/2+1)
           enddo
           write(12,*)
         enddo
  close(12)         
  print*,"File star2 printed"
  

!#### Add padding to avoid clipping while interpolating ####
   rho_pad=0.0
   do i=1,scfr
     do j=1,scfz 
       do k=1,numphi
           rho_pad(i,j,k)=rho_temp(i,j,k)
       enddo
     enddo
   enddo

!#### Print padded files ####     
        
  open(unit=12,file="star1p")
         do j=1,scfz
           do i=1,padr
             write(12,*) i,j,rho_pad(i,j,1)
           enddo
           write(12,*)
         enddo
  close(12)
  print*,"File star1p printed"

    open(unit=12,file="star2p")
         do j=1,scfz
           do i=1,padr
             write(12,*) i,j,rho_pad(i,j,numphi/2+1)
           enddo
           write(12,*)
         enddo
  close(12)
  print*,"File star2p printed"



 
!#### Find center of mass of the given system ####  

   call com_initial(rho_temp, com)  
   print*, "Initial CoM = ",com

   
!#### Shift the grid to com and interpolate ####
  
   if (binary_system) then
     call cubic_translation(rho_pad, com)  
     print*,"cubic interpolation performed"
     call com_final(rho_pad, com)  
     print*, "Final CoM = ",com
   else
     print*, "Cubic interpolation NOT performed for the single star"
   endif
     
!#### Find center of mass of the new system ####  

   print*, "Normalized dr = ", dr!*numr/scfr
   
!#### Call initial condition function ####   
  
  call initial_conditions(rho_pad,density)
  

!#### Print fort.7 file ####   
  if (bipoly) then
     call fort
  else
     call fort_old
  endif   
    
  
  print*, '============================================================='

end program main
