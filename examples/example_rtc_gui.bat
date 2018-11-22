RMCIOS %0 
pause
exit

create window win

write wait 0.1

create timer poll_timer
create rtc_str time_str
create win text timetext

link poll_timer time_str
link time_str timetext
link time_str win
link win exit

setup win 50 50 250 100
setup timetext 10 10 200 20 
setup time_str "%Y-%m-%d %H:%M:%S"
setup poll_timer 1

write hide console

