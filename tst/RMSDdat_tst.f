program RMSDtst
  implicit none

  integer, parameter:: arrayDim = 631
  real(dp) :: costfst(arrayDim), costslw(arrayDim), temp(2,arrayDim)

  open(1,FILE = 'RMSDfst.dat', status='old', action = 'read')
  read(1,*) temp

  write(*,*) temp(1, :)
  

end program RMSDtst

