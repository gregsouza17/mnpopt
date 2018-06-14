program RMSDtst
  implicit none

  ! Program that tests if the different methods to obtain
  !   the cost array are resulting in the same values

  ! It initializes a dimension array, an array for each method :
  ! costfst = Cost using regular fortran fast method (stat.f)
  ! costslw = Cost using regular fortran slow method (statslw.f)


  ! it Also creats the integer iwrong to save in which element of the
  ! diffente cost arrays there was an disagreement
  
  integer, parameter:: arrayDim = 631
  double precision :: costfst(arrayDim), costslw(arrayDim), temp(2,arrayDim)
  integer :: iwrong

  !Reads Cost Fast =================================
  open(1,FILE = 'Fcostfast.dat', status='old', action = 'read')
  read(1,*) temp
  
  costfst = temp(2,:)
  !==================================================
  
  !Reads Cost Slow =================================
  open(2, FILE= 'Ccostcpu.dat', status='old', action= 'read')
  read(2,*) temp

  costslw = temp(2,:)
  !==================================================
  

  !Compare Cost Fast with Cost Slow, prints the results
  
  if(isequal(arrayDim, costfst, costslw, iwrong)) then
     write(*,*) " VALID RESULTS: Cost Fast is equal to Cost low"
  else
     write(*,*) "INVALID RESULTS: Cost Fast is different to Cost low"
     write(*,*) "Failure at", iwrong
     write(*,*) "Values", costfst(iwrong), costslw(iwrong)
  end if
  !==================================================
     

  

contains

  function isequal(n, array1, array2, iwrong)
    ! Function to verify if two arrays have equal values in all entries
    !   Input: n -> size of arrays, array 1, array 2, iwrong
    !   Returns: True if the arrays are the same, false otherwise
    !   Modifies: iwrong with the index of the first entry to fail
    ! or 0 otherwise
    logical :: isequal
    integer :: n, iwrong
    double precision :: array1(n), array2(n)
    integer :: i

    !If nothing goes wrong, everything stays TRUE and 0
    iwrong = 0
    isequal = .TRUE.

    do i=1,n
       if(abs(array1(i) - array2(i)) > 10e-05) then
          !if some entry is to far off, it calls then different and
          !returns false
          isequal = .FALSE.
          iwrong = i
          return
       end if
    end do

  end function isequal

  
  

end program RMSDtst

