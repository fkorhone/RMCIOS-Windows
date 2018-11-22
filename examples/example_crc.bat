RMCIOS %0 
pause
exit

create string data
create crc csum
create format f

link data csum
link csum f
link f console

setup data 123456789
setup f "\n%s 0x%04X " data 0

write console "Data CRC Algorithm:"

setup csum 0 0x1021 0xFFFF 0 0 0x0000
write data
write csum
write console CRC-16/CCITT-FALSE

setup csum 0 0x8005 0x0000 1 1 0x0000
write data
write csum
write console CRC-16/ARC

setup csum 0 0x1021 0x1D0F 0 0 0x0000
write data
write csum
write console CRC-16/AUG-CCITT

setup csum 0 0x8005 0x0000 0 0 0x0000
write data
write csum
write console CRC-16/BUYPASS

setup csum 0 0xC867 0xFFFF 0 0 0x0000
write data
write csum
write console CRC-16/CDMA2000

setup csum 0 0x8005 0x800D 0 0 0x0000
write data
write csum
write console CRC-16/DDS-110

setup csum 0 0x0589 0x0000 0 0 0x0001
write data
write csum
write console CRC-16/DECT-R

setup csum 0 0x0589 0x0000 0 0 0x0000
write data
write csum
write console CRC-16/DECT-X

setup csum 0 0x3D65 0x0000 1 1 0xFFFF
write data
write csum
write console CRC-16/DNP

setup csum 0 0x3D65 0x0000 0 0 0xFFFF
write data
write csum
write console CRC-16/EN-13757

setup csum 0 0x1021 0xFFFF 0 0 0xFFFF
write data
write csum
write console CRC-16/GENIBUS

setup csum 0 0x8005 0x0000 1 1 0xFFFF
write data
write csum
write console CRC-16/MAXIM

setup csum 0 0x1021 0xFFFF 1 1 0x0000
write data
write csum
write console CRC-16/MCRF4XX

setup csum 0 0x1021 0xB2AA 1 1 0x0000
write data
write csum
write console CRC-16/RIELLO

setup csum 0 0x8BB7 0x0000 0 0 0x0000
write data
write csum
write console CRC-16/T10-DIF

setup csum 0 0xA097 0x0000 0 0 0x0000
write data
write csum
write console CRC-16/TELEDISK

setup csum 0 0x1021 0x89EC 1 1 0x0000
write data
write csum
write console CRC-16/TMS37157

setup csum 0 0x8005 0xFFFF 1 1 0xFFFF
write data
write csum
write console CRC-16/USB

setup csum 0 0x1021 0xC6C6 1 1 0x0000
write data
write csum
write console CRC-A

setup csum 0 0x1021 0x0000 1 1 0x0000
write data
write csum
write console CRC-16/KERMIT

setup csum 0 0x8005 0xFFFF 1 1 0x0000
write data
write csum
write console CRC-16/MODBUS

setup csum 0 0x1021 0xFFFF 1 1 0xFFFF
write data
write csum
write console CRC-16/X-25

setup csum 0 0x1021 0x0000 0 0 0x0000
write data
write csum
write console CRC-16/XMODEM

write console \n

