RMCIOS %0 
pause
exit

create delay d
create plus p
create filter f
create format fm
create fast_clock c

setup p 1
setup d 0.01
setup f 10 <
setup fm "%g %g\n" 0 c

link p d
link d f
link f p
link f fm
link fm console

write p 0


