RMCIOS %0 
pause
exit

###############################################
# read test framework common channel definitions:
read as control file test_init.ini 

create string data
create crc crc
link data crc
# reference data: 123456789 from https://crccalc.com/
setup data 123456789

write console "fields:Algorithm Result Poly Init RefIn RefOut XorOut\n"
setup description "CRC-16/CCITT-FALSE 0x29B1 0x1021 0xFFFF 0 0 0x0000"
setup crc 0 0x1021 0xFFFF 0 0 0x0000
write data
write test_compare int crc 0x29B1

setup description "CRC-16/ARC	0xBB3D 0xBB3D 0x0000 1 1 0x0000"
setup crc 0 0x8005 0x0000 1 1 0x0000
write data
write test_compare int crc 0xBB3D

setup description "CRC-16/AUG-CCITT 0xE5CC 0x1021 0x1D0F 0 0 0x0000"
setup crc 0 0x1021 0x1D0F 0 0 0x0000
write data
write test_compare int crc 0xE5CC

setup description "CRC-16/BUYPASS 0xFEE8 0x8005 0x0000 0 0 0x0000"
setup crc 0 0x8005 0x0000 0 0 0x0000
write data
write test_compare int crc 0xFEE8

setup description "CRC-16/CDMA2000 0x4C06 0xC867 0xFFFF 0 0 0x0000"
setup crc 0 0xC867 0xFFFF 0 0 0x0000
write data
write test_compare int crc 0x4C06

setup description "CRC-16/DDS-110 0x9ECF 0x8005 0x800D 0 0 0x0000"
setup crc 0 0x8005 0x800D 0 0 0x0000
write data
write test_compare int crc 0x9ECF

setup description "CRC-16/DECT-R 0x007E 0x0589 0x0000 0 0 0x0001"
setup crc 0 0x0589 0x0000 0 0 0x0001
write data
write test_compare int crc 0x007E

setup description "CRC-16/DECT-X 0x007F 0x0589 0x0000 0 0 0x0000"
setup crc 0 0x0589 0x0000 0 0 0x0000
write data
write test_compare int crc 0x007F

setup description "CRC-16/DNP	0xEA82 0x3D65 0x0000 1 1 0xFFFF"
setup crc 0 0x3D65 0x0000 1 1 0xFFFF
write data
write test_compare int crc 0xEA82

setup description "CRC-16/EN-13757 0xC2B7 0x3D65 0x0000 0 0 0xFFFF"
setup crc 0 0x3D65 0x0000 0 0 0xFFFF
write data
write test_compare int crc 0xC2B7

setup description "CRC-16/GENIBUS 0xD64E 0x1021 0xFFFF 0 0 0xFFFF"
setup crc 0 0x1021 0xFFFF 0 0 0xFFFF
write data
write test_compare int crc 0xD64E

setup description "CRC-16/MAXIM 0x44C2 0x8005 0x0000 1 1 0xFFFF"
setup crc 0 0x8005 0x0000 1 1 0xFFFF
write data
write test_compare int crc 0x44C2

setup description "CRC-16/MCRF4XX 0x6F91 0x1021 0xFFFF 1 1 0x0000"
setup crc 0 0x1021 0xFFFF 1 1 0x0000
write data
write test_compare int crc 0x6F91

setup description "CRC-16/RIELLO 0x63D0 0x1021 0xB2AA 1 1 0x0000"
setup crc 0 0x1021 0xB2AA 1 1 0x0000
write data
write test_compare int crc 0x63D0

setup description "CRC-16/T10-DIF 0xD0DB 0x8BB7 0x0000 0 0 0x0000"
setup crc 0 0x8BB7 0x0000 0 0 0x0000
write data
write test_compare int crc 0xD0DB

setup description "CRC-16/TELEDISK 0x0FB3 0xA097 0x0000 0 0 0x0000"
setup crc 0 0xA097 0x0000 0 0 0x0000
write data
write test_compare int crc 0x0FB3

setup description "CRC-16/TMS37157 0x26B1 0x1021 0x89EC 1 1 0x0000"
setup crc 0 0x1021 0x89EC 1 1 0x0000
write data
write test_compare int crc 0x26B1

setup description "CRC-16/USB	0xB4C8 0x8005 0xFFFF 1 1 0xFFFF"
setup crc 0 0x8005 0xFFFF 1 1 0xFFFF
write data
write test_compare int crc 0xB4C8

setup description "CRC-A 0xBF05 0x1021 0xC6C6 1 1 0x0000"
setup crc 0 0x1021 0xC6C6 1 1 0x0000
write data
write test_compare int crc 0xBF05

setup description "CRC-16/KERMIT 0x2189 0x1021 0x0000 1 1 0x0000"
setup crc 0 0x1021 0x0000 1 1 0x0000
write data
write test_compare int crc 0x2189

setup description "CRC-16/MODBUS 0x4B37 0x8005 0xFFFF 1	1 0x0000"
setup crc 0 0x8005 0xFFFF 1 1 0x0000
write data
write test_compare int crc 0x4B37

setup description "CRC-16/X-25 0x906E 0x1021 0xFFFF 1 1 0xFFFF"
setup crc 0 0x1021 0xFFFF 1 1 0xFFFF
write data
write test_compare int crc 0x906E

setup description "CRC-16/XMODEM 0x31C3 0x1021 0x0000 0 0 0x0000"
setup crc 0 0x1021 0x0000 0 0 0x0000
write data
write test_compare int crc 0x31C3

setup description "CRC-16/ARC	0xBB3D 0x8005 0x0000 1 1 0x0000"
setup crc 0 0x8005 0x0000 1 1 0x0000
write data
write test_compare int crc 0xBB3D

###############################################
# read test results
read as control file test_results.ini 

