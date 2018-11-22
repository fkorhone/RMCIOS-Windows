RMCIOS %0 
pause
exit

##################################################
# This example counts to file for 5 seconds.

create plus p
create logger l
create fast_clock c
create trigger trg
create file f
create timer stoptimer

link p p
link p trg
link trg l
link l f
link stoptimer exit

setup p 1
setup l \n \s p c
setup f data/count.txt w
setup stoptimer 5

write console "counting to data/count.txt for 5 seconds...\n"

# Start counting
write p 1

