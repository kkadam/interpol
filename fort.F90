subroutine fort
  implicit none
  include "convertpar.h"
  
  double precision :: temp_dbl1, temp_dbl2, temp_dbl3, temp_dbl4
  integer :: temp_int1, temp_int2, temp_int3, temp_int4



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
  
end subroutine fort  
