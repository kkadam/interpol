program main
  implicit none
  include "convertpar.h"
  double precision :: density(numr,numz,numphi)
  double precision :: rhoscf(scfr,scfz,numphi)

  integer :: i,j,k
  double precision :: dr, com, com_new
         

!########################### Start Program #########################  
 
  dr=1.0/(numr-3)
  
!#### Read from input file ####
	
  open(unit = 10, file='density.bin',form='unformatted', convert= "BIG_ENDIAN", &
        status='unknown')   
    read(10) rhoscf
  close(10)  

  
!#### Find center of mass of the given system ####  
   call com_initial(rhoscf, com)
 
   print*, "com =",com
   

  
!#### Get 3D axisymmetric density ####
	
  density = 1d-10
 
  if (scfz.lt.numz/2) then
	
    do i=1,scfr
      do j=1,scfz
        do k=1,numphi        
  	   density(i,numz/2+j,k)=rhoscf(i+1,j,k)
        enddo
      enddo
    enddo	    
    do i=1,scfr
      do j=1,scfz
        do k=1,numphi        
  	   density(i,numz/2-j+1,k)=density(i,numz/2+j,k)
        enddo
      enddo
    enddo
    
  else
  	  
    do i=1,numr
      do j=1,numz/2
        do k=1,numphi        
  	   density(i,numz/2+j,k)=rhoscf(i+1,j,k)
        enddo
      enddo
    enddo	
    do i=1,numr
      do j=1,numz/2
        do k=1,numphi        
  	   density(i,numz/2-j+1,k)=density(i,numz/2+j,k)
        enddo
      enddo
    enddo
    
  endif
  	  
  
  do i=1, numr
    do j=1, numz
      do k=1, numphi
        if (density(i,j,k) .lt. 1d-9) then
          density(i,j,k)=  1d-10
        endif
      enddo
    enddo
  enddo    
  

!#### Shift the grid to com and interpolate ####
  
  call shift(density, com)  
  
!#### Find center of mass of the final system ####    
  
  call com_final(density, com_new)  

!#### Print if the shift is successful ####   

  if (com_new.lt.dr) then
    print*, "New com is less than dr"
  else
    print*, "CoM shift FAILED!"
    print*,"com_new =",com_new
    print*, "dr =", dr  
  endif     
 
!#### Write binary output file ####
  
  open(unit=15,file='density_shift.bin',form='unformatted',convert= &
       'BIG_ENDIAN',status='unknown')
  write(15) density
  close(15)   
   
  print*, 'File density_shift.bin printed'  

!#### Write output files for flower code ####  
  
  call outfiles(density)
   	
  call fort	

	
end program main
