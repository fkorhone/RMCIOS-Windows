RMCIOS %0 
exit

create file f
create timer t
create logger l
create multiply m1
create multiply m2
create multiply m3

link t l
link l console
link l f

setup l \n \s rtc_str m1 m2 m3
setup f data/data.txt a 0
setup t 1

# Example data channels:
write m1 1
write m2 2 
write m3 3

