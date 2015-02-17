       subroutine cubic_translation(rho,com)
       implicit none
       include 'convertpar.h'

       double precision x(scfr,numphi), y(scfr,numphi)
       double precision cosine(numphi), sine(numphi)
       double precision phi(numphi), rhf(scfr)
       double precision rhonew(scfr,scfz,numphi), rho(scfr,scfz,numphi)
       double precision rnew(scfr,numphi), phinew(scfr,numphi)
       double precision dr, dphi, xdisp, u, t
       double precision xavg1, xavg2, com, seperation
       double precision mass1, mass2, yavg1, yavg2, factor 
       double precision f(4), dfdr(4), dfdp(4),d2f(4)
       double precision c(4,4), sum
       integer i, j, k, l, m, q, w, phic, z
       integer phi1, phi2, phi3, phi4
       integer index(scfr,numphi,2)
       integer mm, mp, mpp, lm, lp, lpp
       
       
       phi1 = int(numphi / 4.0) - 1
       phi2 = int(numphi / 4.0) + 1
       phi3 = int(3.0 * numphi / 4.0) - 1
       phi4 = int(3.0 * numphi / 4.0) + 1

       phic = numphi/2 + 1
       dr=1.0/(numr_deltar-deltar_parameter)
       dphi = 2.0*pi/numphi
       factor = 2.0*dr*dr*dphi
       rhf(1) = - dr/2.0
       phi(1) = 0.0
       do i = 2,scfr
          rhf(i) = rhf(i-1) + dr
       enddo
       do i = 2,numphi
          phi(i) = phi(i-1) + dphi
       enddo
       do i = 1,numphi
          cosine(i) = cos(phi(i))
          sine(i) = sin(phi(i))
       enddo
       do i = 1,numphi
          do j = 2,scfr
             x(j,i) = rhf(j)*cosine(i)
             y(j,i) = rhf(j)*sine(i)
          enddo
       enddo
       
!  Begin actual translation section
       do i = 1,numphi
          do k = 2,scfr
             xdisp = x(k,i) + com
             rnew(k,i) = sqrt(xdisp*xdisp+y(k,i)*y(k,i))
             if((xdisp.gt.0.0).and.(y(k,i).gt.0.0)) then
                phinew(k,i) = atan(y(k,i)/xdisp)
             elseif((xdisp.lt.0.0).and.(y(k,i).gt.0.0)) then
                phinew(k,i) = atan(y(k,i)/xdisp) + pi
             elseif((xdisp.lt.0.0).and.(y(k,i).lt.0.0)) then
                phinew(k,i) = atan(y(k,i)/xdisp) + pi
             elseif((xdisp.gt.0.0).and.(y(k,i).lt.0.0)) then
                phinew(k,i) = atan(y(k,i)/xdisp) + 2.0*pi
             elseif((y(k,i).eq.0.0).and.(xdisp.gt.0.0)) then
                phinew(k,i) = 0.0
             elseif((y(k,i).eq.0.0).and.(xdisp.lt.0.0)) then
                phinew(k,i) = pi
             elseif((xdisp.eq.0.0).and.(y(k,i).gt.0.0)) then
                phinew(k,i) = 0.5*pi
             elseif((xdisp.eq.0.0).and.(y(k,i).lt.0.0)) then
                phinew(k,i) = 1.5*pi
             else
                phinew(k,i) = 0.0
             endif
          enddo
       enddo

       do i = 1,numphi
          do k = 2,scfr
             do l = 2,scfr-1
                if(rnew(k,i).le.rhf(2)) then
                   index(k,i,1) = 1
                elseif((rhf(l).le.rnew(k,i)).and.                &
                  (rnew(k,i).lt.rhf(l+1))) then
                   index(k,i,1) = l
                endif
             enddo
             if(index(k,i,1).eq.0) index(k,i,1) = scfr-1
          enddo
       enddo
       do i = 1,numphi
          do k = 2,scfr
             do l = 1,numphi-1
                if((phi(l).le.phinew(k,i)).and.                  &
                  (phinew(k,i).lt.phi(l+1))) then
                   index(k,i,2) = l
                endif
             enddo
             if(index(k,i,2).eq.0) then
                index(k,i,2) = numphi
             endif
          enddo
       enddo
       do i = 1,numphi
          do j = 2,scfz
             do k = 2,scfr
                l = index(k,i,1)
                m = index(k,i,2)
                t = (rnew(k,i)-rhf(l))/dr
                u = (phinew(k,i)-phi(m))/dphi
                if(m.eq.1) then
                   mm = numphi
                   mp = 2
                   mpp = 3
                elseif(m.eq.numphi) then
                   mm = numphi - 1
                   mp = 1
                   mpp = 2
                elseif(m.eq.numphi-1) then
                   mm = numphi - 2 
                   mp = numphi
                   mpp = 1
                else
                   mm = m -1
                   mp = m + 1
                   mpp = m + 2
                endif
                lm = l - 1
                lp = l + 1
                lpp = l + 2
                if(l.eq.scfr-1) then
                   rhonew(k,j,i) = 0.0 
                elseif(l.eq.1) then
                   t = 2.0*rnew(k,i)/dr
                   rhonew(k,j,i) = t*(1.0-u)*rho(2,j,m) +              &
                                  t*u*rho(2,j,m+1)
                else
                   f(1) = rho(l,j,m)
                   f(2) = rho(lp,j,m)
                   f(3) = rho(lp,j,mp)
                   f(4) = rho(l,j,mp)
                   dfdr(1) = 0.5*(rho(lp,j,m)-rho(lm,j,m))/dr
                   dfdr(2) = 0.5*(rho(lpp,j,m)-rho(l,j,m))/dr
                   dfdr(3) = 0.5*(rho(lpp,j,mp)-rho(l,j,mp))/dr
                   dfdr(4) = 0.5*(rho(lp,j,mp)-rho(lm,j,mp))/dr
                   dfdp(1) = 0.5*(rho(l,j,mp)-rho(l,j,mm))/dphi
                   dfdp(2) = 0.5*(rho(lp,j,mp)-rho(lp,j,mm))/dphi
                   dfdp(3) = 0.5*(rho(lp,j,mpp)-rho(lp,j,m))/dphi
                   dfdp(4) = 0.5*(rho(l,j,mpp)-rho(l,j,m))/dphi
                   d2f(1) = 0.25*(rho(lp,j,mp)-rho(lp,j,mm)            &
                           -rho(lm,j,mp)+rho(lm,j,mm))/(dr*dphi)
                   d2f(2) = 0.25*(rho(lpp,j,mp)-rho(lpp,j,mm)          &
                           -rho(l,j,mp)+rho(l,j,mm))/(dr*dphi)
                   d2f(3) = 0.25*(rho(lpp,j,mpp)-rho(lpp,j,m)          &
                           -rho(l,j,mpp)+rho(l,j,m))/(dr*dphi)
                   d2f(4) = 0.25*(rho(lp,j,mpp)-rho(lp,j,m)            &
                           -rho(lm,j,mpp)+rho(lm,j,m))/(dr*dphi)
                   call bcucof(f,dfdr,dfdp,d2f,dr,dphi,c)
                   sum = 0.0 
                   do q = 1,4
                      do w = 1,4
                         sum = sum + c(q,w)*(t**(q-1))*(u**(w-1))
                      enddo
                   enddo
                   if(sum.lt.0.0) then
                      rhonew(k,j,i) = 0.0
                   else
                      rhonew(k,j,i) = sum
                   endif
                endif
             enddo
          enddo
       enddo
