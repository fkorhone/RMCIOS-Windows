RMCIOS %0 
pause
exit

create string s
create float co2
create float O3
create float RH
create float CO
create float conc
create float temp
create format fr

setup co2 400
setup O3 0.3
setup CO 0.1
setup RH 41
setup temp 22
setup conc 31
setup fr "%s\nCO2:%d O3:%.1f \nRH:%.2f CO:%.1f\nTemp:%.1f %.1f\n" rtc_str co2 O3 RH CO temp conc

link fr console
write fr


