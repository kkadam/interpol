       program initial_conditions_isym1
       implicit none
       include 'runhydro.h'
       double precision, dimension(numr,numz,numphi) :: rho, a, s, rhjkl 
       double precision, dimension(numr) :: rhf, r, rinv
       double precision, dimension(numphi) :: cos_cc, sin_cc
       double precision, dimension(numphi) :: cos_vc, sin_vc
       double precision :: dr, dz, dphi, pi, index, temp
       double precision :: tmass, xcom, ycom, densmin, omega
       double precision, allocatable:: rho_temp(:,:,:)
       integer :: isym, jmax2, kmax2, counter
       integer :: i, j, k, l, record_length 
       integer :: n, jlwb, jupb, klwb, kupb, scfr, scfz, zmin, rmin
       integer :: numr_deltar
       integer, dimension(3) :: pos
!       common /dummy/ rho, a, s, rhjkl, rho_temp
!###############################################################################
	
       scfr = 100
       scfz = 100
       omega = 0.1662
       
       allocate(rho_temp(scfr,scfz,numphi))
       print*,scfr,scfz,numphi
       
       
       isym = 2
       jmax2 = scfr
       kmax2 = scfz-1
       numr_deltar = scfr 
       
       ! setup the coordiante grid
       pi = acos(-1.0)
       
       dr = 1.0 / (numr_deltar-3)
       dz = dr
       dphi = 2.0 * pi / numphi
       
       index = 1.0
       do j = 1, numr
          r(j) = (index - 2.0) * dr
          index = index + 1.0
       enddo
       
       index = 0.5 * dr
       do j = 1, numr
          rhf(j) = r(j) + index
       enddo
       
       where( r /= 0.0 ) 
          rinv = 1.0 / r
       else where
          rinv = 0.0
       end where
       
       index = 1.0
       do l = 1, numphi
          temp = (index - 1.0) * dphi
          cos_cc(l) = cos(temp)
          sin_cc(l) = sin(temp)
          temp = (index - 1.5) * dphi
          cos_vc(l) = cos(temp)
          sin_vc(l) = sin(temp)
          index = index + 1.0
       enddo
       
       write(*,*) 'radial grid: ', rhf(1), rhf(2), rhf(numr-1),          &
                  rhf(numr)

       rho = 0.0
       
       print*,"preread"
       open(unit=8,file='density.bin',                                   &
           form='unformatted',convert='BIG_ENDIAN',status='unknown')
       read(8) rho_temp
       close(8)
       print*,"postread"

  open(unit=12,file="star1")
         do j=1,scfz
           do i=1,scfr
             write(12,*) i,j,rho_temp(i,j,1)
           enddo
           write(12,*)
         enddo
  close(12)         
  print*,"File star1"     

    open(unit=12,file="star2")
         do j=1,scfz
           do i=1,scfr
             write(12,*) i,j,rho_temp(i,j,numphi/2)
           enddo
           write(12,*)
         enddo
  close(12)         
  print*,"File star2"   
  
       write(*,*) 'Max value of orig: ',maxval(rho_temp)
       pos = maxloc(rho_temp)
       write(*,*) '@: ',pos(1), pos(2), pos(3)
       write(*,*) '@: ',rhf(pos(1)), float(pos(3)-1)*dphi

    rmin=min(scfr,numr)
    zmin=min(scfz,numz/2)
	
    print*, "rmin",rmin,"zmin",zmin
    
    rho= 1d-10
    
    do i=1,rmin
      do j=1,zmin
        do k=1,numphi        
  	   rho(i,numz/2+j,k)=rho_temp(i+1,j+1,k)
        enddo
      enddo
    enddo	    
    do i=1,rmin
      do j=1,zmin
        do k=1,numphi        
  	   rho(i,numz/2-j+1,k)=rho(i,numz/2+j,k)
        enddo
      enddo
    enddo   
      
    do i=1,rmin
      do j=1,zmin
        do k=1,numphi
           if (rho(i,j,k).lt.1d-10) then
 	      rho(i,j,k)=1d-10
  	   endif
        enddo
      enddo
    enddo         

       
       write(*,*) 'max value of rho: ',maxval(rho)
       pos = maxloc(rho)
       write(*,*) '@: ',pos(1), pos(2), pos(3)

       densmin = 1.0e-10
       write(*,*) 'densmin: ',densmin

       do k = 1, numphi
          do j = 1, numz
             do i = 1, numr
                if ( rho(i,j,k) < densmin ) then
                   rho(i,j,k) = densmin
                endif
             enddo
          enddo
       enddo 

       ! calculate the total mass so we can measure the 
       ! center of mass
       tmass = 0.0
       do l = 1, numphi
          do k = 1, numz
             do j = 2, numr
                tmass = tmass + rhf(j)*rho(j,k,l)
             enddo
          enddo
       enddo
       xcom = 0.0
       ycom = 0.0
       do l = 1, numphi
          do k = 2, numz
             do j = 2, numr
                xcom = xcom + rhf(j)*rhf(j)*cos_cc(l)*rho(j,k,l)
                ycom = ycom + rhf(j)*rhf(j)*sin_cc(l)*rho(j,k,l)
             enddo
          enddo
       enddo 
       xcom = xcom / tmass
       ycom = ycom / tmass
       write(*,*) 'tmass, xcom, ycom ',tmass, xcom, ycom
       write(*,*) 'densmin ',densmin

       ! need the density defined at vertex centered cell centers
       do l = 2, numphi
          do k = 2, numz
             do j = 2, numr
                rhjkl(j,k,l) = 0.5 * (rho(J,K,L) + rho(J,K,L-1))
             enddo
          enddo
       enddo
       do k = 2, numz
          do j = 2, numr
             rhjkl(j,k,1) = 0.5 * (rho(J,K,1) + rho(J,K,numphi))
          enddo
       enddo

       ! form a, the angular momentum density
       do l = 1, numphi
          do k = 1, numz
             do j = 2, numr
                a(j,k,l) = - omega*rhjkl(j,k,l)*rhf(j)*                 &
                             (ycom*sin_vc(l) + xcom*cos_vc(l))

             enddo
          enddo
       enddo

       do l = 1, numphi
          do k = 1, numz
             do j = 2, numr
                rhjkl(j,k,l) = 0.5 * rinv(j) *                          &
                             ( rho(j,k,l)*(r(j) + 0.25*dr) +            &
                               rho(j-1,k,l)*(r(j) - 0.25*dr) )
             enddo
          enddo
       enddo
       ! form the radial momentum density
       do l = 1, numphi
          do k = 1, numz
             do j = 2, numr
                s(j,k,l) = rhjkl(j,k,l)*omega*                          &
                          (ycom*cos_cc(l) - xcom*sin_cc(l))
             enddo
          enddo
       enddo
