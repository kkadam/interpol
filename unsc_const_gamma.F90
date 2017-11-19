       program unscramble_all
       implicit none
       include 'runhydro.h'
       real*8, dimension(numr,numz,numphi) :: input
       real*8, dimension(numr,numz,numphi) :: output,out_norm
       real*8, dimension(2*(numr-1),numz) :: out_buffer
       integer :: i, j, k, l, record_length
       integer :: q, startfrm, endfrm
       integer :: max_loc, max_loc1, counter, shift_by
       integer, dimension(3) :: location
       character(84) :: in_template
       character(84) :: out_template

       character(80) :: in_file
       character(80) :: out_file

       real*8 :: denmax

       integer :: filename,fn

       !!! Lisa: Change values in runhydro.h to match your values !!!
       !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

       !!! Lisa: change to the frame numbers that you want to unscramble !!!
DO fn = 1,15
       startfrm = 1000 !10!1144!1056
       endfrm = 2477
       filename = fn ! 1 frame
                     ! 2 frac1
                     ! 3 frac2
                     ! 4 tau
                     ! 5 pot
                     ! 6 velr
                     ! 7 velz
                     ! 8 velphi
                     ! 9 spec1
                     ! 10 spec2
                     ! 11 spec3
                     ! 12 spec4
                     ! 13 spec5
                     ! 14 geff
                     ! 15 pres

       !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
       input = 0.0
       output = 0.0
       out_buffer = 0.0

       inquire(iolength=record_length) input(2:numr_dd-1,2:numz_dd-1,:)

!       print *,"start,end: ", startfrm, endfrm

       do q = startfrm, endfrm,5
!          if(q.lt.1101) cycle
          write(*,*) "q=",q

          !!! Lisa: change to the directory where the hydrocode is outputing the density files  !!!
          IF (filename.EQ.1) THEN
           in_template = 'frame.'
           out_template = "../unscramble/den_"
          ELSEIF (filename.EQ.2) THEN
           in_template = './frac1.'
           out_template = '../unscramble/frac1_'
          ELSEIF (filename.EQ.3) THEN
           in_template = './frac2.'
           out_template = '../unscramble/frac2_'
          ELSEIF (filename.EQ.4) THEN
           in_template = './tau.'
           out_template = '../unscramble/tau_'
          ELSEIF (filename.EQ.5) THEN
           in_template = './pot.'
           out_template = '../unscramble/pot_'
          ELSEIF (filename.EQ.6) THEN
           in_template = './velr.'
           out_template = '../unscramble/velr_'
          ELSEIF (filename.EQ.7) THEN
           in_template = './velz.'
           out_template = '../unscramble/velz_'
          ELSEIF (filename.EQ.8) THEN
           in_template = './velphi.'
           out_template = '../unscramble/velphi_'
          ELSEIF (filename.EQ.9) THEN
           in_template = './pres.'
           out_template = '../unscramble/pres_'


          ELSEIF (filename.EQ.10) THEN
           in_template = './spec1.'
           out_template = '../unscramble/spec1_'
          ELSEIF (filename.EQ.11) THEN
           in_template = './spec2.'
           out_template = '../unscramble/spec2_'
          ELSEIF (filename.EQ.12) THEN
           in_template = './spec3.'
           out_template = '../unscramble/spec3_'
          ELSEIF (filename.EQ.13) THEN
           in_template = './spec4.'
           out_template = '../unscramble/spec4_'
          ELSEIF (filename.EQ.14) THEN
           in_template = './spec5.'
           out_template = '../unscramble/spec5_'

          ELSE
