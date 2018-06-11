program RMSDtst
  implicit none

  integer, parameter:: arrayDim = 631
  double precision :: costfst(arrayDim), costslw(arrayDim), temp(2,arrayDim)

  open(1,FILE = 'RMSDfst.dat', status='old', action = 'read')
  read(1,*) temp
  
  costfst = temp(2,:)

  open(2, FILE= 'RMSDfst.dat', status='old', action= 'read')

  read(2,*) temp

  costslw = temp(2,:)
  

end program RMSDtst