!
       s(:,1,:) = s(:,2,:)
       a(:,1,:) = a(:,2,:)
       s(1,:,:) = - cshift(s(3,:,:),dim=2,shift=numphi/2)
       s(2,:,:) = 0.0
       a(1,:,:) = cshift(a(2,:,:),dim=2,shift=numphi/2)

       ! write out all these arrays
      open(unit=18,file='rho.bin',                                   &
           form='unformatted',convert='BIG_ENDIAN',status='unknown')
       write(18) rho
       close(18)

  open(unit=12,file="star1o")
         do j=1,numz
           do i=1,numr
             write(12,*) i,j,rho(i,j,1)
           enddo
           write(12,*)
         enddo
  close(12)          
  print*,"File star1o"   
  
  open(unit=12,file="star2o")
         do j=1,numz
           do i=1,numr
             write(12,*) i,j,rho(i,j,numphi/2)
           enddo
           write(12,*)
         enddo
  close(12)          
  print*,"File star2o"     
       
       
       
       inquire(iolength=record_length) rho(1:numr_dd,1:numz_dd,:)
 
       open(unit=10,file='density',        &
           form='unformatted',status='new',access='direct',             &
           recl=record_length)

       write(*,*) 'record_length ',record_length
       n = 1
       jlwb = 1
       jupb = numr_dd
       klwb = 1
       kupb = numz_dd
       do i = 1, numz_procs
          do j = 1, numr_procs
             write(10,rec=n) rho(jlwb:jupb,klwb:kupb,:)
             jlwb = jupb - 1
             jupb = jlwb + numr_dd - 1
             n = n + 1
          enddo
          jlwb = 1
          jupb = numr_dd
          klwb = kupb - 1
          kupb = klwb + numz_dd - 1
       enddo

       open(unit=11,file='ang_mom',             &
           form='unformatted',status='unknown',access='direct',        &
           recl=record_length)
 
       n = 1
       jlwb = 1
       jupb = numr_dd
       klwb = 1
       kupb = numz_dd
       do i = 1, numz_procs
          do j = 1, numr_procs
             write(11,rec=n) a(jlwb:jupb,klwb:kupb,:)
             jlwb = jupb - 1
             jupb = jlwb + numr_dd - 1
             n = n + 1
          enddo
          jlwb = 1
          jupb = numr_dd
          klwb = kupb - 1
          kupb = klwb + numz_dd - 1
       enddo

       open(unit=12,file='rad_mom',         &    
       form='unformatted',status='unknown',access='direct',        & 
           recl=record_length)

       n = 1
       jlwb = 1
       jupb = numr_dd
       klwb = 1
       kupb = numz_dd
       do i = 1, numz_procs
          do j = 1, numr_procs
             write(12,rec=n) s(jlwb:jupb,klwb:kupb,:)
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

      !DEBUG
       write(*,*) maxval(rho), minval(rho)
       write(*,*) maxval(a), minval(a)
       write(*,*) maxval(s), minval(s)

       write(*,*) maxloc(rho)
       write(*,*) minloc(rho)
       write(*,*) maxloc(a)
       write(*,*) minloc(a)
       write(*,*) maxloc(s)
       write(*,*) minloc(s)

       end program initial_conditions_isym1
