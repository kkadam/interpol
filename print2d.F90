subroutine print2d(filename,inarray,rrr,zzz,phiii,phi)
  implicit none

!#### Subroutine parameters ####  
  integer, intent(in) :: rrr,zzz,phiii, phi
  real, dimension(rrr,zzz,phiii), intent(in) :: inarray
  character(len=*), intent(in) :: filename

  integer :: i, j, k


!  print*, filename, rrr,zzz,phiii,phi

  open(unit=10,file=filename)
    do j=1,zzz
       do i=1,rrr
          write(10,*) i,j,inarray(i,j,phi)
       enddo
       write(10,*)
    enddo
  close(10)

  print*,"File ", filename, " printed"

end subroutine print2d