!  End of translation

!  Set up boundary zones for equatorial plane & z axis
       do i = 1,numphi
          do k = 1,scfr
             rhonew(k,1,i) = rhonew(k,2,i)
          enddo
       enddo
       do i = 1,phic-1
          do j = 1,scfz
             rhonew(1,j,i) = rhonew(2,j,i+numphi/2)
          enddo
       enddo
       do i = phic+1,numphi
          do j = 1,scfz
             rhonew(1,j,i) = rho(2,j,i-numphi/2)
          enddo
       enddo
       do j = 1,scfz
          rhonew(1,j,phic) = rhonew(2,j,1)
       enddo       

       rho=rhonew
       
end subroutine cubic_translation
 

       subroutine bcucof(y,y1,y2,y12,d1,d2,c)
       implicit none
       double precision d1, d2, c(4,4),y(4),y1(4),y2(4),y12(4)
       integer i, j, k, l
       double precision d1d2, xx, cl(16), wt(16,16), x(16)
       save wt
       data wt/1,0,-3,2,4*0,-3,0,9,-6,2,0,-6,4,8*0,3,0,-9,6,-2,0,6,-4    &
              ,10*0,9,-6,2*0,-6,4,2*0,3,-2,6*0,-9,6,2*0,6,-4             &
              ,4*0,1,0,-3,2,-2,0,6,-4,1,0,-3,2,8*0,-1,0,3,-2,1,0,-3,2    &
              ,10*0,-3,2,2*0,3,-2,6*0,3,-2,2*0,-6,4,2*0,3,-2             &
              ,0,1,-2,1,5*0,-3,6,-3,0,2,-4,2,9*0,3,-6,3,0,-2,4,-2        &
              ,10*0,-3,3,2*0,2,-2,2*0,-1,1,6*0,3,-3,2*0,-2,2             &
              ,5*0,1,-2,1,0,-2,4,-2,0,1,-2,1,9*0,-1,2,-1,0,1,-2,1        &
              ,10*0,1,-1,2*0,-1,1,6*0,-1,1,2*0,2,-2,2*0,-1,1/
       d1d2 = d1*d2
       do i = 1,4
          x(i) = y(i)
          x(i+4) = y1(i)*d1
          x(i+8) = y2(i)*d2
          x(i+12) = y12(i)*d1d2
       enddo
       do i = 1,16
          xx = 0.0
          do k = 1,16
             xx = xx + wt(i,k)*x(k)
          enddo
          cl(i) = xx
       enddo
       l = 0
       do i = 1,4
          do j = 1,4
             l = l + 1
             c(i,j) = cl(l)
          enddo
       enddo
       return
       end subroutine bcucof