!           STOP
          ENDIF
          !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
          write(in_file,'(a,i4)') trim(in_template), startfrm

          call read_file(input,in_file,record_length,q,startfrm)

          ! do the coercion to single precision
          do L = 1, numphi
             do K = 1, numz
                do J = 1, numr
                   output(J,K,L) = input(J,K,L)
                enddo
             enddo
          enddo

          ! find location of the density maximum
          location = maxloc(output)
          max_loc = location(3)
          if( max_loc <= numphi/2 ) then
             max_loc1 = max_loc + numphi/2
          else
             max_loc1 = max_loc - numphi/2
          endif

          ! assuming that we are working on isym=1 files
          do l = 1, numphi/2
             output(1,:,l) = output(2,:,l+numphi/2)
             output(1,:,l+numphi/2) = output(2,:,l)
          enddo
          output(numr-1:numr,:,:) = 0.0
          output(:,1:2,:) = 0.0
          output(:,numz-1:numz,:) = 0.0

          do k = 1, numz
             if( (max_loc1 > numphi/4) .and. &
                (max_loc1 <= 3*numphi/4)  ) then
                counter = 1
                do j = numr, 2, -1
                   out_buffer(counter,k) = output(j,k,max_loc1)
                   counter = counter + 1 
                enddo
                do j = 2, numr
                   out_buffer(j-2+numr,k) = output(j,k,max_loc)
                enddo
             else
                counter = 1
                do j = numr, 2, -1
                   out_buffer(counter,k) = output(j,k,max_loc)
                   counter = counter + 1
                enddo
                do j = 2, numr
                   out_buffer(j-2+numr,k) = output(j,k,max_loc1)
                enddo
             endif
          enddo
   
          denmax = maxval(output)
          WRITE(*,*) denmax
          denmax = minval(output)
!          WRITE(*,*) denmax
!          WRITE(*,*) in_template 
!	  out_norm = output /denmax
          !!! Lisa: Change to the directory where you have the unscramble folder !!!
          !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!print *,"ugh: ", out_template, trim(out_template), q
          write(out_file,'(a,i4)') trim(out_template), q
!          WRITE(*,*) out_file
         
          open(unit=11,file=trim(out_file), convert='BIG_ENDIAN', &
              form='unformatted',status='unknown')
          write(11) output
          close(11)

       enddo

enddo

       stop
       end program unscramble_all


       subroutine read_file(input,in_file,rec_len,fnum,snum)
       implicit none
       include 'runhydro.h'
       real*8, dimension(numr,numz,numphi) :: input
       integer :: n, i, j, jlwb, jupb, klwb, kupb,rec_len,fnum
       integer :: rnum,snum

       character(84) :: in_template
       character     :: dot
       character(80) :: in_file,in_file2
       n = 1
       dot = '_'
       jlwb = 2
       jupb = numr_dd - 1
       klwb = 2
       kupb = numz_dd - 1
       write(in_file,'(a,a1)') trim(in_file), dot
       do i = 1, numz_procs
          do j = 1, numr_procs
             if (n-1 .lt. 10) then
               write(in_file2,'(a,i1)') trim(in_file),n-1
             elseif ( (n-1.ge. 10) .and. (n-1 .le. 99) ) then
               write(in_file2,'(a,i2)') trim(in_file),n-1
             elseif ( (n-1.ge. 100) .and. (n-1 .le. 999) ) then
               write(in_file2,'(a,i3)') trim(in_file),n-1
             else
               write(in_file2,'(a,i4)') trim(in_file),n-1
             endif

             open(unit=10,form='unformatted',status='old', &
                file=trim(in_file2), access='direct', recl=rec_len)


             rnum = fnum+1-snum
             read(10,rec=rnum) input(jlwb:jupb,klwb:kupb,:)
             !read(10,rec=fnum) input(jlwb:jupb,klwb:kupb,:)
       
             close(10)
             jlwb = jupb + 1
             jupb = jlwb + numr_dd - 3
             n = n + 1
          enddo
          jlwb = 2
          jupb = numr_dd - 1
          klwb = kupb + 1
          kupb = klwb + numz_dd - 3
       enddo

       return
       end subroutine read_file
