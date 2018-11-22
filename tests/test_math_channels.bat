RMCIOS %0 
pause
exit

###############################################
# read test framework common channel definitions:
read as control file test_init.ini 

create int i
create float f
create string s

setup description "test int 5"
write i 5
write test_compare int i 5
write i 5.1
write test_compare int i 5
write i 0x05
write test_compare int i 5

setup description "test float 5"
write f 5
write test_compare float f 5

setup description "test float 5.0"
write f 5.0
write test_compare float f 5
setup description "test float 0x05"
write f 0x05
write test_compare float f 5

setup description "test string 5"
setup s 5
write test_compare string s 5

setup description "test int 0x0A"
write i 0x0A
write test_compare int i 10

write f 0x0A
setup description "test float 0x0A"
write test_compare float f 0x0A

setup description "test string 0x0A"
write s 0x0A
write test_compare string s 0x0A

###############################################
# Basic arithmetics
create plus p
create multiply m
create divide d

setup description "test plus=7"
setup p 3
write p 4
write test_compare int p 7

setup description "test multiply=12"
setup m 2
write m 6
write test_compare int m 12

setup description "test divide =3"
setup d 3
write d 9
write test_compare int d 3

###############################################
# PATTERN
create pattern pat

setup description "test pattern=go"
setup pat "start" "stop"
write pat "prefixstartgostopsuffix"
write test_compare string pat "go"

###############################################
# read test results
read as control file test_results.ini 

