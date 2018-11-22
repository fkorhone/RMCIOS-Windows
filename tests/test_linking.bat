RMCIOS %0 
pause
exit

###############################################
# read test framework common channel definitions:
read as control file test_init.ini 

create int i1
create int i2
create float f1
create float f2
create string s1
create string s2

setup description "link int to int"
write i2 0
link i1 0 
link i1 i2
write i1 1
write test_compare int i2 1
write test_compare float i2 1

setup description "link int to float"
write f2 0
link i1 0 
link i1 f2
write i1 1
write test_compare int f2 1
write test_compare float f2 1.0

setup description "link int to string"
write s2 0
link i1 0 
link i1 s2
write i1 1
write test_compare int s2 "1"
write test_compare float s2 1
write test_compare string s2 1

setup description "link float to int"
write i2 0
link f1 0 
link f1 i2
write f1 2.3
write test_compare int i2 2

setup description "link float to float"
write i2 0
link f1 0 
link f1 f2
write f1 2.3
write test_compare float f2 2.3

setup description "link float to string"
write s2 0
link f1 0 
link f1 s2
write f1 2.3
write test_compare string s2 "2.3"

setup description "link string to int"
write i2 0
link s1 0 
link s1 i2
write s1 "3.4mm"
write test_compare int s1 i2 3

setup description "link string to float"
write f2 0
link s1 0 
link s1 f2
write s1 "3.4mm"
write test_compare int s1 f2 3.4

setup description "link string to string"
write s2 0
link s1 0 
link s1 s2
write s1 "3.4mm"
write test_compare string s1 s2 "3.4mm"

###############################################
# read test results
read as control file test_results.ini 

