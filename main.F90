program main
  implicit none
  include "convertpar.h"
  double precision :: density(numr,numz,numphi)
  double precision :: ang_mom(numr,numz,numphi)
  double precision :: rad_mom(numr,numz,numphi)
  
  double precision :: rhoscf(scfr,scfz,numphi)

  integer :: temp_int1, temp_int2, temp_int3, temp_int4, qint
  double precision :: temp_dbl1, temp_dbl2, temp_dbl3, temp_dbl4
  integer :: i,j,k,temp, count
  double precision ::r,dr, vol, dphi, Re
  
  integer :: n, jlwb, jupb, klwb, kupb, record_length              

!########################### Start Program #########################  
 
  dr=1.0/(numr-1)	    
  dphi=2.0*pi/numphi
  
!#### Read from input file ####
	
  open(unit = 10, file='density.bin',form='unformatted', convert= "BIG_ENDIAN")  
    read(10) rhoscf
  close(10)  

!#### Trim ghost zones ####
 
    do i=1,scfr-1
      do j=1,scfz-1
        do k=1,numphi 
          rhoscf(i,j,k)=rhoscf(i+1,j+1,k) 
        enddo
      enddo
    enddo

!Test input  
!  open(unit=10,file='test_input')
!    do j=1,scfz
!       do i=1,scfr
!          write(10,*) i,j,rhoscf(i,j,1)
!       enddo
!       write(10,*)
!    enddo
!  close(10)
 
!  print*, 'File test_input printed'

  
!#### Get 3D axisymmetric density ####
	
  density = 1d-10
	
  do i=1,scfr-1
    do j=1,scfz-1
      do k=1,numphi        
!          density(i,j,k)=rhoscf(i+1,scfz-j,k)             
!          density(i,j+numz/2,k)=rhoscf(i+1,j+1,k)

	  density(i,j,k)=rhoscf(i,scfz-j,k)
  	  density(i,j+numz/2,k)=rhoscf(i,j,k)
      enddo
    enddo
  enddo

  do i=1, numr
    do j=1, numz
      do k=1, numphi
        if (density(i,j,k) .lt. 1d-9) then
          density(i,j,k)=  1d-10
        endif
      enddo
    enddo
  enddo    
  
!Test 3D density
!  open(unit=10,status='replace',file='test_3d')
!    do j=1,numz
!       do i=1,numr
!          write(10,*) i,j,density(i,j,1)
!       enddo
!       write(10,*)
!    enddo
!  close(10)

!  print*, 'File test_3d printed'  
	
!  open(unit=10,file='test_1di1')  
!    do i=1,scfr
!      write(10,*) rhoscf (i,1,1)
!    enddo  
!  close(10)
!  print*, 'File test_1di1 printed'
  
!  open(unit=10,file='test_1do1')  
!    do i=1,scfr
!      write(10,*) density (i,numz/2+1,1)
!    enddo  
!  close(10)
!  print*, 'File test_1do1 printed', scfz-1
    

!#### Shift the grid to CoM and interpolate ####
	
  call shift(density)  
	

   
 
!#### Write binary output file ####
  
  open(unit=15,file='density_shift.bin',form='unformatted',status='unknown')
  write(15) density
  close(15)   
  
 stop 
  
  print*, 'File density_shift.bin printed'  


!Find angular momentum density
  do i=1,numr
    do j=1,numz
      do k=1,numphi  
          r=(i-0.5)*dr      
          ang_mom(i,j,k)= density(i,j,k)*r**2*omega*Re**2
      enddo
    enddo
  enddo    
     
!Test angular momentum
  open(unit=10,status='replace',file='test_amd')
    do j=1,numz
       do i=1,numr
          write(10,*) i,j,ang_mom(i,j,101)
       enddo
       write(10,*)
    enddo
  close(10)  
  
  print*, 'File test_amd printed' 
  
!Find radial momentum
  do i=1,numr
    do j=1,numz
      do k=1,numphi  	
        rad_mom(i,j,k)=0.0
      enddo
    enddo
  enddo  
    
  inquire(iolength=record_length) density(1:numr_dd,1:numz_dd,:)

     open(unit=10,file='density',form='unformatted',status='new',&
     access='direct', recl=record_length)

       write(*,*) 'record_length ',record_length
       n = 1
       jlwb = 1
       jupb = numr_dd
       klwb = 1
       kupb = numz_dd
       do i = 1, numz_procs
          do j = 1, numr_procs
             write(10,rec=n) density(jlwb:jupb,klwb:kupb,:)
             jlwb = jupb - 1
             jupb = jlwb + numr_dd - 1
             n = n + 1
          enddo
          jlwb = 1
          jupb = numr_dd
          klwb = kupb - 1
          kupb = klwb + numz_dd - 1
       enddo

       open(unit=11,file='ang_mom',form='unformatted',status='unknown',&
       access='direct',recl=record_length)
 
       n = 1
       jlwb = 1
       jupb = numr_dd
       klwb = 1
       kupb = numz_dd
       do i = 1, numz_procs
          do j = 1, numr_procs
             write(11,rec=n) ang_mom(jlwb:jupb,klwb:kupb,:)
             jlwb = jupb - 1
             jupb = jlwb + numr_dd - 1
             n = n + 1
          enddo
          jlwb = 1
          jupb = numr_dd
          klwb = kupb - 1
          kupb = klwb + numz_dd - 1
       enddo

       open(unit=12,file='rad_mom',form='unformatted',status='unknown',&
       access='direct', recl=record_length)

       n = 1
       jlwb = 1
       jupb = numr_dd
       klwb = 1
       kupb = numz_dd
       do i = 1, numz_procs
          do j = 1, numr_procs
             write(12,rec=n) rad_mom(jlwb:jupb,klwb:kupb,:)
             jlwb = jupb - 1
             jupb = jlwb + numr_dd - 1
             n = n + 1
          enddo
          jlwb = 1
          jupb = numr_dd
          klwb = kupb - 1
          kupb = klwb + numz_dd - 1
       enddo
      
       close(10)
       close(11)
       close(12) 
   print*,"Output files density, ang_mom, rad_mom printed"
   
   
!Write fort.7 file!!
	
	
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
	
  
end program main
