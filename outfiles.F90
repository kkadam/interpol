subroutine outfiles(density)
  implicit none
  include 'convertpar.h'
  
  double precision :: density(numr,numz,numphi)
  double precision :: ang_mom(numr,numz,numphi)
  double precision :: rad_mom(numr,numz,numphi)
  integer :: i,j,k,temp, count  
  integer :: n, jlwb, jupb, klwb, kupb, record_length     
  double precision ::r,dr

!########################### Start Subroutine ######################### 

  dr=1.0/(numr-3)

!#### Find angular momentum density ####
	
  do i=1,numr
    do j=1,numz
      do k=1,numphi  
          r=(i-0.5)*dr      
          ang_mom(i,j,k)= density(i,j,k)*r**2*omega
      enddo
    enddo
  enddo    
     
!Test angular momentum
	
!  open(unit=10,status='replace',file='test_amd')
!    do j=1,numz
!       do i=1,numr
!          write(10,*) i,j,ang_mom(i,j,101)
!       enddo
!       write(10,*)
!    enddo
!  close(10)  
  
!  print*, 'File test_amd printed' 
  
!#### Find radial momentum density ####
	
  do i=1,numr
    do j=1,numz
      do k=1,numphi  	
        rad_mom(i,j,k)=0.0
      enddo
    enddo
  enddo  


!#### Write output files ####    
  inquire(iolength=record_length) density(1:numr_dd,1:numz_dd,:)

     open(unit=10,file='density',form='unformatted',status='new',&
     access='direct', recl=record_length)
!       write(*,*) 'record_length ',record_length
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
   print*,"Files density, ang_mom, rad_mom printed"  
  
  
end subroutine outfiles
